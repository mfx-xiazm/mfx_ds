//
//  DSLandHeader.m
//  DS
//
//  Created by huaxin-01 on 2020/7/29.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSLandHeader.h"
#import "DSBannerCell.h"
#import <TYCyclePagerView.h>
#import <TYPageControl.h>
#import "DSLandCateCell.h"
#import <ZLCollectionViewHorzontalLayout.h>
#import "DSLand.h"

static NSString *const LandCateCell = @"LandCateCell";
@interface DSLandHeader ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cyclePagerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) TYPageControl *pageControl;
@end

@implementation DSLandHeader

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
    pageControl.pageIndicatorTintColor = UIColorFromRGB(0xFFFFFF);
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#48B664"];
    pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cyclePagerView.frame)- 20.f, CGRectGetWidth(self.cyclePagerView.frame), 15.f);
    self.pageControl = pageControl;
    [self.cyclePagerView addSubview:pageControl];
        
    ZLCollectionViewHorzontalLayout *flowLayout = [[ZLCollectionViewHorzontalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    flowLayout.header_suspension = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.scrollEnabled = YES;
    //    self.collectionView.contentInset = UIEdgeInsetsMake(self.HXNavBarHeight, 0, 0, 0);
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DSLandCateCell class]) bundle:nil] forCellWithReuseIdentifier:LandCateCell];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cyclePagerView.frame) - 20.f, CGRectGetWidth(self.cyclePagerView.frame), 15.f);
    self.collectionView.backgroundColor = [UIColor mfx_gradientFromColors:@[UIColorFromRGB(0xFFFFFF),UIColorFromRGB(0xF5F6F7)] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(HX_SCREEN_WIDTH, self.collectionView.hxn_height)];
}
-(void)setLand:(DSLand *)land
{
    _land = land;
    self.pageControl.numberOfPages = _land.adv.count;
    self.cyclePagerView.isInfiniteLoop = _land.adv.count>1?YES:NO;
    [self.cyclePagerView reloadData];

    [self.collectionView reloadData];
}
#pragma mark -- TYCyclePagerView代理
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.land.adv.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    DSBannerCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"TopBannerCell" forIndex:index];
    DSLandAdv *adv = self.land.adv[index];
    cell.landAdv = adv;
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
    if (self.landHeaderClickCall) {
        self.landHeaderClickCall(0,index);
    }
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.land.jgq.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DSLandCateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LandCateCell forIndexPath:indexPath];
    DSLandAdv *cate = self.land.jgq[indexPath.item];
    cell.cate = cate;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (HX_SCREEN_WIDTH-12.0*2.0-32*3.0)/4.0;
    CGFloat height = 115.f;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 32.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(0.f, 12.f, 0.f, 12.f);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   if (self.landHeaderClickCall) {
       self.landHeaderClickCall(1,indexPath.item);
    }
}
@end
