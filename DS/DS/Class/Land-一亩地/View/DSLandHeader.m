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

static NSString *const LandCateCell = @"LandCateCell";
@interface DSLandHeader ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cyclePagerView;
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
    
    [self.cyclePagerView reloadData];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cyclePagerView.frame) - 20.f, CGRectGetWidth(self.cyclePagerView.frame), 15.f);
    self.backgroundColor = [UIColor mfx_gradientFromColor:UIColorFromRGB(0xFFFFFF) toColor:UIColorFromRGB(0xF5F6F7) withHeight:self.hxn_height];
}
- (IBAction)landCateClicked:(UIButton *)sender {
    if (self.landHeaderClickCall) {
        self.landHeaderClickCall(1,sender.tag);
    }
}

//-(void)setHomeData:(DSHomeData *)homeData
//{
//    _homeData = homeData;
//    self.pageControl.numberOfPages = _homeData.adv.count;
//    [self.cyclePagerView reloadData];
//
//}
#pragma mark -- TYCyclePagerView代理
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return 3;
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
    // [_pageControl setCurrentPage:newIndex animate:YES];
    // 超过50%的滚动机会触发此代理
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    if (self.landHeaderClickCall) {
        self.landHeaderClickCall(0,index);
    }
}
@end
