//
//  DSOrderDetailVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSOrderDetailVC.h"
#import "DSOrderDetailHeader.h"
#import "DSMyOrderCell.h"
#import "DSOrderDetailFooter.h"
#import "DSRefundDetailFooter.h"
#import "DSExpressDetailVC.h"
#import "DSApplyRefundVC.h"
#import "DSMyOrderDetail.h"
#import "DSWebContentVC.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "DSPayTypeView.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import "DSUpOrderSectionHeader.h"
#import "DSUpOrderSectionFooter.h"

static NSString *const MyOrderCell = @"MyOrderCell";
@interface DSOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) DSOrderDetailHeader *header;
/* 退款状态尾部视图 */
@property(nonatomic,strong) DSRefundDetailFooter *footer;
/* 订单操作视图 */
@property (weak, nonatomic) IBOutlet UIView *handleView;
/* 订单操作视图高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *handleViewHeight;
/* 订单操作第一个按钮 */
@property (weak, nonatomic) IBOutlet UIButton *firstHandleBtn;
/* 订单操作第二个按钮 */
@property (weak, nonatomic) IBOutlet UIButton *secondHandleBtn;
/* 订单操作第三个按钮 */
@property (weak, nonatomic) IBOutlet UIButton *thirdHandleBtn;
/* 订单详情 */
@property(nonatomic,strong) DSMyOrderDetail *orderDetail;
@end

@implementation DSOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:self.isAfterSale?@"退款详情":@"订单详情"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doPayPush:) name:HXPayPushNotification object:nil];
    [self setUpTableView];
    [self startShimmer];
    [self getOrderInfoRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 185);
    self.footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 110);
}

