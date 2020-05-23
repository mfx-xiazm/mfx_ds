//
//  DSVipUpOrderVC.m
//  DS
//
//  Created by 夏增明 on 2019/12/20.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSVipUpOrderVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import "DSPayTypeView.h"
#import <zhPopupController.h>
#import "DSMyAddressVC.h"
#import "DSVipConfirmOrder.h"
#import "DSMyAddress.h"
#import "DSMyOrderVC.h"
#import "HXPlaceholderTextView.h"

@interface DSVipUpOrderVC ()
@property (weak, nonatomic) IBOutlet UIView *noAddressView;
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UILabel *receiver;
@property (weak, nonatomic) IBOutlet UILabel *receiver_phone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *is_default;
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *price_amount;
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;
@property (weak, nonatomic) IBOutlet UILabel *pay_amount;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

/* 订单号 */
@property(nonatomic,copy) NSString *order_no;
/* 订单id */
@property(nonatomic,copy) NSString *oid;
/* 是否要调起支付 */
@property(nonatomic,assign) BOOL isOrderPay;
/* 初始化订单信息 */
@property(nonatomic,strong) DSVipConfirmOrder *confirmOrder;
@end

@implementation DSVipUpOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"提交订单"];
    [self.buyBtn.layer addSublayer:[UIColor setGradualChangingColor:self.buyBtn fromColor:@"F9AD28" toColor:@"F95628"]];

    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doPayPush:) name:HXPayPushNotification object:nil];
    self.remark.placeholder = @"备注请留言";
    [self startShimmer];
    [self getOrderDataInitRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
#pragma mark -- 点击事件

- (IBAction)chooseAddressAction:(UIButton *)sender {
    hx_weakify(self);
    DSMyAddressVC *avc = [DSMyAddressVC new];
    avc.getAddressCall = ^(DSMyAddress * _Nonnull address) {
        hx_strongify(weakSelf);
        strongSelf.confirmOrder.address = address;
        [strongSelf handleConfirmOrderData];
    };
    [self.navigationController pushViewController:avc animated:YES];
}
- (IBAction)upOrderClicked:(UIButton *)sender {
    if (!self.confirmOrder.address || [self.confirmOrder.address.address_id isEqualToString:@"0"]) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择地址"];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = self.goods_id;//商品
    parameters[@"address_id"] = self.confirmOrder.address.address_id;//地址id
    parameters[@"remarks"] = [self.remark hasText]?self.remark.text:@"";//订单备注

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"member_order_set" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.order_no = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"order_no"]];
            strongSelf.oid = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"oid"]];
            [strongSelf showPayTypeView];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)showPayTypeView
{
    DSPayTypeView *payType = [DSPayTypeView loadXibView];
    payType.hxn_size = CGSizeMake(HX_SCREEN_WIDTH-35*2, 205.f);
    payType.pay_amount = self.confirmOrder.pay_amount;
    hx_weakify(self);
    payType.confirmPayCall = ^(NSInteger type) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        if (type) {
            strongSelf.isOrderPay = YES;//调起支付
            [strongSelf orderPayRequest:type];
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeCenter;
    self.zh_popupController.didDismiss = ^(zhPopupController * _Nonnull popupController) {
        hx_strongify(weakSelf);
        if (!strongSelf.isOrderPay) {// 未吊起支付
            // 直接跳转到订单列表
            DSMyOrderVC *ovc = [DSMyOrderVC new];
            [strongSelf.navigationController pushViewController:ovc animated:YES];
        }
    };
    [self.zh_popupController presentContentView:payType duration:0.25 springAnimated:NO];
}
#pragma mark -- 调起支付
// 拉取支付信息
-(void)orderPayRequest:(NSInteger)type
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"order_no"] = self.order_no;//商品订单id
    parameters[@"pay_type"] = @(type);//支付方式：1支付宝；2微信支付；3线下支付(后台审核)

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"payinfo_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            //pay_type 支付方式：1支付宝；2微信支付；3线下支付(后台审核)
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
    }else if([note.userInfo[@"result"] isEqualToString:@"2"]){
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"取消支付"];
    }else{
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"支付失败"];
    }
    // 直接跳转到订单列表
    DSMyOrderVC *ovc = [DSMyOrderVC new];
    [self.navigationController pushViewController:ovc animated:YES];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -- 接口请求
-(void)getOrderDataInitRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = self.goods_id;//商品id

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"member_order_init_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.confirmOrder = [DSVipConfirmOrder yy_modelWithDictionary:responseObject[@"result"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleConfirmOrderData];
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
-(void)handleConfirmOrderData
{
    if (self.confirmOrder.address && ![self.confirmOrder.address.address_id isEqualToString:@"0"]) {
        self.noAddressView.hidden = YES;
        self.addressView.hidden = NO;
        self.receiver.text = self.confirmOrder.address.receiver;
        self.receiver_phone.text = self.confirmOrder.address.receiver_phone;
        self.address.text = [NSString stringWithFormat:@"%@%@",self.confirmOrder.address.area_name,self.confirmOrder.address.address_detail];
        self.is_default.hidden = self.confirmOrder.address.is_default?NO:YES;
    }else{
        self.noAddressView.hidden = NO;
        self.addressView.hidden = YES;
    }

    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:self.confirmOrder.cover_img]];
    [self.goods_name setTextWithLineSpace:5.f withString:self.confirmOrder.goods_name withFont:[UIFont systemFontOfSize:14]];
    [self.price setFontAttributedText:[NSString stringWithFormat:@"¥%@",self.confirmOrder.price] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:12]]];
    [self.num setFontAttributedText:[NSString stringWithFormat:@"x%@",self.confirmOrder.goods_num] andChangeStr:@[@"x"] andFont:@[[UIFont systemFontOfSize:12]]];

    [self.price_amount setFontAttributedText:[NSString stringWithFormat:@"¥%@",self.confirmOrder.price_amount] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:12]]];
    
    [self.pay_amount setFontAttributedText:[NSString stringWithFormat:@"¥%@",self.confirmOrder.pay_amount] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:12]]];
}

@end
