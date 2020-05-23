//
//  DSTaoGoodsDetailVC.m
//  DS
//
//  Created by 夏增明 on 2020/2/27.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSTaoGoodsDetailVC.h"
#import "DSBannerCell.h"
#import <TYCyclePagerView.h>
#import <TYPageControl.h>
#import <WebKit/WebKit.h>
#import "DSGoodsDetail.h"
#import "DSVipUpOrderVC.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/ALBBSDK.h>
#import <AlibabaAuthSDK/ALBBSession.h>
#import "ALiTradeWebViewController.h"
#import "HXLocationTool_.h"
#import "zhAlertView.h"
#import <zhPopupController.h>

@interface DSTaoGoodsDetailVC ()<TYCyclePagerViewDataSource,TYCyclePagerViewDelegate,HXLocationTool_Delegate>
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cyclePagerView;
@property (nonatomic,strong) TYPageControl *pageControl;
@property (nonatomic, strong) WKWebView  *webView;
@property (weak, nonatomic) IBOutlet UIView *webContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webContentViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *cmm_price;
@property (weak, nonatomic) IBOutlet UIView *coupon_view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coupon_view_height;
@property (weak, nonatomic) IBOutlet UILabel *coupon_amount;
@property (weak, nonatomic) IBOutlet UILabel *marketPrice;
@property (weak, nonatomic) IBOutlet UILabel *coupon_time;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *saleNum;
@property (weak, nonatomic) IBOutlet UILabel *stockNum;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
/** 商品详情 */
@property(nonatomic,strong) DSGoodsDetail *goodsDetail;
/** 淘宝商品详情 */
@property (nonatomic, strong) AlibcTradeProcessSuccessCallback onTradeSuccess;
@property (nonatomic, strong) AlibcTradeProcessFailedCallback onTradeFailure;
@property (nonatomic, strong) loginSuccessCallback onLoginSuccess;
@property (nonatomic, strong) loginFailureCallback onLoginFailure;
/** 定位  */
@property (nonatomic, strong) HXLocationTool_ *location;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *stree;

@end