-(DSOrderDetailHeader *)header
{
    if (_header == nil) {
        _header = [DSOrderDetailHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 185);
    }
    return _header;
}
-(DSRefundDetailFooter *)footer
{
    if (_footer == nil) {
        _footer = [DSRefundDetailFooter loadXibView];
        _footer.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 110);
    }
    return _footer;
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
    
    self.tableView.tableHeaderView = self.header;
}
#pragma mark -- 接口请求
-(void)getOrderInfoRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"oid"] = self.oid;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"order_detail_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.orderDetail = [DSMyOrderDetail yy_modelWithDictionary:responseObject[@"result"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleOrderDetailData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)handleOrderDetailData
{
    if (!self.isAfterSale) {// 正常订单
        if ([self.orderDetail.status isEqualToString:@"待付款"]) {
            self.handleView.hidden = NO;
            self.handleViewHeight.constant = 50.f;
            
            self.firstHandleBtn.hidden = YES;
            
            self.secondHandleBtn.hidden = NO;
            [self.secondHandleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            self.secondHandleBtn.backgroundColor = [UIColor whiteColor];
            [self.secondHandleBtn setBackgroundImage:nil forState:UIControlStateNormal];
            self.secondHandleBtn.layer.borderColor = UIColorFromRGB(0xBBBBBB).CGColor;
            [self.secondHandleBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            
            self.thirdHandleBtn.hidden = NO;
            [self.thirdHandleBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            self.thirdHandleBtn.backgroundColor = HXControlBg;
            [self setBtnBackgroundImage:self.thirdHandleBtn];
            self.thirdHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
            [self.thirdHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else if ([self.orderDetail.status isEqualToString:@"待发货"]) {
            self.firstHandleBtn.hidden = YES;
            
            self.secondHandleBtn.hidden = YES;
            
            if ([self.orderDetail.order_type isEqualToString:@"1"]) {
                self.handleView.hidden = NO;
                self.handleViewHeight.constant = 50.f;
                
                self.thirdHandleBtn.hidden = NO;
                [self.thirdHandleBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                self.thirdHandleBtn.backgroundColor = [UIColor whiteColor];
                [self.thirdHandleBtn setBackgroundImage:nil forState:UIControlStateNormal];
                self.thirdHandleBtn.layer.borderColor = UIColorFromRGB(0xBBBBBB).CGColor;
                [self.thirdHandleBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            }else{
                self.handleView.hidden = YES;
                self.handleViewHeight.constant = 0.f;
                
                self.thirdHandleBtn.hidden = YES;
            }
        }else if ([self.orderDetail.status isEqualToString:@"待收货"]) {
            self.handleView.hidden = NO;
            self.handleViewHeight.constant = 50.f;
            
            if ([self.orderDetail.order_type isEqualToString:@"1"]) {
                self.firstHandleBtn.hidden = NO;
                [self.firstHandleBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                self.firstHandleBtn.backgroundColor = [UIColor whiteColor];
                [self.firstHandleBtn setBackgroundImage:nil forState:UIControlStateNormal];
                self.firstHandleBtn.layer.borderColor = UIColorFromRGB(0xBBBBBB).CGColor;
                [self.firstHandleBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            }else{
                self.firstHandleBtn.hidden = YES;
            }
            
            self.secondHandleBtn.hidden = NO;
            [self.secondHandleBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            self.secondHandleBtn.backgroundColor = [UIColor whiteColor];
            [self.secondHandleBtn setBackgroundImage:nil forState:UIControlStateNormal];
            self.secondHandleBtn.layer.borderColor = UIColorFromRGB(0xBBBBBB).CGColor;
            [self.secondHandleBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            
            self.thirdHandleBtn.hidden = NO;
            [self.thirdHandleBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            self.thirdHandleBtn.backgroundColor = HXControlBg;
            [self setBtnBackgroundImage:self.thirdHandleBtn];
            self.thirdHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
            [self.thirdHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            self.handleView.hidden = YES;
            self.handleViewHeight.constant = 0.f;
            
            self.firstHandleBtn.hidden = YES;
            self.secondHandleBtn.hidden = YES;
            self.thirdHandleBtn.hidden = YES;
        }
    }else{//退款订单
          // 1申请中；2退货中(未发货没有此状态)；3退款完成；4退款失败
        if ([self.orderDetail.refund_status isEqualToString:@"4"]) {//如果申请被拒绝，显示查看原因
            self.handleView.hidden = NO;
            self.handleViewHeight.constant = 50.f;

            self.firstHandleBtn.hidden = YES;
            self.secondHandleBtn.hidden = YES;
            
            self.thirdHandleBtn.hidden = NO;
            [self.thirdHandleBtn setTitle:@"查看原因" forState:UIControlStateNormal];
            self.thirdHandleBtn.backgroundColor = HXControlBg;
            [self setBtnBackgroundImage:self.thirdHandleBtn];
            self.thirdHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
            [self.thirdHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            self.handleView.hidden = YES;
            self.handleViewHeight.constant = 0.f;
            self.firstHandleBtn.hidden = YES;
            self.secondHandleBtn.hidden = YES;
            self.thirdHandleBtn.hidden = YES;
        }
        if ([self.orderDetail.refund_status isEqualToString:@"2"] || [self.orderDetail.refund_status isEqualToString:@"3"]) {
            self.tableView.tableFooterView = self.footer;
            self.footer.orderDetail = self.orderDetail;// 退款地址
        }
    }
    self.header.isAfterSale = self.isAfterSale;
    self.header.orderDetail = self.orderDetail;
    hx_weakify(self);
    self.header.lookLogisCall = ^{
        hx_strongify(weakSelf);
        //HXLog(@"查看物流");
        DSWebContentVC *wvc = [DSWebContentVC new];
        wvc.navTitle = @"物流详情";
        wvc.isNeedRequest = NO;
        wvc.url = strongSelf.orderDetail.logistics_url;
        [strongSelf.navigationController pushViewController:wvc animated:YES];
    };

    [self.tableView reloadData];
}
#pragma mark -- 业务逻辑
-(void)setBtnBackgroundImage:(UIButton *)btn
{
    UIView *view = [[UIView alloc] init];
    view.frame = btn.bounds;
    [view.layer addSublayer:[UIColor setGradualChangingColor:view fromColor:@"F9AD28" toColor:@"F95628"]];
    [btn setBackgroundColor:[UIColor colorWithPatternImage:[view imageWithUIView]]];
}
/** 取消订单 */
-(void)cancelOrderRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"oid"] = self.oid;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"order_canel_set" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (strongSelf.orderHandleCall) {
                strongSelf.orderHandleCall(0);
            }
            [strongSelf getOrderInfoRequest];
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
    parameters[@"oid"] = self.oid;

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"order_receive_set" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (strongSelf.orderHandleCall) {
                strongSelf.orderHandleCall(3);
            }
            [strongSelf getOrderInfoRequest];
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
    payType.pay_amount = self.orderDetail.pay_amount;
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
    parameters[@"order_no"] = self.orderDetail.order_no;//商品订单id
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
        if (self.orderHandleCall) {
            self.orderHandleCall(1);
        }
        [self getOrderInfoRequest];
    }else if([note.userInfo[@"result"] isEqualToString:@"2"]){
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"取消支付"];
    }else{
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"支付失败"];
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -- 点击事件
- (IBAction)orderHandleBtnClicked:(UIButton *)sender {
    /**待付款-取消订单、立即支付  待发货-申请退款(vip订单不可退款) 待收货-申请退款(vip订单不可退款)、查看物流、确认收货*/
    hx_weakify(self);
    if (!self.isAfterSale) {// 正常订单
        if (sender.tag == 1) {
            //HXLog(@"申请退款");
            if ([self.orderDetail.refund_status isEqualToString:@"0"]||[self.orderDetail.refund_status isEqualToString:@"4"]) {
                DSApplyRefundVC *rvc = [DSApplyRefundVC new];
                rvc.oid = self.oid;
                rvc.applyRefundActionCall = ^{
                    hx_strongify(weakSelf);
                    if (strongSelf.orderHandleCall) {
                        strongSelf.orderHandleCall(2);
                    }
                    strongSelf.isAfterSale = YES;
                    [strongSelf getOrderInfoRequest];
                };
                [self.navigationController pushViewController:rvc animated:YES];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"该订单正在申请退款"];
            }
        }else if (sender.tag == 2) {
            if ([self.orderDetail.status isEqualToString:@"待付款"]) {
                //HXLog(@"取消订单");
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要取消该订单吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.zh_popupController dismiss];
                }];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确认" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.zh_popupController dismiss];
                    [strongSelf cancelOrderRequest];
                }];
                cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
                self.zh_popupController = [[zhPopupController alloc] init];
                [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }else if ([self.orderDetail.status isEqualToString:@"待收货"]) {
                //HXLog(@"查看物流");
                DSWebContentVC *wvc = [DSWebContentVC new];
                wvc.navTitle = @"物流详情";
                wvc.isNeedRequest = NO;
                wvc.url = self.orderDetail.logistics_url;
                [self.navigationController pushViewController:wvc animated:YES];
            }
        }else{
            if ([self.orderDetail.status isEqualToString:@"待付款"]) {
                //HXLog(@"立即支付");
                [self showPayTypeView];
            }else if ([self.orderDetail.status isEqualToString:@"待发货"]) {
                //HXLog(@"申请退款");
                if ([self.orderDetail.refund_status isEqualToString:@"0"]||[self.orderDetail.refund_status isEqualToString:@"4"]) {
                    DSApplyRefundVC *rvc = [DSApplyRefundVC new];
                    rvc.oid = self.oid;
                    rvc.applyRefundActionCall = ^{
                        hx_strongify(weakSelf);
                        if (strongSelf.orderHandleCall) {
                            strongSelf.orderHandleCall(2);
                        }
                        strongSelf.isAfterSale = YES;
                        [strongSelf getOrderInfoRequest];
                    };
                    [self.navigationController pushViewController:rvc animated:YES];
                }else{
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"该订单正在申请退款"];
                }
            }else if ([self.orderDetail.status isEqualToString:@"待收货"]) {
                //HXLog(@"确认收货");
                if ([self.orderDetail.refund_status isEqualToString:@"0"]||[self.orderDetail.refund_status isEqualToString:@"4"]) {
                    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要确认收货吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
                    zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                        hx_strongify(weakSelf);
                        [strongSelf.zh_popupController dismiss];
                    }];
                    zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确认" handler:^(zhAlertButton * _Nonnull button) {
                        hx_strongify(weakSelf);
                        [strongSelf.zh_popupController dismiss];
                        [strongSelf confirmReceiveGoodRequest];
                    }];
                    cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
                    [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                    okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                    [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                    [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
                    self.zh_popupController = [[zhPopupController alloc] init];
                    [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
                }else{
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"该订单正在申请退款"];
                }
            }
        }
    }else{
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"原因" message:self.orderDetail.reject_reason constantWidth:HX_SCREEN_WIDTH - 50*2];
        hx_weakify(self);
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"我知道了" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
        }];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
        [alert addAction:okButton];
        self.zh_popupController = [[zhPopupController alloc] init];
        [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
    }
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderDetail.list_goods.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.order_type = self.orderDetail.order_type;
    DSMyOrderDetailGoods *detailGoods = self.orderDetail.list_goods[indexPath.row];
    //cell.flag.hidden = [detailGoods.is_discount isEqualToString:@"1"]?NO:YES;
    cell.flag.hidden = YES;
    cell.detailGoods = detailGoods;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 120.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DSUpOrderSectionHeader *header = [DSUpOrderSectionHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 35.f);
    
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.orderDetail) {
//        if ([self.orderDetail.order_type isEqualToString:@"1"]) {//常规
//            return 10.f+120.f+self.orderDetail.remarkTextHeight+10.f+60.f;
//        }else{//vip
//            return 10.f+40.f+self.orderDetail.remarkTextHeight+10.f+60.f;
//        }
        return 35.f+10.f+self.orderDetail.remarkTextHeight+60.f+145.f;

    }else{
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.orderDetail) {
        DSOrderDetailFooter *footer = [DSOrderDetailFooter loadXibView];
//        if ([self.orderDetail.order_type isEqualToString:@"1"]) {//常规
//            footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, (10.f+120.f+self.orderDetail.remarkTextHeight+10.f+60.f));
//        }else{//vip
//            footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, (10.f+40.f+self.orderDetail.remarkTextHeight+10.f+60.f));
//        }
        footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, (35.f+10.f+self.orderDetail.remarkTextHeight+60.f+145.f));
        footer.orderDetail = self.orderDetail;
        return footer;
    }else{
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
//    if (self.refund_id && self.refund_id.length) {
//        GYMyRefundGoods *refundGoods = self.refundDetail.goods[indexPath.row];
//        dvc.goods_id = refundGoods.goods_id;
//    }else{
//        GXMyOrderGoods *goods = self.orderDetail.goods[indexPath.row];
//        dvc.goods_id = goods.goods_id;
//    }
//    [self.navigationController pushViewController:dvc animated:YES];
}

@end
