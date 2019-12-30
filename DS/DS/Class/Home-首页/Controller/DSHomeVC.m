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
#import "DSHomeData.h"
#import "DSWebContentVC.h"
#import "DSSearchGoodsVC.h"
#import "SZUpdateView.h"

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
/* 首页数据 */
@property(nonatomic,strong) DSHomeData *homeData;
@end

@implementation DSHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCollectionView];
    [self setUpRefresh];
    [self startShimmer];
    [self getHomeDataRequest];
//    [self updateVersionRequest];//版本升级
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUnreadMsgRequest];
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
    msg.badgeBgColor  = [UIColor whiteColor];
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
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.collectionView.mj_footer resetNoMoreData];
        [strongSelf getHomeDataRequest];
    }];
}
#pragma mark -- 点击事件
-(void)msgClicked
{
    DSMessageVC *mvc = [DSMessageVC new];
    [self.navigationController pushViewController:mvc animated:YES];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    DSSearchGoodsVC *svc = [DSSearchGoodsVC new];
    [self.navigationController pushViewController:svc animated:YES];
    return NO;
}
#pragma mark -- 接口请求
-(void)getHomeDataRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"home_get" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"status"] integerValue] == 1) {
            [strongSelf.collectionView.mj_header endRefreshing];
            strongSelf.homeData = [DSHomeData yy_modelWithDictionary:responseObject[@"result"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.collectionView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [strongSelf.collectionView.mj_header endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getUnreadMsgRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"message_unread_get" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"status"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (responseObject[@"result"][@"unread_msg_num"] && [responseObject[@"result"][@"unread_msg_num"] integerValue] != 0) {
                    [strongSelf.msgBtn showBadgeWithStyle:WBadgeStyleRedDot value:1 animationType:WBadgeAnimTypeNone];
                }else{
                    [strongSelf.msgBtn clearBadge];
                }
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)updateVersionRequest
{
    hx_weakify(self);
    NSString *key = @"CFBundleShortVersionString";
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    [HXNetworkTool POST:HXRC_M_URL action:@"isNewVersions" parameters:@{@"sys":@"2",@"versions":currentVersion} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] boolValue]) {
            if ([responseObject[@"result"] isKindOfClass:[NSDictionary class]]) {
                [strongSelf updateAlert:responseObject[@"result"]];
            }
        }else{
            //[JMNotifyView showNotify:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        //[JMNotifyView showNotify:error.localizedDescription];
    }];
}
-(void)updateAlert:(NSDictionary *)dict
{
    // 删除数据
    SZUpdateView *alert = [SZUpdateView loadXibView];
    alert.hxn_width = HX_SCREEN_WIDTH - 30*2;
    alert.hxn_height = (HX_SCREEN_WIDTH - 30*2) *130/300.0 + 240;
    if ([dict[@"must_type"] integerValue] == 1) {
        alert.closeBtn.hidden = YES;
    }else{
        alert.closeBtn.hidden = NO;
    }
    alert.versionTxt.text = [NSString stringWithFormat:@"发现新版本V%@",dict[@"app_version"]];
    alert.updateText.text = dict[@"update_content"];
    hx_weakify(self);
    alert.updateClickedCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        if (index == 1) {// 强制更新不消失
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1468066838?mt=8"]];
        }else{// 不强制更新消失
            [strongSelf.zh_popupController dismiss];
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.dismissOnMaskTouched = NO;
    [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {//分类
        return self.homeData.cate.count;
    }else{//推荐商品分组
        return self.homeData.recommend_goods.count;
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
        DSHomeCate *cate = self.homeData.cate[indexPath.item];
        cell.cate = cate;
        return cell;
    }else{//推荐商品分组
        DSShopGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShopGoodsCell forIndexPath:indexPath];
        DSHomeRecommend *recommend = self.homeData.recommend_goods[indexPath.item];
        cell.recommend = recommend;
        return cell;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(HX_SCREEN_WIDTH,(HX_SCREEN_WIDTH-12.f*2)*2/5.0+20.f);
    }else{
        return CGSizeMake(HX_SCREEN_WIDTH,10.f);
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        if (indexPath.section == 0) {
            DSHomeBannerHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeBannerHeader forIndexPath:indexPath];
            header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH,(HX_SCREEN_WIDTH-12.f*2)*2/5.0+20.f);
            header.adv = self.homeData.adv;
            hx_weakify(self);
            header.bannerClickCall = ^(NSInteger index) {
                hx_strongify(weakSelf);
                DSHomeBanner *banner = strongSelf.homeData.adv[index];
                /**1仅图片；2链接；3html内容；4商品详情，类型未html时不返回adv_content，通过详情接口获取*/
                if ([banner.adv_type isEqualToString:@"1"]) {
                    
                }else if ([banner.adv_type isEqualToString:@"2"]) {
                    DSWebContentVC *wvc = [DSWebContentVC new];
                    wvc.navTitle = banner.adv_name;
                    wvc.isNeedRequest = NO;
                    wvc.url = banner.adv_content;
                    [strongSelf.navigationController pushViewController:wvc animated:YES];
                }else if ([banner.adv_type isEqualToString:@"3"]) {
                    DSWebContentVC *wvc = [DSWebContentVC new];
                    wvc.navTitle = banner.adv_name;
                    wvc.isNeedRequest = YES;
                    wvc.requestType = 1;
                    wvc.adv_id = banner.adv_id;
                    [strongSelf.navigationController pushViewController:wvc animated:YES];
                }else{
                    DSGoodsDetailVC *dvc = [DSGoodsDetailVC new];
                    dvc.goods_id = banner.adv_content;
                    [strongSelf.navigationController pushViewController:dvc animated:YES];
                }
            };
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
        DSHomeCate *cate = self.homeData.cate[indexPath.item];
        if ([cate.cate_mode isEqualToString:@"2"] || [cate.cate_mode isEqualToString:@"3"]) {
            DSWebContentVC *wvc = [DSWebContentVC new];
            wvc.navTitle = @"商品列表";
            wvc.isNeedRequest = YES;
            wvc.requestType = 7;
            [self.navigationController pushViewController:wvc animated:YES];
        }else{
            DSHomeCateVC *cvc = [DSHomeCateVC new];
            cvc.cate_id = cate.cate_id;
            cvc.cate_mode = cate.cate_mode;
            [self.navigationController pushViewController:cvc animated:YES];
        }
    }else{//推荐商品分组
        DSGoodsDetailVC *dvc = [DSGoodsDetailVC new];
        DSHomeRecommend *recommend = self.homeData.recommend_goods[indexPath.item];
        dvc.goods_id = recommend.goods_id;
        [self.navigationController pushViewController:dvc animated:YES];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//分类
        CGFloat width = (HX_SCREEN_WIDTH-25.0*2.0-25*3.0)/4.0;
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
        return 25.f;
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
