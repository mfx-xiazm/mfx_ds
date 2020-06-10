//
//  DSAfreshHomeHeader.m
//  DS
//
//  Created by huaxin-01 on 2020/5/18.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSAfreshHomeHeader.h"
#import "DSBannerCell.h"
#import <TYCyclePagerView.h>
#import <TYPageControl.h>
#import "DSHomeCateCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "DSHomeData.h"

static NSString *const HomeCateCell = @"HomeCateCell";
@interface DSAfreshHomeHeader ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cyclePagerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) TYPageControl *pageControl;
@end
@implementation DSAfreshHomeHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.cyclePagerView.isInfiniteLoop = YES;
    self.cyclePagerView.autoScrollInterval = 3.0;
    self.cyclePagerView.dataSource = self;
    self.cyclePagerView.delegate = self;
    // registerClass or registerNib
    [self.cyclePagerView registerNib:[UINib nibWithNibName:NSStringFromClass([DSBannerCell class]) bundle:nil] forCellWithReuseIdentifier:@"TopBannerCell"];
    
    TYPageControl *pageControl = [[TYPageControl alloc]init];
    pageControl.numberOfPages = 3;
    pageControl.currentPageIndicatorSize = CGSizeMake(12, 6);
    pageControl.pageIndicatorSize = CGSizeMake(6, 6);
    //    pageControl.pageIndicatorImage = HXGetImage(@"灰色渐进器");
    //    pageControl.currentPageIndicatorImage = HXGetImage(@"当前渐进器");
    pageControl.pageIndicatorTintColor = UIColorFromRGB(0xFFFFFF);
    pageControl.currentPageIndicatorTintColor = HXControlBg;
    pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cyclePagerView.frame)- 20.f, CGRectGetWidth(self.cyclePagerView.frame), 15.f);
    self.pageControl = pageControl;
    [self.cyclePagerView addSubview:pageControl];
    
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
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DSHomeCateCell class]) bundle:nil] forCellWithReuseIdentifier:HomeCateCell];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cyclePagerView.frame) - 20.f, CGRectGetWidth(self.cyclePagerView.frame), 15.f);
}
-(void)setHomeData:(DSHomeData *)homeData
{
    _homeData = homeData;
    self.pageControl.numberOfPages = _homeData.adv.count;
    [self.cyclePagerView reloadData];
    
    [self.collectionView reloadData];
}
#pragma mark -- TYCyclePagerView代理
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.homeData.adv.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    DSBannerCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"TopBannerCell" forIndex:index];
    DSHomeBanner *banner = self.homeData.adv[index];
    cell.banner = banner;
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
    // [_pageControl setCurrentPage:newIndex animate:YES];
    // 超过50%的滚动机会触发此代理
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    if (self.headerClickCall) {
        self.headerClickCall(1,index);
    }
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.homeData.cate.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 4;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DSHomeCateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCateCell forIndexPath:indexPath];
    DSHomeCate *cate = self.homeData.cate[indexPath.item];
    cell.cate = cate;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (HX_SCREEN_WIDTH-10.0*2.0-25*3.0)/4.0;
    CGFloat height = 90.f;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 25.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(15.f, 10.f, 10.f, 5.f);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.headerClickCall) {
        self.headerClickCall(2,indexPath.item);
    }
}
@end
