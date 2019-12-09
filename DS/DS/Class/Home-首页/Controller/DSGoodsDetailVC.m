//
//  DSGoodsDetailVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSGoodsDetailVC.h"
#import "DSBannerCell.h"
#import <TYCyclePagerView.h>
#import <TYPageControl.h>
#import <WebKit/WebKit.h>
#import "DSChooseClassView.h"
#import <zhPopupController.h>
#import "DSTakeCouponView.h"
#import "zhAlertView.h"
#import "DSGoodsPosterView.h"
#import "GXSaveImageToPHAsset.h"

@interface DSGoodsDetailVC ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cyclePagerView;
@property (nonatomic,strong) TYPageControl *pageControl;
@property (nonatomic, strong) WKWebView  *webView;
@property (weak, nonatomic) IBOutlet UIView *webContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webContentViewHeight;
/** 商品规格视图 */
@property(nonatomic,strong) DSChooseClassView *chooseClassView;
@end

@implementation DSGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
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
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.jianshu.com/p/65b083e77e20"]]];
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
-(DSChooseClassView *)chooseClassView
{
    if (_chooseClassView == nil) {
        _chooseClassView = [DSChooseClassView loadXibView];
        _chooseClassView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 380);
    }
    return _chooseClassView;
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"商品详情"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(shareClicked) image:HXGetImage(@"分享白")];
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
#pragma mark -- 点击事件
- (void)shareClicked
{
    DSGoodsPosterView *pv = [DSGoodsPosterView loadXibView];
    pv.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, HX_SCREEN_HEIGHT);
    hx_weakify(self);
    pv.posterTypeCall = ^(NSInteger index, UIImage * _Nullable snapShotImage) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        if (snapShotImage) {
//            GXSaveImageToPHAsset *save = [GXSaveImageToPHAsset new];
//            save.targetVC = strongSelf;
//            [save saveImages:@[snapShotImage] comletedCall:^{
//                HXLog(@"图片保存成功");
//            }];
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeCenter;
    [self.zh_popupController presentContentView:pv duration:0.25 springAnimated:NO];
}
- (IBAction)takeCouponClicked:(UIButton *)sender {
    DSTakeCouponView *couponView = [DSTakeCouponView loadXibView];
    couponView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 280.f);
    
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:couponView duration:0.25 springAnimated:NO];
}
- (IBAction)shareToMoneyClicked:(UIButton *)sender {
    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"分享赚说明" message:@"分享赚说明分享赚说明分享赚说明分享赚说明分享赚说明分享赚说明分享赚说明分享赚说明分享赚说明分享赚说明分享赚说明分享赚说明分享赚说明分享赚说明分享赚说明分享赚说明分享赚说明分享赚说明分享赚说明。" constantWidth:HX_SCREEN_WIDTH - 50*2];
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

- (IBAction)chooseGoodsClassClicked:(UIButton *)sender {
//    self.chooseClassView.goodsDetail = self.goodsDetail;
//    hx_weakify(self);
//    self.chooseClassView.goodsHandleCall = ^(NSInteger type) {
//        hx_strongify(weakSelf);
//        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
//        if (type) {
//            if (type == 1) {
//                [strongSelf addOrderCartRequest];
//            }else{
//                GYUpOrderVC *ovc = [GYUpOrderVC new];
//                ovc.goods_id = strongSelf.goods_id;//商品id
//                ovc.goods_num = [NSString stringWithFormat:@"%ld",(long)strongSelf.goodsDetail.buyNum];//商品数量
//                if (strongSelf.goodsDetail.spec && strongSelf.goodsDetail.spec.count) {
//                    NSMutableString *spec_values = [NSMutableString string];
//                    for (GYGoodSpec *spec in strongSelf.goodsDetail.spec) {
//                        if (spec_values.length) {
//                            [spec_values appendFormat:@" %@",spec.selectSpec.spec_value];
//                        }else{
//                            [spec_values appendFormat:@"%@",spec.selectSpec.spec_value];
//                        }
//                    }
//                    ovc.spec_values = spec_values;//商品规格
//                }else{
//                    ovc.spec_values = @"";//商品规格
//                }
//                [strongSelf.navigationController pushViewController:ovc animated:YES];
//            }
//        }
//    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:self.chooseClassView duration:0.25 springAnimated:NO];
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
    return 4;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    DSBannerCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"TopBannerCell" forIndex:index];
   
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
