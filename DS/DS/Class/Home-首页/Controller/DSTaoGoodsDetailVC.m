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

@interface DSTaoGoodsDetailVC ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cyclePagerView;
@property (nonatomic,strong) TYPageControl *pageControl;
@property (nonatomic, strong) WKWebView  *webView;
@property (weak, nonatomic) IBOutlet UIView *webContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webContentViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *saleNum;
@property (weak, nonatomic) IBOutlet UILabel *stockNum;
@property (weak, nonatomic) IBOutlet UILabel *freight;
/** 商品详情 */
@property(nonatomic,strong) DSGoodsDetail *goodsDetail;

/** 淘宝商品详情 */
@property (nonatomic, strong) AlibcTradeProcessSuccessCallback onTradeSuccess;
@property (nonatomic, strong) AlibcTradeProcessFailedCallback onTradeFailure;

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

    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cyclePagerView.frame) - 15, CGRectGetWidth(self.cyclePagerView.frame), 15);
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
-(void)setUpNavBar
{
    //[self.navigationItem setTitle:self.isTaoke?@"商品详情":@"礼包详情"];
    self.hbd_barAlpha = 0;
    self.hbd_barShadowHidden = YES;
    
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
    self.pageControl.numberOfPages = self.goodsDetail.goods_adv.count;
    [self.cyclePagerView reloadData];
    
    [self.goodsName addFlagLabelWithName:self.goodsDetail.cate_flag lineSpace:5.f titleString:self.goodsDetail.goods_name withFont:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]];
    [self.price setFontAttributedText:[NSString stringWithFormat:@"￥%.2f",[self.goodsDetail.price floatValue]] andChangeStr:@"￥" andFont:[UIFont systemFontOfSize:14]];
    self.saleNum.text = [NSString stringWithFormat:@"已售出%@件",self.goodsDetail.sale_num];

    self.stockNum.text = self.goodsDetail.stock;
    
    if (HX_SCREEN_WIDTH > 375.f) {
        [self.webView loadHTMLString:self.goodsDetail.goods_desc baseURL:nil];
    }else{
        NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:10px 10px;}</style></head><body>%@</body></html>",self.goodsDetail.goods_desc];
        [self.webView loadHTMLString:h5 baseURL:nil];
    }
}
#pragma mark -- 点击事件
-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)buyClicked:(UIButton *)sender {
    // 根据商品id创建一个商品详情页对象
    id<AlibcTradePage> page = [AlibcTradePageFactory itemDetailPage:self.goodsDetail.taobao_item_id];
    
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
    NSInteger res = [[AlibcTradeSDK sharedInstance].tradeService openByBizCode:@"detail" page:page webView:webVC.webView parentController:self.navigationController showParams:showParam taoKeParams:taokeParams trackParam:@{@"DSUserPhone":[MSUserManager sharedInstance].curUserInfo.phone,@"DSUserUid":[MSUserManager sharedInstance].curUserInfo.uid,@"isv_code":[MSUserManager sharedInstance].curUserInfo.phone} tradeProcessSuccessCallback:self.onTradeSuccess tradeProcessFailedCallback:self.onTradeFailure];
    if (res == 1) {
        [self.navigationController pushViewController:webVC animated:YES];
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
