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

static NSString *const MyOrderCell = @"MyOrderCell";
@interface DSMyOrderChildVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DSMyOrderChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.view.hxn_width = HX_SCREEN_WIDTH;
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
#pragma mark -- 数据请求
-(void)getOrderDataRequest:(BOOL)isRefresh
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"status"] = (self.status == 0)?@"6":@(self.status);
//    if (isRefresh) {
//        parameters[@"page"] = @(1);//第几页
//    }else{
//        NSInteger page = self.pagenum+1;
//        parameters[@"page"] = @(page);//第几页
//    }
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:@"getOrderData" parameters:parameters success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        [strongSelf stopShimmer];
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            if (isRefresh) {
//                [strongSelf.tableView.mj_header endRefreshing];
//                strongSelf.pagenum = 1;
//
//                [strongSelf.orders removeAllObjects];
//                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GYMyOrder class] json:responseObject[@"data"]];
//                [strongSelf.orders addObjectsFromArray:arrt];
//            }else{
//                [strongSelf.tableView.mj_footer endRefreshing];
//                strongSelf.pagenum ++;
//
//                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
//                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GYMyOrder class] json:responseObject[@"data"]];
//                    [strongSelf.orders addObjectsFromArray:arrt];
//                }else{// 提示没有更多数据
//                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//                }
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                strongSelf.tableView.hidden = NO;
//                [strongSelf.tableView reloadData];
//            });
//        }else{
//            strongSelf.tableView.zx_emptyContentView.zx_type = GYUIApiErrorState;
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        hx_strongify(weakSelf);
//        [strongSelf stopShimmer];
//        [strongSelf.tableView.mj_header endRefreshing];
//        [strongSelf.tableView.mj_footer endRefreshing];
//        strongSelf.tableView.zx_emptyContentView.zx_type = GYUINetErrorState;
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
}
/** 拉取线下账号信息 */
-(void)getAccountDataRequest
{
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:@"getAccount" parameters:@{} success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            strongSelf.orderPay = [GYOrderPay yy_modelWithDictionary:responseObject[@"data"]];
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
}
/** 申请退款 */
-(void)orderRefundRequest
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"oid"] = self.currentOrder.oid;
//
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:@"orderRefund" parameters:parameters success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [strongSelf.orders removeObject:strongSelf.currentOrder];
//                [strongSelf.tableView reloadData];
//            });
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
}
/** 取消订单 */
-(void)cancelOrderRequest
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"oid"] = self.currentOrder.oid;
//
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:@"cancelOrder" parameters:parameters success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (strongSelf.status == 0) {
//                    strongSelf.currentOrder.status = @"已取消";
//                }else{
//                    [strongSelf.orders removeObject:strongSelf.currentOrder];
//                }
//                [strongSelf.tableView reloadData];
//            });
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
}
/** 确认收货 */
-(void)confirmReceiveGoodRequest
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"oid"] = self.currentOrder.oid;
//
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:@"confirmReceiveGood" parameters:parameters success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (strongSelf.status == 0) {
//                    strongSelf.currentOrder.status = @"待评价";
//                }else{
//                    [strongSelf.orders removeObject:strongSelf.currentOrder];
//                }
//                [strongSelf.tableView reloadData];
//            });
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
}
#pragma mark -- 调起支付
-(void)showPayTypeView
{
//    GYPayTypeView *payType = [GYPayTypeView loadXibView];
//    payType.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 345.f);
//    payType.orderPay = self.orderPay;
//    hx_weakify(self);
//    payType.confirmPayCall = ^(NSInteger type) {
//        hx_strongify(weakSelf);
//        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
//        [strongSelf orderPayRequest:type];
//    };
//    self.zh_popupController = [[zhPopupController alloc] init];
//    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
//    [self.zh_popupController presentContentView:payType duration:0.25 springAnimated:NO];
}
// 拉取支付信息
-(void)orderPayRequest:(NSInteger)type
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"order_no"] = self.orderPay.order_no;//商品订单id
//    parameters[@"pay_type"] = @(type);//支付方式：1支付宝；2微信支付；3线下支付(后台审核)
//
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:@"orderPay" parameters:parameters success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            //pay_type 支付方式：1支付宝；2微信支付；3线下支付(后台审核)
//            if (type == 1) {
//                [strongSelf doAliPay:responseObject[@"data"]];
//            }else if (type == 2){
//                [strongSelf doWXPay:[responseObject[@"data"] dictionaryWithJsonString]];
//            }else{
//                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [strongSelf.orders removeObject:strongSelf.currentOrder];
//                    [strongSelf.tableView reloadData];
//                });
//            }
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
    
}
// 支付宝支付
-(void)doAliPay:(NSString *)parameters
{
//    NSString *appScheme = @"GYAliPay";
//    // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = parameters;
//
//    // NOTE: 调用支付结果开始支付
//    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//        if ([resultDic[@"resultStatus"] intValue] == 9000) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"支付成功"];
//        }else if ([resultDic[@"resultStatus"] intValue] == 6001){
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"用户中途取消"];
//        }else if ([resultDic[@"resultStatus"] intValue] == 6002){
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"网络连接出错"];
//        }else if ([resultDic[@"resultStatus"] intValue] == 4000){
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"订单支付失败"];
//        }
//    }];
}
// 微信支付
-(void)doWXPay:(NSDictionary *)dict
{
//    if([WXApi isWXAppInstalled]) { // 判断 用户是否安装微信
//
//        //需要创建这个支付对象
//        PayReq *req   = [[PayReq alloc] init];
//        //由用户微信号和AppID组成的唯一标识，用于校验微信用户
//        req.openID = dict[@"appid"];
//
//        // 商家id，在注册的时候给的
//        req.partnerId = dict[@"partnerid"];
//
//        // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
//        req.prepayId  = dict[@"prepayid"];
//
//        // 根据财付通文档填写的数据和签名
//        //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
//        req.package   = dict[@"package"];
//
//        // 随机编码，为了防止重复的，在后台生成
//        req.nonceStr  = dict[@"noncestr"];
//
//        // 这个是时间戳，也是在后台生成的，为了验证支付的
//        req.timeStamp = [dict[@"timestamp"] intValue];
//
//        // 这个签名也是后台做的
//        req.sign = dict[@"sign"];
//
//        //发送请求到微信，等待微信返回onResp
//        [WXApi sendReq:req];
//    }else{
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"未安装微信"];
//    }
}
#pragma mark -- 支付回调处理
-(void)doPayPush:(NSNotification *)note
{
//    if ([note.userInfo[@"result"] isEqualToString:@"1"]) {//支付成功
//        //1成功 2取消支付 3支付失败
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"支付成功"];
//        if (self.status == 0) {
//            self.currentOrder.status = @"待发货";
//        }else{
//            [self.orders removeObject:self.currentOrder];
//        }
//        [self.tableView reloadData];
//    }else if([note.userInfo[@"result"] isEqualToString:@"2"]){
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"取消支付"];
//    }else{
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"支付失败"];
//    }
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    GYMyOrder *order = self.orders[indexPath.section];
//    GYMyOrderGoods *goods = order.goods[indexPath.row];
//    cell.goods = goods;
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
//    GYMyOrder *order = self.orders[section];
//    header.order = order;
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (self.orders && self.orders.count) {
//        GYMyOrder *order = self.orders[section];
//        if ([order.approve_status isEqualToString:@"2"]) {//订单审核通过
//            if ([order.status isEqualToString:@"已完成"] || [order.status isEqualToString:@"已取消"]) {
//                return 40.f;
//            }else{
                return 90.f;
//            }
//        }else{
//            return 40.f;
//        }
//    }else{
//        return CGFLOAT_MIN;
//    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    DSMyOrderFooter *footer = [DSMyOrderFooter loadXibView];
//    GYMyOrder *order = self.orders[section];
//    if ([order.approve_status isEqualToString:@"2"]) {//订单审核通过
//        if ([order.status isEqualToString:@"已完成"] || [order.status isEqualToString:@"已取消"]) {
//            footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 40.f);
//            footer.handleView.hidden = YES;
//        }else{
            footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 90.f);
