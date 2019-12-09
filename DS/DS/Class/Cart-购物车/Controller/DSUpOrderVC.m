//
//  DSUpOrderVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSUpOrderVC.h"
#import "DSUpOrderHeader.h"
#import "DSMyOrderCell.h"
#import "DSUpOrderFooter.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import "DSPayTypeView.h"
#import <zhPopupController.h>

static NSString *const UpOrderCell = @"UpOrderCell";
@interface DSUpOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) DSUpOrderHeader *header;
/* 尾视图 */
@property(nonatomic,strong) DSUpOrderFooter *footer;
@end

@implementation DSUpOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"提交订单"];
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doPayPush:) name:HXPayPushNotification object:nil];
    [self setUpTableView];
//    [self getConfirmOrderDataRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 90.f);
    self.footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 200.f);
}
-(DSUpOrderHeader *)header
{
    if (_header == nil) {
        _header = [DSUpOrderHeader loadXibView];
        _header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 90.f);
//        hx_weakify(self);
//        _header.addressClickedCall = ^{
//            hx_strongify(weakSelf);
//            GYMyAddressVC *avc = [GYMyAddressVC new];
//            avc.getAddressCall = ^(GYConfirmAddress * _Nonnull address) {
//                strongSelf.confirmOrder.defaultAddress = address;
//                [strongSelf handleConfirmOrderData];
//            };
//            [strongSelf.navigationController pushViewController:avc animated:YES];
//        };
    }
    return _header;
}
-(DSUpOrderFooter *)footer
{
    if (_footer == nil) {
        _footer = [DSUpOrderFooter loadXibView];
        _footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 200.f);
//        hx_weakify(self);
//        _footer.faPiaoClickedCall = ^{
//            hx_strongify(weakSelf);
//            GYInvoiceVC *ivc = [GYInvoiceVC new];
//            if (strongSelf.confirmOrder.userInvoice) {
//                ivc.userInvoice = strongSelf.confirmOrder.userInvoice;
//            }
//            ivc.saveInvoiceCall = ^{
//                [strongSelf getConfirmOrderDataRequest];
//            };
//            [strongSelf.navigationController pushViewController:ivc animated:YES];
//        };
    }
    return _footer;
}
#pragma mark -- 视图相关
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.rowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = HXGlobalBg;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSMyOrderCell class]) bundle:nil] forCellReuseIdentifier:UpOrderCell];
    
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
}
#pragma mark -- 点击事件
- (IBAction)upOrderClicked:(UIButton *)sender {
    [self showPayTypeView];
//    if (!self.confirmOrder.defaultAddress) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择地址"];
//        return;
//    }
//    if (self.footer.openPiao.isSelected && !self.confirmOrder.userInvoice) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写开票信息"];
//        return;
//    }
//
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//
//    if (self.isCartPush) {
//        parameters[@"cart_ids"] = self.cart_ids;//商品id
//        parameters[@"address_id"] = self.confirmOrder.defaultAddress.address_id;//收货地址id
//        NSMutableString *order_note = [NSMutableString string];
//        for (GYConfirmGoodsDetail *goodsDetail in self.confirmOrder.goodsData.goodsDetail) {
//            if (goodsDetail.remark && goodsDetail.remark.length) {
//                if (order_note.length) {
//                    [order_note appendFormat:@"_%@",goodsDetail.remark];
//                }else{
//                    [order_note appendFormat:@"%@",goodsDetail.remark];
//                }
//            }
//        }
//        parameters[@"order_note"] = order_note;//下单时候的备注说明 多个商品备注之间用"_"隔开有的商品没填备注用空字符串
//        parameters[@"order_invoice"] = @(self.footer.openPiao.isSelected);//订单是否开发票 为开发票 0为不开发票
//    }else{
//        parameters[@"goods_id"] = self.goods_id;//商品id
//        parameters[@"address_id"] = self.confirmOrder.defaultAddress.address_id;//收货地址id
//        NSMutableString *order_note = [NSMutableString string];
//        for (GYConfirmGoodsDetail *goodsDetail in self.confirmOrder.goodsData.goodsDetail) {
//            if (goodsDetail.remark && goodsDetail.remark.length) {
//                if (order_note.length) {
//                    [order_note appendFormat:@"_%@",goodsDetail.remark];
//                }else{
//                    [order_note appendFormat:@"%@",goodsDetail.remark];
//                }
//            }
//        }
//        parameters[@"order_note"] = order_note;//下单时候的备注说明 多个商品备注之间用"_"隔开有的商品没填备注用空字符串
//        parameters[@"order_invoice"] = @(self.footer.openPiao.isSelected);//订单是否开发票 为开发票 0为不开发票
//        parameters[@"goods_num"] = self.goods_num;//商品数量
//        parameters[@"spec_values"] = self.spec_values;//商品规格
//    }
//
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:self.isCartPush?@"saveOrder":@"saveOderData" parameters:parameters success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            if (strongSelf.upOrderSuccessCall) {
//                strongSelf.upOrderSuccessCall();
//            }
//            strongSelf.orderPay = [GYOrderPay yy_modelWithDictionary:responseObject[@"data"]];
//            [strongSelf showPayTypeView];
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
}
-(void)showPayTypeView
{
    DSPayTypeView *payType = [DSPayTypeView loadXibView];
    payType.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 285.f);
//    payType.orderPay = self.orderPay;
//    hx_weakify(self);
//    payType.confirmPayCall = ^(NSInteger type) {
//        hx_strongify(weakSelf);
//        strongSelf.isOrderPay = YES;//调起支付
//        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
//        [strongSelf orderPayRequest:type];
//    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
//    self.zh_popupController.didDismiss = ^(zhPopupController * _Nonnull popupController) {
//        hx_strongify(weakSelf);
//        if (!strongSelf.isOrderPay) {// 未吊起支付
//            // 直接跳转到订单列表
//            GYMyOrderVC *ovc = [GYMyOrderVC new];
//            ovc.isPushOrder = YES;
//            [strongSelf.navigationController pushViewController:ovc animated:YES];
//        }
//    };
    [self.zh_popupController presentContentView:payType duration:0.25 springAnimated:NO];
}
#pragma mark -- 调起支付
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
//                // 跳转订单列表
//                GYMyOrderVC *ovc = [GYMyOrderVC new];
//                ovc.isPushOrder = YES;
//                [strongSelf.navigationController pushViewController:ovc animated:YES];
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
    NSString *appScheme = @"GYAliPay";
    // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = parameters;
    
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
#pragma mark -- 接口请求
-(void)getConfirmOrderDataRequest
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    if (self.isCartPush) {
//        parameters[@"cart_ids"] = self.cart_ids;//商品id
//    }else{
//        parameters[@"goods_id"] = self.goods_id;//商品id
//        parameters[@"goods_num"] = self.goods_num;//商品数量
//        parameters[@"spec_values"] = self.spec_values;//商品规格
//    }
//
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:self.isCartPush?@"getConfirmOrderData":@"getConfirmData" parameters:parameters success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        [strongSelf stopShimmer];
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            strongSelf.confirmOrder = [GYConfirmOrder yy_modelWithDictionary:responseObject[@"data"]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                strongSelf.tableView.hidden = NO;
//                [strongSelf handleConfirmOrderData];
//            });
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        hx_strongify(weakSelf);
//        [strongSelf stopShimmer];
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
}
-(void)handleConfirmOrderData
{
//    if (self.confirmOrder.defaultAddress) {
//        self.header.noAddressView.hidden = YES;
//        self.header.addressView.hidden = NO;
//        self.header.defaultAddress = self.confirmOrder.defaultAddress;
//    }else{
//        self.header.noAddressView.hidden = NO;
//        self.header.addressView.hidden = YES;
//    }
//
//    if (self.confirmOrder.userInvoice) {
//        self.footer.userInvoice = self.confirmOrder.userInvoice;
//    }
//
//    [self.tableView reloadData];
//
//    self.total_pay_orice.text = [NSString stringWithFormat:@"%@元",self.confirmOrder.goodsData.totalPayAmount];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:UpOrderCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    GYConfirmGoodsDetail *goods = self.confirmOrder.goodsData.goodsDetail[indexPath.row];
//    cell.goods = goods;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 120.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
