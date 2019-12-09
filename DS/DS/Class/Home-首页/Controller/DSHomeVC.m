//
//  DSHomeVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/11.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSHomeVC.h"
#import "HXSearchBar.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "UIView+WZLBadge.h"
#import "DSHomeCateCell.h"
#import "DSShopGoodsCell.h"
#import "DSHomeBannerHeader.h"
#import "DSHomeCateVC.h"
#import "DSMessageVC.h"
#import "DSGoodsDetailVC.h"
#import "DSGoodsPosterView.h"
#import <zhPopupController.h>
#import "GXSaveImageToPHAsset.h"

static NSString *const HomeCateCell = @"HomeCateCell";
static NSString *const ShopGoodsCell = @"ShopGoodsCell";
static NSString *const HomeBannerHeader = @"HomeBannerHeader";
static NSString *const HomeSectionHeader = @"HomeSectionHeader";

@interface DSHomeVC ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
/* 消息 */
@property(nonatomic,strong) SPButton *msgBtn;
@end

@implementation DSHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCollectionView];
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH - 70.f, 30.f)];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 6;
    searchBar.layer.masksToBounds = YES;
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入商品名称查询";
    self.searchBar = searchBar;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    
    SPButton *msg = [SPButton buttonWithType:UIButtonTypeCustom];
    msg.imagePosition = SPButtonImagePositionTop;
    msg.imageTitleSpace = 2.f;
    msg.hxn_size = CGSizeMake(40, 40);
    msg.titleLabel.font = [UIFont systemFontOfSize:9];
    [msg setImage:HXGetImage(@"消息") forState:UIControlStateNormal];
    [msg setTitle:@"消息" forState:UIControlStateNormal];
    [msg addTarget:self action:@selector(msgClicked) forControlEvents:UIControlEventTouchUpInside];
    [msg setTitleColor:UIColorFromRGB(0XFFFFFF) forState:UIControlStateNormal];
    msg.badgeCenterOffset = CGPointMake(-10, 5);
    self.msgBtn = msg;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:msg];
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
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DSHomeCateCell class]) bundle:nil] forCellWithReuseIdentifier:HomeCateCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DSShopGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:ShopGoodsCell];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeSectionHeader];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DSHomeBannerHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeBannerHeader];
}
#pragma mark -- 点击事件
-(void)msgClicked
{
    DSMessageVC *mvc = [DSMessageVC new];
    [self.navigationController pushViewController:mvc animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField hasText]) {
//        GYSearchGoodsVC *gvc = [GYSearchGoodsVC new];
//        gvc.keyword = textField.text;
//        [self.navigationController pushViewController:gvc animated:YES];
        return YES;
    }else{
        return NO;
    }
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {//分类
        return 8;
    }else{//推荐商品分组
        return 8;
    }
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    if (section == 0) {//分类
        return 4;
    }else{//推荐商品分组
        return 1;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//分类
        DSHomeCateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCateCell forIndexPath:indexPath];
        return cell;
    }else{//推荐商品分组
        DSShopGoodsCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShopGoodsCell forIndexPath:indexPath];
        return cell;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(HX_SCREEN_WIDTH,HX_SCREEN_WIDTH*3/5);
    }else{
        return CGSizeMake(HX_SCREEN_WIDTH,10.f);
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        if (indexPath.section == 0) {
            DSHomeBannerHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeBannerHeader forIndexPath:indexPath];
            header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH,HX_SCREEN_WIDTH*3/5);
            return header;
        }else{
            UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeSectionHeader forIndexPath:indexPath];
            header.backgroundColor = HXGlobalBg;
            header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH,10.f);
            return header;
        }
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//分类
        DSHomeCateVC *cvc = [DSHomeCateVC new];
        [self.navigationController pushViewController:cvc animated:YES];
    }else{//推荐商品分组
        DSGoodsDetailVC *dvc = [DSGoodsDetailVC new];
        [self.navigationController pushViewController:dvc animated:YES];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//分类
        CGFloat width = (HX_SCREEN_WIDTH-25.0*2.0-30*3.0)/4.0;
        CGFloat height = width+30.f;
        return CGSizeMake(width, height);
    }else{//推荐商品分组
        CGFloat width = HX_SCREEN_WIDTH;
        CGFloat height = 120;
        return CGSizeMake(width, height);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {//分类
        return 30.f;
    }else{//推荐商品分组
        return 0.f;
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {//分类
        return 5.f;
    }else{//推荐商品分组
        return 0.f;
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {//分类
        return  UIEdgeInsetsMake(10.f, 25.f, 10.f, 25.f);
    }else{//推荐商品分组
        return  UIEdgeInsetsZero;
    }
}
@end