@implementation DSTaoGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    
    _onTradeSuccess = ^(AlibcTradeResult *tradeProcessResult){
        if(tradeProcessResult.result == AlibcTradeResultTypePaySuccess){
            NSString *tip=[NSString stringWithFormat:@"交易成功:成功的订单%@\n，失败的订单%@\n",[tradeProcessResult payResult].paySuccessOrders,[tradeProcessResult payResult].payFailedOrders];
            HXLog(@"%@",tip);
        }else if(tradeProcessResult.result == AlibcTradeResultTypeAddCard){
            HXLog(@"成功添加到购物车");
        }
    };
    _onTradeFailure=^(NSError *error){
        // 退出交易流程 /** 交易链路中用户取消了操作 */
        if (error.code == AlibcErrorCancelled) {
            return ;
        }
        if (error.code == AlibcErrorInvalidItemID) {
            HXLog(@"itemId无效");
            return ;
        }
        NSDictionary *infor = [error userInfo];
        NSArray *orderid = [infor objectForKey:@"orderIdList"];
        NSString *tip = [NSString stringWithFormat:@"交易失败:\n订单号\n%@",orderid];
        HXLog(@"%@",tip);
    };
    hx_weakify(self);
    _onLoginSuccess = ^(ALBBSession *session) {
        hx_strongify(weakSelf);
        ALBBUser *user = [session getUser];
        [strongSelf getLocationAuthRequest:user.openId];
    };
    _onLoginFailure = ^(ALBBSession *session,NSError *error) {
        NSString *tip = [NSString stringWithFormat:@"授权失败:%@",error.localizedDescription];
        HXLog(@"%@",tip);
    };
    
    [self setUpCyclePagerView];
    
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

    UIView *view = [[UIView alloc] init];
    view.frame = self.buyBtn.bounds;
    [view.layer addSublayer:[UIColor setGradualChangingColor:view fromColor:@"F9AD28" toColor:@"F95628"]];
    [self.buyBtn setBackgroundImage:[view imageWithUIView] forState:UIControlStateNormal];
    
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cyclePagerView.frame) - 15, CGRectGetWidth(self.cyclePagerView.frame), 15);
    self.webView.frame = self.webContentView.bounds;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.goodsDetail && [self.goodsDetail.is_location isEqualToString:@"1"]) {
        [self.location beginUpdatingLocation];
    }
}
-(HXLocationTool_ *)location
{
    if (!_location) {
         _location =  [[HXLocationTool_ alloc] init];// 开启定位
        _location.delegate = self;
    }
    return _location;
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
    
    TYPageControl *pageControl = [[TYPageControl alloc]init];
    pageControl.numberOfPages = 4;
    pageControl.currentPageIndicatorSize = CGSizeMake(12, 6);
    pageControl.pageIndicatorSize = CGSizeMake(6, 6);
    //    pageControl.pageIndicatorImage = HXGetImage(@"灰色渐进器");
    //    pageControl.currentPageIndicatorImage = HXGetImage(@"当前渐进器");
    pageControl.pageIndicatorTintColor = UIColorFromRGB(0xf2f2f2);
    pageControl.currentPageIndicatorTintColor = HXControlBg;
    pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cyclePagerView.frame) - 15, CGRectGetWidth(self.cyclePagerView.frame), 15);
    self.pageControl = pageControl;
    [self.cyclePagerView addSubview:pageControl];
}
#pragma mark -- 接口请求
-(void)getGoodsDetailRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = self.goods_id;//商品id
    parameters[@"is_member_goods"] = @(2);//是否会员商品，0常规商品，1会员礼包商品，2淘宝商品

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"goods_detail_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"status"] integerValue] == 1) {
            strongSelf.goodsDetail = [DSGoodsDetail yy_modelWithDictionary:responseObject[@"result"][@"goods_detail"]];
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
    if ([self.goodsDetail.is_location isEqualToString:@"1"]) {
        [self.location beginUpdatingLocation];// 开始定位
    }
    
    self.pageControl.numberOfPages = self.goodsDetail.goods_adv.count;
    [self.cyclePagerView reloadData];

    [self.goodsName addFlagLabelWithName:self.goodsDetail.cate_flag lineSpace:5.f titleString:self.goodsDetail.goods_name withFont:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]];
    [self.price setFontAttributedText:[NSString stringWithFormat:@"¥%.2f",[self.goodsDetail.discount_price floatValue]] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:14]]];
    [self.cmm_price setFontAttributedText:[NSString stringWithFormat:@"  预估补贴¥%.2f  ",[self.goodsDetail.cmm_price floatValue]] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:10]]];
    [self.marketPrice setFontAttributedText:[NSString stringWithFormat:@"现价¥%.2f",[self.goodsDetail.price floatValue]] andChangeStr:@[[NSString stringWithFormat:@"%.2f",[self.goodsDetail.price floatValue]]] andFont:@[[UIFont fontWithName:@"ArialMT" size: 12]]];
    self.saleNum.text = [NSString stringWithFormat:@"已售出%@件",self.goodsDetail.sale_num];

    if ([self.goodsDetail.coupon_amount floatValue] == 0) {
        self.coupon_view.hidden = YES;
        self.coupon_view_height.constant = 0.f;
    }else{
        self.coupon_view.hidden = NO;
        self.coupon_view_height.constant = 74.f;
        [self.coupon_amount setFontAttributedText:[NSString stringWithFormat:@"¥%.f",[self.goodsDetail.coupon_amount floatValue]] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:14]]];
        self.coupon_time.text = [NSString stringWithFormat:@"%@-%@",self.goodsDetail.coupon_start_time,self.goodsDetail.coupon_end_time];
    }
    
    self.stockNum.text = self.goodsDetail.stock;
    
    NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:10px 10px;}</style></head><body>%@</body></html>",self.goodsDetail.goods_desc];
    [self.webView loadHTMLString:h5 baseURL:[NSURL URLWithString:HXRC_URL_HEADER]];
}
-(void)getLocationAuthRequest:(NSString *)openId
{
    if ([self.goodsDetail.is_location isEqualToString:@"1"]) {
        if (![self isCanUseLocation]) {
            zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"需要获取您的位置信息，该位置信息作为无归属订单的收获地址分佣，若继续下单，则收益归平台所有" constantWidth:HX_SCREEN_WIDTH - 50*2];
            hx_weakify(self);
            zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"继续下单" handler:^(zhAlertButton * _Nonnull button) {
                hx_strongify(weakSelf);
                [strongSelf.zh_popupController dismiss];
                [strongSelf getTaoAuthRequest:openId];
            }];
            zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"去设置" handler:^(zhAlertButton * _Nonnull button) {
                hx_strongify(weakSelf);
                [strongSelf.zh_popupController dismiss];
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];//跳转到本应用的设置页面
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            okButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
            [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
            self.zh_popupController = [[zhPopupController alloc] init];
            [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
        }else{
            [self getTaoAuthRequest:openId];
        }
    }else{
        [self getTaoAuthRequest:openId];
    }
}
-(void)getTaoAuthRequest:(NSString *)openId
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = self.goods_id;//商品id
    parameters[@"city_name"] = self.city;
    parameters[@"district_name"] = self.district;
    parameters[@"stree_name"] = self.stree;
    parameters[@"lng"] = @(self.longitude);
    parameters[@"lat"] = @(self.latitude);
    parameters[@"baichuan_open_id"] = openId;

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"is_oauth_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"status"] integerValue] == 1) {
            if ([responseObject[@"result"][@"is_oauth"] integerValue] == 1) {//需要授权
                [strongSelf openTaoKeAuth:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"oauth_url"]]];
            }else{// 不需要授权
                [strongSelf openTaoKePush:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"taobao_goods_url"]]];
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)openTaoKeAuth:(NSString *)authUrl
{
    ALiTradeWebViewController *webvc = [ALiTradeWebViewController new];
    webvc.openUrl = authUrl;
    hx_weakify(self);
    webvc.authSuccessCall = ^(NSString *url) {
        hx_strongify(weakSelf);
        [strongSelf openTaoKePush:url];
    };
    NSInteger res = [[AlibcTradeSDK sharedInstance].tradeService openByUrl:authUrl identity:@"trade" webView:webvc.webView parentController:self showParams:nil taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:nil tradeProcessFailedCallback:nil];
    if (res == 1) {
        [self.navigationController pushViewController:webvc animated:YES];
    }
}
-(void)openTaoKePush:(NSString *)taoUrl
{
        // 根据商品id创建一个商品详情页对象
        //id<AlibcTradePage> page = [AlibcTradePageFactory itemDetailPage:self.goodsDetail.taobao_item_id];
    
        // 阿里百川电商参数组装
        AlibcTradeShowParams *showParam = [[AlibcTradeShowParams alloc] init];
        // 打开页面的方式 有智能判断和强制拉端(手淘/天猫)两种方式；默认智能判断
        showParam.openType = AlibcOpenTypeAuto;
        // 是否为push方式打开新页面 NO:在当前view controller上present新页面/YES:在传入的UINavigationController中push新页面
        showParam.isNeedPush = YES;
        // 是否需要自定义处理跳手淘/天猫失败后的处理策略，默认未无需自定义
        showParam.isNeedCustomNativeFailMode = YES;
        // 当isNeedCustomNativeFailMode == YES时生效 跳手淘/天猫失败后的处理策略, 默认值为: AlibcNativeFailModeJumpH5
        showParam.nativeFailMode = AlibcNativeFailModeJumpDownloadPage;
        // 优先拉起的linkKey，手淘：@"taobao" 天猫:@"tmall"
        showParam.linkKey = @"taobao";
    
        // 淘客参数
        AlibcTradeTaokeParams *taokeParams = [[AlibcTradeTaokeParams alloc] init];
        taokeParams.pid = self.goodsDetail.taobao_pid;//淘宝联盟pid
        taokeParams.extParams = @{@"DSUserPhone":[MSUserManager sharedInstance].curUserInfo.phone,@"DSUserUid":[MSUserManager sharedInstance].curUserInfo.uid};
        // 返回值 仅一种情况需要媒体处理 即当AlibcTradeShowParams 中 isNeedPush 为YES时.此时需要媒体根据API返回值为1时（应用內H5打开），在传入的UINavigationController中push新页面。
        AlibcWebViewController *webVC =[[AlibcWebViewController alloc] init];
    NSInteger res = [[AlibcTradeSDK sharedInstance].tradeService openByUrl:taoUrl identity:@"trade" webView:nil parentController:self showParams:showParam taoKeParams:taokeParams trackParam:@{@"DSUserPhone":[MSUserManager sharedInstance].curUserInfo.phone,@"DSUserUid":[MSUserManager sharedInstance].curUserInfo.uid,@"isv_code":[MSUserManager sharedInstance].curUserInfo.phone} tradeProcessSuccessCallback:self.onTradeSuccess tradeProcessFailedCallback:self.onTradeFailure];
        if (res == 1) {
            [self.navigationController pushViewController:webVC animated:YES];
        }
}
#pragma mark -- 定位代理
- (void)locationDidEndUpdatingLongitude:(CGFloat)longitude latitude:(CGFloat)latitude city:(NSString *)city district:(NSString *)district stree:(NSString *)stree
{
    self.longitude = longitude;
    self.latitude = latitude;
    self.city = city;
    self.district = district;
    self.stree = stree;
}
#pragma mark -- 点击事件
-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)buyClicked:(UIButton *)sender {
    if(![[ALBBSession sharedInstance] isLogin]) {
        [[ALBBSDK sharedInstance] auth:self successCallback:_onLoginSuccess failureCallback:_onLoginFailure];
    } else {
        // 已经登录
        ALBBUser *user = [[ALBBSession sharedInstance] getUser];
        [self getLocationAuthRequest:user.openId];
    }
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
    return self.goodsDetail.goods_adv.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    DSBannerCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"TopBannerCell" forIndex:index];
    DSGoodsAdv *adv = self.goodsDetail.goods_adv[index];
    cell.adv = adv;
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
    self.pageControl.currentPage = toIndex;
    //[_pageControl setCurrentPage:newIndex animate:YES];
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    
}

@end
