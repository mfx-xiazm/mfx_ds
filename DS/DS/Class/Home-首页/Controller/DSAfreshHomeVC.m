//
//  DSAfreshHomeVC.m
//  DS
//
//  Created by huaxin-01 on 2020/5/18.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSAfreshHomeVC.h"
#import "JXPagerView.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorLineView.h>
#import "DSAfreshHomeChildVC.h"
#import "DSAfreshHomeHeader.h"
#import "DSHomeData.h"
#import "DSWebContentVC.h"
#import "DSGoodsDetailVC.h"
#import "DSHomeCateVC.h"
#import "HXTabBarController.h"
#import "SZUpdateView.h"
#import "UIView+WZLBadge.h"
#import "DSMessageVC.h"
#import "DSSearchGoodsVC.h"
#import <zhPopupController.h>

static const CGFloat JXheightForHeaderInSection = 50;

@interface DSAfreshHomeVC ()<JXPagerViewDelegate,JXPagerMainTableViewGestureDelegate,JXCategoryViewDelegate>
@property (nonatomic, strong) JXPagerView *pagerView;
@property (nonatomic, strong) DSAfreshHomeHeader *headerView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) DSHomeData *homeData;
/* 消息 */
@property(nonatomic,strong) SPButton *msgBtn;
@end

