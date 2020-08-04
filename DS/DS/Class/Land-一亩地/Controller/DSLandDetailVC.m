//
//  DSLandDetailVC.m
//  DS
//
//  Created by huaxin-01 on 2020/7/29.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSLandDetailVC.h"
#import "DSBannerCell.h"
#import <TYCyclePagerView.h>
#import <TYPageControl.h>
#import <WebKit/WebKit.h>
#import "DSLandDetail.h"
#import "DSWebContentVC.h"
#import "DSChooseClassCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "DSUpOrderVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import "DSPayTypeView.h"
#import <zhPopupController.h>
#import "DSMyOrderVC.h"

static NSString *const ChooseClassCell = @"ChooseClassCell";
@interface DSLandDetailVC ()<TYCyclePagerViewDataSource,TYCyclePagerViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cyclePagerView;
@property (nonatomic, strong) WKWebView  *webView;
@property (weak, nonatomic) IBOutlet UIView *webContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webContentViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *currentPage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (nonatomic, strong) DSLandDetail *landDetail;
/* 订单号 */
@property(nonatomic,copy) NSString *order_no;
/* 订单id */
@property(nonatomic,copy) NSString *oid;
/* 是否要调起支付 */
@property(nonatomic,assign) BOOL isOrderPay;
@end

