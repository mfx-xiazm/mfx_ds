//
//  DSHomeVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/11.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSHomeVC.h"
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
#import "HXTabBarController.h"

static NSString *const HomeCateCell = @"HomeCateCell";
static NSString *const ShopGoodsCell = @"ShopGoodsCell";
static NSString *const HomeBannerHeader = @"HomeBannerHeader";
static NSString *const HomeSectionHeader = @"HomeSectionHeader";

@interface DSHomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/* 消息 */
@property(nonatomic,strong) SPButton *msgBtn;
/* 首页数据 */
@property(nonatomic,strong) DSHomeData *homeData;
/* 头部状态 */
@property(nonatomic,assign) CGFloat gradientProgress;
@end

@implementation DSHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF9F9F9);
    [self setUpNavBar];
    [self setUpCollectionView];
    [self setUpRefresh];
    [self startShimmer];
    [self getHomeDataRequest];
    [self updateVersionRequest];//版本升级
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUnreadMsgRequest];
}
-(void)setUpNavBar
{
    self.hbd_barAlpha = 0;
    
    [self.navigationItem setTitle:nil];
    
    UIView *searchBg = [UIView new];
    searchBg.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH - 60.f, 30.f);
    searchBg.backgroundColor = [UIColor clearColor];
  
    SPButton *searchBar = [SPButton buttonWithType:UIButtonTypeCustom];
    searchBar.imageTitleSpace = 5.f;
    searchBar.frame = CGRectMake(5, 0, CGRectGetWidth(searchBg.frame)-5.f, 30.f);
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 15.f;
    searchBar.layer.masksToBounds = YES;
    [searchBar setTitleColor:UIColorFromRGB(0X909090) forState:UIControlStateNormal];
    [searchBar setTitle:@"请输入商品名称查询" forState:UIControlStateNormal];
    searchBar.titleLabel.font = [UIFont systemFontOfSize:12];
    [searchBar setImage:HXGetImage(@"search_icon") forState:UIControlStateNormal];
    [searchBar setImage:HXGetImage(@"search_icon") forState:UIControlStateHighlighted];
    [searchBar addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchUpInside];
    [searchBg addSubview:searchBar];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBg];
    
    SPButton *msg = [SPButton buttonWithType:UIButtonTypeCustom];
    msg.hxn_size = CGSizeMake(40, 40);
    [msg setImage:HXGetImage(@"消息") forState:UIControlStateNormal];
    [msg addTarget:self action:@selector(msgClicked) forControlEvents:UIControlEventTouchUpInside];
    [msg setTitleColor:UIColorFromRGB(0XFFFFFF) forState:UIControlStateNormal];
    msg.badgeBgColor  = HXControlBg;
    msg.badgeCenterOffset = CGPointMake(-10, 10);
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
    self.collectionView.backgroundColor = [UIColor clearColor];
//    self.collectionView.contentInset = UIEdgeInsetsMake(self.HXNavBarHeight, 0, 0, 0);
    
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
//    DSMessageVC *mvc = [DSMessageVC new];
//    [self.navigationController pushViewController:mvc animated:YES];
    DSWebContentVC *wvc = [DSWebContentVC new];
    wvc.navTitle = @"测试商城";
    wvc.url = @"http://dev.wx.yqtb2b.com/?bid=321548b7caa9c19b0f1bb2cf1fba76c4&loginParams=HPIpcz0AAQsGzkWBAJi55%2B5uiHapasQjT4I77Yo1h7ILNtPLjtRlG7t%2FDuxTe0YF#/home";
    [self.navigationController pushViewController:wvc animated:YES];
}
- (void)searchClicked
{
    DSSearchGoodsVC *svc = [DSSearchGoodsVC new];
    [self.navigationController pushViewController:svc animated:YES];
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
    
    [HXNetworkTool POST:HXRC_M_URL action:@"version_update_get" parameters:@{@"app_type":@"2",@"app_version":currentVersion} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat progress = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGFloat gradientProgress = MIN(1, MAX(0, progress / 180.f));
    if (gradientProgress != _gradientProgress) {
        _gradientProgress = gradientProgress;
        if (_gradientProgress < 0.1) {
//            self.hbd_barStyle = UIBarStyleBlack;
//            self.hbd_tintColor = UIColor.whiteColor;
//            self.hbd_titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor.blackColor colorWithAlphaComponent:0] };
            self.collectionView.backgroundColor = [UIColor clearColor];
            self.msgBtn.badgeBgColor  = HXControlBg;
        } else {
//            self.hbd_barStyle = UIBarStyleDefault;
//            self.hbd_tintColor = UIColor.blackColor;
//            self.hbd_titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor.blackColor colorWithAlphaComponent:_gradientProgress] };
            self.collectionView.backgroundColor = [UIColorFromRGB(0xF9F9F9) colorWithAlphaComponent:_gradientProgress];
            self.msgBtn.badgeBgColor  = [[UIColor whiteColor] colorWithAlphaComponent:_gradientProgress];
        }
        self.hbd_barAlpha = _gradientProgress;
        [self hbd_setNeedsUpdateNavigationBar];
    }
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
        return CGSizeMake(HX_SCREEN_WIDTH,(HX_SCREEN_WIDTH-12.f*2)*168/343.0+20.f+15.f);
    }else{
        return CGSizeZero;
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        if (indexPath.section == 0) {
            DSHomeBannerHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeBannerHeader forIndexPath:indexPath];
            header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH,(HX_SCREEN_WIDTH-12.f*2)*168/343.0+20.f+15.f);
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
            return nil;
        }
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//分类
        DSHomeCate *cate = self.homeData.cate[indexPath.item];
    /**1鲸品自营商品；2京东自营商品；3精品优选：壹企通采购和金不换商品；4淘宝商品分类；5苏宁易购商品；6全球美妆商品；7库存尾货：跳转“敬请期待”；8.VIP会员*/
        /**1和4直接跳转， 2、3、5、6调用jd_url_get返回链接， 7保留，8跳转vip会员*/
        if ([cate.cate_mode isEqualToString:@"1"] || [cate.cate_mode isEqualToString:@"4"]) {
            DSHomeCateVC *cvc = [DSHomeCateVC new];
            cvc.cate_id = cate.cate_id;
            cvc.cate_mode = cate.cate_mode;
            [self.navigationController pushViewController:cvc animated:YES];
        }else if ([cate.cate_mode isEqualToString:@"7"]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"敬请期待"];
        }else if ([cate.cate_mode isEqualToString:@"8"]) {
            HXTabBarController *tabVc = (HXTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabVc.selectedIndex = 1;
        }else{
            DSWebContentVC *wvc = [DSWebContentVC new];
            wvc.navTitle = cate.cate_name;
            wvc.url = cate.cate_url;
            [self.navigationController pushViewController:wvc animated:YES];
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
        CGFloat height = 130;
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