@implementation DSAfreshHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self.view addSubview:self.pagerView];
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
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
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.pagerView.frame = self.view.bounds;
}
#pragma mark -- 懒加载
-(JXPagerView *)pagerView
{
    if (!_pagerView) {
        _pagerView = [[JXPagerView alloc] initWithDelegate:self];
        _pagerView.mainTableView.gestureDelegate = self;
        _pagerView.mainTableView.contentInset = UIEdgeInsetsMake(self.HXNavBarHeight, 0, 0, 0);
        _pagerView.hidden = YES;
    }
    return _pagerView;
}
-(JXCategoryTitleView *)categoryView
{
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, JXheightForHeaderInSection)];
        _categoryView.titleFont = [UIFont systemFontOfSize:15];
        _categoryView.titleSelectedFont = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _categoryView.backgroundColor = HXGlobalBg;
        _categoryView.delegate = self;
        _categoryView.titleSelectedColor = HXControlBg;
        _categoryView.titleColor = UIColorFromRGB(0x333333);
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.titleLabelZoomEnabled = NO;
        _categoryView.averageCellSpacingEnabled = NO;
        _categoryView.contentScrollViewClickTransitionAnimationEnabled = YES;

        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = HXControlBg;
        lineView.verticalMargin = 8.f;
        lineView.indicatorWidthIncrement = -10.f;
        _categoryView.indicators = @[lineView];
    }
    return _categoryView;
}
-(DSAfreshHomeHeader *)headerView
{
    if (!_headerView) {
        _headerView = [DSAfreshHomeHeader loadXibView];
        _headerView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, (HX_SCREEN_WIDTH)*175/375.0 + 200);
        hx_weakify(self);
        _headerView.headerClickCall = ^(NSInteger type, NSInteger index) {
            hx_strongify(weakSelf);
            if (type == 1) {
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
            }else{
                DSHomeCate *cate = strongSelf.homeData.cate[index];
                /**1鲸品自营商品；2京东自营商品；3精品优选：壹企通采购和金不换商品；4淘宝商品分类；5苏宁易购商品；6全球美妆商品；7库存尾货：跳转“敬请期待”；8.VIP会员*/
                /**1和4直接跳转， 2、3、5、6调用jd_url_get返回链接， 7保留，8跳转vip会员*/
                if ([cate.cate_mode isEqualToString:@"1"] || [cate.cate_mode isEqualToString:@"4"]) {
                    DSHomeCateVC *cvc = [DSHomeCateVC new];
                    cvc.cate_id = cate.cate_id;
                    cvc.cate_mode = cate.cate_mode;
                    [strongSelf.navigationController pushViewController:cvc animated:YES];
                }else if ([cate.cate_mode isEqualToString:@"7"]) {
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"敬请期待"];
                }else if ([cate.cate_mode isEqualToString:@"8"]) {
                    HXTabBarController *tabVc = (HXTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                    tabVc.selectedIndex = 1;
                }else{
                    DSWebContentVC *wvc = [DSWebContentVC new];
                    wvc.navTitle = cate.cate_name;
                    wvc.url = cate.cate_url;
                    [strongSelf.navigationController pushViewController:wvc animated:YES];
                }
            }
        };
    }
    return _headerView;
}
#pragma mark -- 视图
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];

    self.hbd_barShadowHidden = YES;
    UIView *navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH*3, self.HXNavBarHeight*3)];
    [navBgView.layer addSublayer:[UIColor setGradualChangingColor:navBgView fromColor:@"F95628" toColor:@"EC2F2A"]];
    UIImage *navBgImg = [navBgView imageWithUIView];
     
    self.hbd_barImage = navBgImg;
    
    UIView *searchBg = [UIView new];
    searchBg.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH - 60.f, 30.f);
    searchBg.backgroundColor = [UIColor clearColor];
  
    SPButton *searchBar = [SPButton buttonWithType:UIButtonTypeCustom];
    searchBar.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    searchBar.contentEdgeInsets = UIEdgeInsetsMake(0, 14.f, 0, 0);
    searchBar.imageTitleSpace = 8.f;
    searchBar.frame = CGRectMake(5, 0, CGRectGetWidth(searchBg.frame)-5.f, 30.f);
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 15.f;
    searchBar.layer.masksToBounds = YES;
    [searchBar setTitleColor:UIColorFromRGB(0X909090) forState:UIControlStateNormal];
    [searchBar setTitle:@"搜索商品 领优惠拿返现" forState:UIControlStateNormal];
    searchBar.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchBar setImage:HXGetImage(@"search_icon") forState:UIControlStateNormal];
    [searchBar setImage:HXGetImage(@"search_icon") forState:UIControlStateHighlighted];
    [searchBar addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchUpInside];
    [searchBg addSubview:searchBar];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBg];
    
    SPButton *msg = [SPButton buttonWithType:UIButtonTypeCustom];
    msg.hxn_size = CGSizeMake(40, 40);
    [msg setImage:HXGetImage(@"消息") forState:UIControlStateNormal];
    [msg addTarget:self action:@selector(msgClicked) forControlEvents:UIControlEventTouchUpInside];
    msg.badgeBgColor  = UIColorFromRGB(0XEF0F00);
    msg.badgeCenterOffset = CGPointMake(-12, 14);
    self.msgBtn = msg;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:msg];
}
-(void)setUpRefresh
{
    hx_weakify(self);
    self.pagerView.mainTableView.mj_header.automaticallyChangeAlpha = YES;
    self.pagerView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        if (strongSelf.homeData) {
            DSAfreshHomeChildVC *cvc = (DSAfreshHomeChildVC *)[strongSelf.pagerView.validListDict objectForKey:@(strongSelf.categoryView.selectedIndex)];
            
            [cvc getGoodsListDataRequest:YES contentScrollView:strongSelf.pagerView.mainTableView];
        }else{
            [strongSelf getHomeDataRequest];
        }
    }];
}
#pragma mark -- 接口请求
-(void)getHomeDataRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"home_get" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        strongSelf.pagerView.hidden = NO;
        [strongSelf.pagerView.mainTableView.mj_header endRefreshing];
        if ([responseObject[@"status"] integerValue] == 1) {
            strongSelf.homeData = [DSHomeData yy_modelWithDictionary:responseObject[@"result"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.headerView.homeData = strongSelf.homeData;
                NSMutableArray *titles = [NSMutableArray array];
                for (DSHomeCate *cate in strongSelf.homeData.taobao_cate) {
                    [titles addObject:cate.cate_name];
                }
                strongSelf.categoryView.titles = titles;
                strongSelf.categoryView.defaultSelectedIndex = 0;
                [strongSelf.categoryView reloadData];
                [strongSelf.pagerView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        strongSelf.pagerView.hidden = NO;
        [strongSelf.pagerView.mainTableView.mj_header endRefreshing];
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
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1506869210?mt=8"]];
        }else{// 不强制更新消失
            [strongSelf.zh_popupController dismiss];
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.dismissOnMaskTouched = NO;
    [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
}
#pragma mark -- 点击事件
-(void)msgClicked
{
    DSMessageVC *mvc = [DSMessageVC new];
    [self.navigationController pushViewController:mvc animated:YES];
}
- (void)searchClicked
{
    DSSearchGoodsVC *svc = [DSSearchGoodsVC new];
    [self.navigationController pushViewController:svc animated:YES];
}
#pragma mark -- JXPagerViewDelegate
/**
 返回tableHeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView
{
    return (HX_SCREEN_WIDTH)*175/375.0 + 200;
}

/**
 返回tableHeaderView
 */
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView
{
    return self.headerView;
}

/**
 返回悬浮HeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView
{
    return JXheightForHeaderInSection;
}

/**
 返回悬浮HeaderView。我用的是自己封装的JXCategoryView
 */
- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView
{
    return self.categoryView;
}

/**
 返回列表的数量
 */
- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView
{
    return self.categoryView.titles.count;
}

/**
 根据index初始化一个对应列表实例，需要是遵从`JXPagerViewListViewDelegate`协议的对象。
 如果列表是用自定义UIView封装的，就让自定义UIView遵从`JXPagerViewListViewDelegate`协议，该方法返回自定义UIView即可。
 如果列表是用自定义UIViewController封装的，就让自定义UIViewController遵从`JXPagerViewListViewDelegate`协议，该方法返回自定义UIViewController即可。
 注意：一定要是新生成的实例！！！

 @param pagerView pagerView description
 @param index index description
 @return 新生成的列表实例
 */
- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index
{
    DSAfreshHomeChildVC *hvc = [DSAfreshHomeChildVC new];
    DSHomeCate *cate = self.homeData.taobao_cate[index];
    hvc.cate_id = cate.cate_id;
    hvc.cate_mode = cate.cate_mode;
    return hvc;
}

#pragma mark -- JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    HXLog(@"分类切换");
}

#pragma mark -- JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

@end
