//
//  DSMyOrderChildVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMyOrderChildVC.h"
#import "DSMyOrderCell.h"
#import "DSMyOrderHeader.h"
#import "DSMyOrderFooter.h"
#import "DSOrderDetailVC.h"
#import "DSWebContentVC.h"
#import "DSMyOrder.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "DSExpressDetailVC.h"
#import "DSApplyRefundVC.h"
#import "DSPayTypeView.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

static NSString *const MyOrderCell = @"MyOrderCell";
@interface DSMyOrderChildVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 列表 */
@property(nonatomic,strong) NSMutableArray *orders;
/* 当前操作的订单 */
@property(nonatomic,strong) DSMyOrder *currentOrder;

@end

@implementation DSMyOrderChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setUpRefresh];
    [self setUpEmptyView];
    [self startShimmer];
    [self getOrderDataRequest:YES];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.view.hxn_width = HX_SCREEN_WIDTH;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.orderType == 0 || self.orderType == 1) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doPayPush:) name:HXPayPushNotification object:nil];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.orderType == 0 || self.orderType == 1) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
-(NSMutableArray *)orders
{
    if (_orders == nil) {
        _orders = [NSMutableArray array];
    }
    return _orders;
}
-(void)setUpTableView
{
    self.tableView.rowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSMyOrderCell class]) bundle:nil] forCellReuseIdentifier:MyOrderCell];

}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getOrderDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getOrderDataRequest:NO];
    }];
}
-(void)setUpEmptyView
{
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"no_data" titleStr:nil detailStr:@"暂无内容"];
    emptyView.contentViewOffset = -(self.HXNavBarHeight);
    emptyView.subViewMargin = 20.f;
    emptyView.detailLabTextColor = UIColorFromRGB(0x909090);
    emptyView.detailLabFont = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
    emptyView.autoShowEmptyView = NO;
    self.tableView.ly_emptyView = emptyView;
}
#pragma mark -- 数据请求
-(void)getOrderDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    switch (self.orderType) {
        case 0:
            parameters[@"tabstatus"] = @"全部";//全部,待付款，待收货，待发货，已完成，售后
            break;
        case 1:
            parameters[@"tabstatus"] = @"待付款";//全部,待付款，待收货，待发货，已完成，售后
            break;
        case 2:
            parameters[@"tabstatus"] = @"待发货";//全部,待付款，待收货，待发货，已完成，售后
            break;
        case 3:
            parameters[@"tabstatus"] = @"待收货";//全部,待付款，待收货，待发货，已完成，售后
            break;
        case 4:
            parameters[@"tabstatus"] = @"已完成";//全部,待付款，待收货，待发货，已完成，售后
            break;
        case 5:
            parameters[@"tabstatus"] = @"售后";//全部,待付款，待收货，待发货，已完成，售后
            break;
        default:
            parameters[@"tabstatus"] = @"全部";//全部,待付款，待收货，待发货，已完成，售后
            break;
    }
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"order_list_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;

                [strongSelf.orders removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[DSMyOrder class] json:responseObject[@"result"][@"list"]];
                [strongSelf.orders addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;

                if ([responseObject[@"result"][@"list"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"result"][@"list"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[DSMyOrder class] json:responseObject[@"result"][@"list"]];
                    [strongSelf.orders addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.tableView.hidden = NO;
                [strongSelf.tableView reloadData];
                if (strongSelf.orders.count) {
                    [strongSelf.tableView ly_hideEmptyView];
                }else{
                    [strongSelf.tableView ly_showEmptyView];
                }
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/** 取消订单 */
-(void)cancelOrderRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"oid"] = self.currentOrder.oid;

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"order_canel_set" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (strongSelf.orderType == 0) {
                    strongSelf.currentOrder.status = @"已取消";
                }else{
                    [strongSelf.orders removeObject:strongSelf.currentOrder];
                }
                [strongSelf.tableView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/** 确认收货 */
-(void)confirmReceiveGoodRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"oid"] = self.currentOrder.oid;

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"order_receive_set" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (strongSelf.orderType == 0) {
                    strongSelf.currentOrder.status = @"已完成";
                }else{
                    [strongSelf.orders removeObject:strongSelf.currentOrder];
                }
                [strongSelf.tableView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 调起支付
-(void)showPayTypeView
{
    DSPayTypeView *payType = [DSPayTypeView loadXibView];
    payType.hxn_size = CGSizeMake(HX_SCREEN_WIDTH-35*2, 205.f);
    payType.pay_amount = self.currentOrder.pay_amount;
    hx_weakify(self);
    payType.confirmPayCall = ^(NSInteger type) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        if (type) {
            [strongSelf orderPayRequest:type];
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeCenter;
    [self.zh_popupController presentContentView:payType duration:0.25 springAnimated:NO];
}
// 拉取支付信息
-(void)orderPayRequest:(NSInteger)type
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"order_no"] = self.currentOrder.order_no;//商品订单id
    parameters[@"pay_type"] = @(type);//支付方式：1支付宝；2微信支付；3线下支付(后台审核)

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"payinfo_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            //pay_type 支付方式：1支付宝；2微信支付；
            if (type == 1) {
                [strongSelf doAliPay:responseObject[@"result"]];
            }else {
                [strongSelf doWXPay:responseObject[@"result"]];
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
// 支付宝支付
-(void)doAliPay:(NSDictionary *)parameters
{
    NSString *appScheme = @"DSAliPay";
    NSString *orderString = parameters[@"alipay_param"];
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        if ([resultDic[@"resultStatus"] intValue] == 9000) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"支付成功"];
        }else if ([resultDic[@"resultStatus"] intValue] == 6001){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"用户中途取消"];
        }else if ([resultDic[@"resultStatus"] intValue] == 6002){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"网络连接出错"];
        }else if ([resultDic[@"resultStatus"] intValue] == 4000){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"订单支付失败"];
        }
    }];
}
// 微信支付
-(void)doWXPay:(NSDictionary *)dict
{
    if([WXApi isWXAppInstalled]) { // 判断 用户是否安装微信
        //需要创建这个支付对象
        PayReq *req   = [[PayReq alloc] init];
        //由用户微信号和AppID组成的唯一标识，用于校验微信用户
        req.openID = dict[@"appid"];
        
        // 商家id，在注册的时候给的
        req.partnerId = dict[@"partnerid"];
        
        // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
        req.prepayId  = dict[@"prepayid"];
        
        // 根据财付通文档填写的数据和签名
        //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
        req.package   = dict[@"package"];
        
        // 随机编码，为了防止重复的，在后台生成
        req.nonceStr  = dict[@"noncestr"];
        
        // 这个是时间戳，也是在后台生成的，为了验证支付的
        req.timeStamp = [dict[@"timestamp"] intValue];
        
        // 这个签名也是后台做的
        req.sign = dict[@"sign"];
        
        //发送请求到微信，等待微信返回onResp
        [WXApi sendReq:req];
    }else{
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"未安装微信"];
    }
}
#pragma mark -- 支付回调处理
-(void)doPayPush:(NSNotification *)note
{
    if ([note.userInfo[@"result"] isEqualToString:@"1"]) {//支付成功
        //1成功 2取消支付 3支付失败
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"支付成功"];
        if (self.orderType == 0) {
            self.currentOrder.status = @"待发货";
        }else{
            [self.orders removeObject:self.currentOrder];
        }
        [self.tableView reloadData];
    }else if([note.userInfo[@"result"] isEqualToString:@"2"]){
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"取消支付"];
    }else{
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"支付失败"];
    }
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.orders.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DSMyOrder *order = self.orders[section];
    return order.list_goods.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DSMyOrder *order = self.orders[indexPath.section];
    cell.order_type = order.order_type;
    DSMyOrderGoods *goods = order.list_goods[indexPath.row];
    cell.flag.hidden = [goods.is_discount isEqualToString:@"1"]?NO:YES;
    cell.orderGoods = goods;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 120.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DSMyOrderHeader *header = [DSMyOrderHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44.f);
    DSMyOrder *order = self.orders[section];
    header.isAfterSale = NO;
    header.order = order;
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.orders && self.orders.count) {
        DSMyOrder *order = self.orders[section];
        /**待付款-取消订单、立即支付  待发货-申请退款(vip订单不可退款) 待收货-申请退款(vip订单不可退款)、查看物流、确认收货*/
        if ([order.status isEqualToString:@"已完成"] || [order.status isEqualToString:@"已取消"]) {
            return 40.f;
        }else if ([order.status isEqualToString:@"待发货"]){
            if ([order.order_type isEqualToString:@"1"]) {// 常规商品
                return 90.f;
            }else{// VIP商品
                return 40.f;
            }
        }else {
            return 90.f;
        }
    }else{
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    DSMyOrderFooter *footer = [DSMyOrderFooter loadXibView];
    DSMyOrder *order = self.orders[section];
    if ([order.status isEqualToString:@"已完成"] || [order.status isEqualToString:@"已取消"]) {
        footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 40.f);
        footer.handleView.hidden = YES;
    }else if ([order.status isEqualToString:@"待发货"]){
        if ([order.order_type isEqualToString:@"1"]) {// 常规商品
            footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 90.f);
            footer.handleView.hidden = NO;
        }else{// VIP商品
            footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 40.f);
            footer.handleView.hidden = YES;
        }
    }else{
        footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 90.f);
        footer.handleView.hidden = NO;
    }
    footer.order = order;
    hx_weakify(self);
    footer.orderHandleCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        strongSelf.currentOrder = order;
        /**待付款-取消订单、立即支付  待发货-申请退款(vip订单不可退款) 待收货-申请退款(vip订单不可退款)、查看物流、确认收货*/
        if (index == 1) {
            //HXLog(@"申请退款");
            if ([order.refund_status isEqualToString:@"0"]||[order.refund_status isEqualToString:@"4"]) {
                DSApplyRefundVC *rvc = [DSApplyRefundVC new];
                rvc.oid = order.oid;
                rvc.applyRefundActionCall = ^{
                    order.refund_status = @"1";
                    //                [strongSelf.orders removeObject:order];
                    //                [tableView reloadData];
                };
                [strongSelf.navigationController pushViewController:rvc animated:YES];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"该订单正在申请退款"];
            }
        }else if (index == 2) {
            if ([order.status isEqualToString:@"待付款"]) {
                //HXLog(@"取消订单");
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要取消该订单吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                    [strongSelf.zh_popupController dismiss];
                }];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确认" handler:^(zhAlertButton * _Nonnull button) {
                    [strongSelf.zh_popupController dismiss];
                    [strongSelf cancelOrderRequest];
                }];
                cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
                strongSelf.zh_popupController = [[zhPopupController alloc] init];
                [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }else if ([order.status isEqualToString:@"待收货"]) {
                //HXLog(@"查看物流");
                DSWebContentVC *wvc = [DSWebContentVC new];
                wvc.navTitle = @"物流详情";
                wvc.isNeedRequest = NO;
                wvc.url = [order.logistics_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [strongSelf.navigationController pushViewController:wvc animated:YES];
            }
        }else{
            if ([order.status isEqualToString:@"待付款"]) {
                //HXLog(@"立即支付");
                [strongSelf showPayTypeView];
            }else if ([order.status isEqualToString:@"待发货"]) {
                //HXLog(@"申请退款");
                if ([order.refund_status isEqualToString:@"0"]||[order.refund_status isEqualToString:@"4"]) {
                    DSApplyRefundVC *rvc = [DSApplyRefundVC new];
                    rvc.oid = order.oid;
                    rvc.applyRefundActionCall = ^{
                        order.refund_status = @"1";
                        //                    [strongSelf.orders removeObject:order];
                        //                    [tableView reloadData];
                    };
                    [strongSelf.navigationController pushViewController:rvc animated:YES];
                }else{
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"该订单正在申请退款"];
                }
            }else if ([order.status isEqualToString:@"待收货"]) {
                //HXLog(@"确认收货");
                if ([order.refund_status isEqualToString:@"0"]||[order.refund_status isEqualToString:@"4"]) {
                    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要确认收货吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
                    zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                        [strongSelf.zh_popupController dismiss];
                    }];
                    zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确认" handler:^(zhAlertButton * _Nonnull button) {
                        [strongSelf.zh_popupController dismiss];
                        [strongSelf confirmReceiveGoodRequest];
                    }];
                    cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
                    [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                    okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                    [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                    [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
                    strongSelf.zh_popupController = [[zhPopupController alloc] init];
                    [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
                }else{
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"该订单正在申请退款"];
                }
            }
        }
    };
    return footer;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DSMyOrder *order = self.orders[indexPath.section];
    DSOrderDetailVC *dvc = [DSOrderDetailVC new];
    dvc.isAfterSale = NO;
    dvc.oid = order.oid;
    hx_weakify(self);
    dvc.orderHandleCall = ^(NSInteger type) {
        hx_strongify(weakSelf);
        if (strongSelf.orderType == 0) {
            /* 订单操作  0取消订单 1支付订单 2申请退款 3确认收货 */
            if (type == 0) {
                order.status = @"已取消";
            }else if (type == 1) {
                order.status = @"待发货";
            }else if (type == 2) {
//                [strongSelf.orders removeObject:order];
            }else{
                order.status = @"已完成";
            }
        }else{
            if (strongSelf.orderType != 2 && strongSelf.orderType != 3) {
                [strongSelf.orders removeObject:order];
            }
        }
        [tableView reloadData];
    };
    [self.navigationController pushViewController:dvc animated:YES];
}



@end
