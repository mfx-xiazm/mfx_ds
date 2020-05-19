//
//  DSVipCardDetailVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSVipCardDetailVC.h"
#import <WebKit/WebKit.h>
#import "DSVipCardDetailCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "DSVipCardDetail.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import "DSPayTypeView.h"
#import <zhPopupController.h>
#import "DSMyCardVC.h"

static NSString *const VipCardDetailCell = @"VipCardDetailCell";
@interface DSVipCardDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (nonatomic, strong) WKWebView  *webView;
@property (weak, nonatomic) IBOutlet UIView *webContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webContentViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *show_img;
@property (weak, nonatomic) IBOutlet UILabel *member_price;
@property (weak, nonatomic) IBOutlet UILabel *original_price;
@property (weak, nonatomic) IBOutlet UILabel *pro_name;

/* 黑卡详情 */
@property(nonatomic,strong) DSVipCardDetail *cardDetail;
/* 当前选中黑卡的面值 */
@property(nonatomic,strong) DSVipCardPrice *selectPrice;
/* 订单号 */
@property(nonatomic,copy) NSString *order_no;
/* 订单id */
@property(nonatomic,copy) NSString *oid;
@end

@implementation DSVipCardDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:self.navTitle];

    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doPayPush:) name:HXPayPushNotification object:nil];
    [self setUpCollectionView];
    [self startShimmer];
    [self getCardDetialRequest];
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.webContentView addSubview:self.webView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.webView.frame = self.webContentView.bounds;
}
- (WKWebView *)webView {
    if (_webView == nil) {
        _webView = [[WKWebView alloc] initWithFrame:self.webContentView.bounds configuration:[WKWebViewConfiguration new]];
        _webView.scrollView.scrollEnabled = NO;
        [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return _webView;
}
-(void)setUpCollectionView
{
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    flowLayout.header_suspension = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DSVipCardDetailCell class]) bundle:nil] forCellWithReuseIdentifier:VipCardDetailCell];
}
#pragma mark -- 接口请求
-(void)getCardDetialRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"card_type_id"] = self.card_type_id;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"card_type_detail_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"status"] integerValue] == 1) {
            strongSelf.cardDetail = [DSVipCardDetail yy_modelWithDictionary:responseObject[@"result"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleCardDetaiData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)handleCardDetaiData
{
    [self.show_img sd_setImageWithURL:[NSURL URLWithString:self.cardDetail.card_type.show_img]];
   
    DSVipCardPrice *price = self.cardDetail.list.firstObject;
    price.isSelected = YES;
    self.selectPrice = price;
    
    self.member_price.text = [NSString stringWithFormat:@"¥%.2f",[price.member_price floatValue]];
    self.original_price.text = [NSString stringWithFormat:@"原价¥%.2f",[price.original_price floatValue]];
    self.pro_name.text = self.cardDetail.card_type.product_name;
    
    [self.collectionView reloadData];
    
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hx_strongify(weakSelf);
        strongSelf.collectionViewHeight.constant = strongSelf.collectionView.contentSize.height;
    });
    NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:10px 10px;}</style></head><body>%@</body></html>",self.cardDetail.card_type.card_desc];
    [self.webView loadHTMLString:h5 baseURL:[NSURL URLWithString:HXRC_URL_HEADER]];
}
- (IBAction)butClicked:(UIButton *)sender {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"card_id"] = self.selectPrice.card_id;//商品
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"card_order_set" parameters:parameters success:^(id responseObject) {
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
    payType.pay_amount = self.selectPrice.member_price;
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
        // 直接跳转到订单列表
        DSMyCardVC *cvv = [DSMyCardVC new];
        [self.navigationController pushViewController:cvv animated:YES];
    }else if([note.userInfo[@"result"] isEqualToString:@"2"]){
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"取消支付"];
    }else{
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"支付失败"];
    }
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cardDetail.list.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DSVipCardDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VipCardDetailCell forIndexPath:indexPath];
    DSVipCardPrice *price = self.cardDetail.list[indexPath.item];
    cell.price = price;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectPrice.isSelected = NO;
    DSVipCardPrice *price = self.cardDetail.list[indexPath.item];
    price.isSelected = YES;
    self.selectPrice = price;
    [collectionView reloadData];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (HX_SCREEN_WIDTH-10.f*4)/2.0;
    CGFloat height = 40.f;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
}
#pragma mark -- 事件监听
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.webView.hxn_height = self.webView.scrollView.contentSize.height;
        self.webContentViewHeight.constant = self.webView.scrollView.contentSize.height;
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    @try {
        [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    }
    @catch (NSException *exception) {
        HXLog(@"多次删除了");
    }
    @finally {
        HXLog(@"多次删除了");
    }
}
@end