@implementation DSLandDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doPayPush:) name:HXPayPushNotification object:nil];
    [self setUpNavBar];
    [self setUpCyclePagerView];
    [self setUpCollectionView];
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.webContentView addSubview:self.webView];
    [self startShimmer];
    [self getGoodsDetailRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.webView.frame = self.webContentView.bounds;
}
- (WKWebView *)webView {
    if (_webView == nil) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        //下方代码，禁止缩放
        WKUserContentController *userController = [WKUserContentController new];
        NSString *js = @" $('meta[name=description]').remove(); $('head').append( '<meta name=\"viewport\" content=\"width=device-width, initial-scale=1,user-scalable=no\">' );";
        WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
        [userController addUserScript:script];
        config.userContentController = userController;
        _webView = [[WKWebView alloc] initWithFrame:self.webContentView.bounds configuration:config];
        _webView.scrollView.scrollEnabled = NO;
        [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return _webView;
}
-(void)setUpNavBar
{
    //[self.navigationItem setTitle:self.isTaoke?@"商品详情":@"礼包详情"];
    self.hbd_barAlpha = 0;
    self.hbd_barShadowHidden = YES;
    self.hbd_barStyle = UIBarStyleDefault;

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backClicked) image:HXGetImage(@"详情返回")];
}
-(void)setUpCyclePagerView
{
    self.cyclePagerView.isInfiniteLoop = YES;
    self.cyclePagerView.autoScrollInterval = 3.0;
    self.cyclePagerView.dataSource = self;
    self.cyclePagerView.delegate = self;
    // registerClass or registerNib
    [self.cyclePagerView registerNib:[UINib nibWithNibName:NSStringFromClass([DSBannerCell class]) bundle:nil] forCellWithReuseIdentifier:@"TopBannerCell"];
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
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.scrollEnabled = NO;
    //    self.collectionView.contentInset = UIEdgeInsetsMake(self.HXNavBarHeight, 0, 0, 0);
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DSChooseClassCell class]) bundle:nil] forCellWithReuseIdentifier:ChooseClassCell];
}
#pragma mark -- 接口请求
-(void)getGoodsDetailRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = self.goods_id;//商品id
    parameters[@"is_member_goods"] = @(3);//是否会员商品，0常规商品，1会员礼包商品，2淘宝商品，3一亩地商品

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"goods_detail_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"status"] integerValue] == 1) {
            strongSelf.landDetail = [DSLandDetail yy_modelWithDictionary:responseObject[@"result"][@"goods_detail"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleGoodsDetailData];
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
-(void)handleGoodsDetailData
{
    [self.cyclePagerView reloadData];
    
    [self.goodsName setTextWithLineSpace:5.f withString:self.landDetail.goods_name withFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium]];

    if ([self.landDetail.is_nmj isEqualToString:@"1"]) {//碾米机商品
        self.collectionViewHeight.constant = 20.f;
        self.collectionView.hidden = YES;
    }else{// 一亩地
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
        hx_weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hx_strongify(weakSelf);
            strongSelf.collectionViewHeight.constant = strongSelf.collectionView.contentSize.height;
        });
    }
    DSLandGoodsSku *sku = self.landDetail.goods_sku.firstObject;
    sku.isSelected = YES;
    self.landDetail.selectSku = sku;
    self.price.text = [NSString stringWithFormat:@"¥%@",sku.price];
    
    NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:10px 10px;}</style></head><body>%@</body></html>",self.landDetail.goods_desc];
    [self.webView loadHTMLString:h5 baseURL:[NSURL URLWithString:HXRC_URL_HEADER]];
}
#pragma mark -- 点击事件
-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)userAgreementClicked:(UIButton *)sender {
    DSWebContentVC *web = [DSWebContentVC new];
    web.isNeedRequest = NO;
    web.navTitle = @"鲸宇粮仓用户协议";
    web.htmlContent = self.landDetail.land_user_license;
    [self.navigationController pushViewController:web animated:YES];
}
- (IBAction)applyClicked:(UIButton *)sender {
    if ([self.landDetail.is_nmj isEqualToString:@"1"]) {//碾米机商品，走自营商品下单流程
        DSUpOrderVC *ovc = [DSUpOrderVC new];
        ovc.isCartPush = NO;
        NSString *goods_data = [NSString stringWithFormat:@"[{\"goods_id\":\"%@\",\"sku_id\":\"%@\",\"num\":\"%@\",\"share_uid\":\"%@\"}]",self.goods_id,self.landDetail.selectSku.sku_id,@(1),@"0"];
        ovc.goods_data = goods_data;
        [self.navigationController pushViewController:ovc animated:YES];
    }else{// 一亩地
        if ([self.landDetail.selectSku.is_send_nmj isEqualToString:@"1"]) {//购地送碾米机，走自营商品下单流程
            DSUpOrderVC *ovc = [DSUpOrderVC new];
            ovc.isCartPush = NO;
            NSString *goods_data = [NSString stringWithFormat:@"[{\"goods_id\":\"%@\",\"sku_id\":\"%@\",\"num\":\"%@\",\"share_uid\":\"%@\"}]",self.goods_id,self.landDetail.selectSku.sku_id,@(1),@"0"];
            ovc.goods_data = goods_data;
            [self.navigationController pushViewController:ovc animated:YES];
        }else{// 直接下单支付
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"goods_data"] = [NSString stringWithFormat:@"[{\"goods_id\":\"%@\",\"sku_id\":\"%@\",\"num\":\"%@\",\"share_uid\":\"%@\"}]",self.goods_id,self.landDetail.selectSku.sku_id,@(1),@"0"];;//商品

            hx_weakify(self);
            [HXNetworkTool POST:HXRC_M_URL action:@"land_order_set" parameters:parameters success:^(id responseObject) {
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
    }
}
-(void)showPayTypeView
{
    DSPayTypeView *payType = [DSPayTypeView loadXibView];
    payType.hxn_size = CGSizeMake(HX_SCREEN_WIDTH-35*2, 205.f);
    payType.pay_amount = self.landDetail.selectSku.price;
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
    }else if([note.userInfo[@"result"] isEqualToString:@"2"]){
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"取消支付"];
    }else{
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"支付失败"];
    }
    // 直接跳转到订单列表
    DSMyOrderVC *ovc = [DSMyOrderVC new];
    [self.navigationController pushViewController:ovc animated:YES];
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
#pragma mark -- TYCyclePagerView代理
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.landDetail.goods_adv.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    DSBannerCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"TopBannerCell" forIndex:index];
    DSLandGoodsAdv *landGoodsAdv = self.landDetail.goods_adv[index];
    cell.landGoodsAdv = landGoodsAdv;
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc] init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame), CGRectGetHeight(pageView.frame));
    layout.itemSpacing = 0;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    //[_pageControl setCurrentPage:newIndex animate:YES];
    self.currentPage.text = [NSString stringWithFormat:@"%zd/%zd",toIndex+1,self.landDetail.goods_adv.count];
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.landDetail.goods_sku.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 4;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DSChooseClassCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ChooseClassCell forIndexPath:indexPath];
    DSLandGoodsSku *landSku = self.landDetail.goods_sku[indexPath.item];
    cell.landSku = landSku;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (HX_SCREEN_WIDTH-12.0*2.0-10*3.0)/4.0;
    CGFloat height = 34.f;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(10.f, 12.f, 10.f, 12.f);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DSLandGoodsSku *sku = self.landDetail.selectSku;
    sku.isSelected = NO;
    
    DSLandGoodsSku *landSku = self.landDetail.goods_sku[indexPath.item];
    landSku.isSelected = YES;
    
    self.landDetail.selectSku = landSku;
    self.price.text = [NSString stringWithFormat:@"¥%@",self.landDetail.selectSku.price];
    [collectionView reloadData];
}
@end