//            footer.handleView.hidden = NO;
//        }
//    }else{
//        footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 40.f);
//        footer.handleView.hidden = YES;
//    }
//    footer.order = order;
//    hx_weakify(self);
//    footer.orderHandleCall = ^(NSInteger index) {
//        hx_strongify(weakSelf);
//        strongSelf.currentOrder = order;
//        if (index == 1) {
//            if ([order.status isEqualToString:@"待付款"]) {
//                //HXLog(@"取消订单");
//                [strongSelf cancelOrderRequest];
//            }else if ([order.status isEqualToString:@"待收货"]) {
//                //HXLog(@"申请退款");
//                [strongSelf orderRefundRequest];
//            }
//        }else{
//            if ([order.status isEqualToString:@"待付款"]) {
//                //HXLog(@"立即支付");
//                strongSelf.orderPay.order_no = order.order_no;
//                strongSelf.orderPay.pay_amount = order.pay_amount;
//                [strongSelf showPayTypeView];
//            }else if ([order.status isEqualToString:@"待发货"]) {
//                //HXLog(@"申请退款");
//                [strongSelf orderRefundRequest];
//            }else if ([order.status isEqualToString:@"待收货"]) {
//                //HXLog(@"确认收货");
//                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要确认收货吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
//                zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
//                    [strongSelf.zh_popupController dismiss];
//                }];
//                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确认" handler:^(zhAlertButton * _Nonnull button) {
//                    [strongSelf.zh_popupController dismiss];
//                    [strongSelf confirmReceiveGoodRequest];
//                }];
//                cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
//                [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
//                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
//                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
//                [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
//                strongSelf.zh_popupController = [[zhPopupController alloc] init];
//                [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
//            }else if ([order.status isEqualToString:@"待评价"]) {
//                GYEvaluateVC *evc = [GYEvaluateVC new];
//                evc.oid = order.oid;
//                evc.evaluatSuccessCall = ^{
//                    if (strongSelf.status == 0) {
//                        order.status = @"已完成";
//                    }else{
//                        [strongSelf.orders removeObject:order];
//                    }
//                    [tableView reloadData];
//                };
//                [strongSelf.navigationController pushViewController:evc animated:YES];
//            }
//        }
//    };
    return footer;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GYMyOrder *order = self.orders[indexPath.section];
    DSOrderDetailVC *dvc = [DSOrderDetailVC new];
//    if (self.status == 0 || self.status == 1) {
//        dvc.orderPay = self.orderPay;
//    }
//    dvc.oid = order.oid;
//    hx_weakify(self);
//    dvc.orderHandleCall = ^(NSInteger type) {
//        hx_strongify(weakSelf);
//        if (strongSelf.status == 0) {
//            /* 订单操作  0 取消订单 1支付订单 2申请退款 3确认收货 4评价 */
//            if (type == 0) {
//                order.status = @"已取消";
//            }else if (type == 1) {
//                order.status = @"待发货";
//            }else if (type == 2) {
//                [strongSelf.orders removeObject:order];
//            }else if (type == 3) {
//                order.status = @"待评价";
//            }else{
//                order.status = @"已完成";
//            }
//        }else{
//            [strongSelf.orders removeObject:order];
//        }
//        [tableView reloadData];
//    };
    [self.navigationController pushViewController:dvc animated:YES];
}



@end
