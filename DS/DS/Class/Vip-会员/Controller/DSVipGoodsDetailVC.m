//
//  DSVipGoodsDetailVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSVipGoodsDetailVC.h"
#import "DSBannerCell.h"
#import <TYCyclePagerView.h>
#import <TYPageControl.h>
#import <WebKit/WebKit.h>

@interface DSVipGoodsDetailVC ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cyclePagerView;
@property (nonatomic,strong) TYPageControl *pageControl;
@property (nonatomic, strong) WKWebView  *webView;
@property (weak, nonatomic) IBOutlet UIView *webContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webContentViewHeight;

@end

@implementation DSVipGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"礼包详情"];
    
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
