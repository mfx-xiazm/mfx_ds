//
//  DSLandOrderDetailVC.m
//  DS
//
//  Created by huaxin-01 on 2020/8/4.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSLandOrderDetailVC.h"
#import "DSMyOrderDetail.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "DSPayTypeView.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

@interface DSLandOrderDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *order_desc;
@property (weak, nonatomic) IBOutlet UIImageView *vipCoverImg;
@property (weak, nonatomic) IBOutlet UILabel *vipGoodName;
@property (weak, nonatomic) IBOutlet UILabel *vipPrice;
@property (weak, nonatomic) IBOutlet UILabel *vip_goods_num;
@property (weak, nonatomic) IBOutlet UILabel *specs_attrs;
@property (weak, nonatomic) IBOutlet UILabel *vip_flag;
@property (weak, nonatomic) IBOutlet UILabel *pay_amount;
@property (weak, nonatomic) IBOutlet UILabel *order_no;
/* 订单操作视图 */
@property (weak, nonatomic) IBOutlet UIView *handleView;
/* 订单操作第一个按钮 */
@property (weak, nonatomic) IBOutlet UIButton *firstHandleBtn;
/* 订单操作第二个按钮 */
@property (weak, nonatomic) IBOutlet UIButton *secondHandleBtn;
/* 订单详情 */
@property(nonatomic,strong) DSMyOrderDetail *orderDetail;
@end

@implementation DSLandOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"订单详情"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doPayPush:) name:HXPayPushNotification object:nil];
    [self startShimmer];
    [self getOrderInfoRequest];
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
            strongSelf.orderDetail.ymd_send_member = strongSelf.ymd_send_member;
            strongSelf.orderDetail.ymd_type = strongSelf.ymd_type;
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
    if ([self.orderDetail.status isEqualToString:@"已取消"]) {
        self.order_desc.text = @"您的订单已取消";
    }else if ([_orderDetail.status isEqualToString:@"待付款"]) {
        self.order_desc.text = @"您的订单待付款";
    }else{
        self.order_desc.text = @"您的订单已完成，棒棒哒";
    }
    DSMyOrderDetailGoods *detailGoods = self.orderDetail.list_goods.firstObject;
    [self.vipCoverImg sd_setImageWithURL:[NSURL URLWithString:detailGoods.cover_img]];
    if ([self.orderDetail.order_type isEqualToString:@"10"]) {
        self.vipGoodName.numberOfLines = [self.orderDetail.ymd_send_member isEqualToString:@"1"]?1:2;
        self.specs_attrs.hidden = [self.orderDetail.ymd_type isEqualToString:@"1"]?NO:YES;
        self.specs_attrs.text = detailGoods.specs_attrs;
        self.vip_flag.hidden = [self.orderDetail.ymd_send_member isEqualToString:@"1"]?NO:YES;
    }else{
        self.vipGoodName.numberOfLines = 2;
        self.specs_attrs.hidden = YES;
        self.vip_flag.hidden = YES;
    }
    [self.vipGoodName setTextWithLineSpace:5.f withString:detailGoods.goods_name withFont:[UIFont systemFontOfSize:14]];
    [self.vipPrice setFontAttributedText:[NSString stringWithFormat:@"¥%@",[detailGoods.is_discount isEqualToString:@"1"]?[detailGoods.discount_price reviseString]:[detailGoods.price reviseString]] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:12]]];
    [self.vip_goods_num setFontAttributedText:[NSString stringWithFormat:@"x%@",detailGoods.goods_num] andChangeStr:@[@"x"] andFont:@[[UIFont systemFontOfSize:12]]];
    
    self.pay_amount.text = [NSString stringWithFormat:@"¥%@",[self.orderDetail.pay_amount reviseString]];
    
    if ([self.orderDetail.status isEqualToString:@"待付款"] || [self.orderDetail.status isEqualToString:@"已取消"]) {
        [self.order_no setTextWithLineSpace:8.f withString:[NSString stringWithFormat:@"订单编号：%@\n数量：x%zd\n下单时间：%@",self.orderDetail.order_no,self.orderDetail.list_goods.count,self.orderDetail.create_time] withFont:[UIFont systemFontOfSize:12]];
    }else{
        [self.order_no setTextWithLineSpace:8.f withString:[NSString stringWithFormat:@"订单编号：%@\n数量：x%zd\n支付方式：%@\n下单时间：%@",self.orderDetail.order_no,self.orderDetail.list_goods.count,[self.orderDetail.pay_type isEqualToString:@"1"]?@"支付宝支付":@"微信支付",self.orderDetail.create_time] withFont:[UIFont systemFontOfSize:12]];
    }
    
    if ([self.orderDetail.status isEqualToString:@"待付款"]) {
        self.handleView.hidden = NO;
        
        self.firstHandleBtn.hidden = NO;
        [self.firstHandleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        self.firstHandleBtn.backgroundColor = [UIColor whiteColor];
        [self.firstHandleBtn setBackgroundImage:nil forState:UIControlStateNormal];
        self.firstHandleBtn.layer.borderColor = UIColorFromRGB(0xBBBBBB).CGColor;
        [self.firstHandleBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        
        self.secondHandleBtn.hidden = NO;
        [self.secondHandleBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        self.secondHandleBtn.backgroundColor = HXControlBg;
        [self setBtnBackgroundImage:self.secondHandleBtn];
        self.secondHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [self.secondHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        self.handleView.hidden = YES;
    }
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
    if (sender.tag == 2) {
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
    }else{
        //HXLog(@"立即支付");
        [self showPayTypeView];
    }
}
- (IBAction)orderNoCopy:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.orderDetail.order_no;
    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"复制成功"];
}

@end
