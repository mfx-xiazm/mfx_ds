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
#import "DSGoodsDetail.h"
#import "DSUpOrderVC.h"
#import "DSCartVC.h"

@interface DSGoodsDetailVC ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cyclePagerView;
@property (nonatomic,strong) TYPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *webContentView;
@property (nonatomic, strong) WKWebView  *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webContentViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *marketPrice;
@property (weak, nonatomic) IBOutlet UILabel *saleNum;
@property (weak, nonatomic) IBOutlet UILabel *backPrice;
@property (weak, nonatomic) IBOutlet UILabel *provider;
@property (weak, nonatomic) IBOutlet UILabel *stockNum;
@property (weak, nonatomic) IBOutlet UILabel *freight;
@property (weak, nonatomic) IBOutlet UILabel *coupon;
@property (weak, nonatomic) IBOutlet SPButton *collentBtn;
/** 商品规格视图 */
@property(nonatomic,strong) DSChooseClassView *chooseClassView;
/** 商品详情 */
@property(nonatomic,strong) DSGoodsDetail *goodsDetail;
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
    if (!self.goodsDetail) {
        return;
    }
    DSGoodsPosterView *pv = [DSGoodsPosterView loadXibView];
    pv.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, HX_SCREEN_HEIGHT);
    pv.goodsDetail = self.goodsDetail;
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
    if ([self.goodsDetail.is_discount isEqualToString:@"1"]) {
        return;
    }
    DSTakeCouponView *couponView = [DSTakeCouponView loadXibView];
    couponView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 280.f);
    couponView.discount = self.goodsDetail.discount;
    couponView.valid_days = self.goodsDetail.valid_days;
    hx_weakify(self);
    couponView.couponClickedCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        if (index) {
            [strongSelf setGoodsDiscountRequest];
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:couponView duration:0.25 springAnimated:NO];
}
- (IBAction)shareToMoneyClicked:(UIButton *)sender {
    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"分享赚说明" message:self.goodsDetail.share_make_money constantWidth:HX_SCREEN_WIDTH - 50*2];
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
- (IBAction)collectGoodsClicked:(SPButton *)sender {
    [self setGoodsCollectRequest];
}
- (IBAction)cartClicked:(SPButton *)sender {
    DSCartVC *cvc = [DSCartVC new];
    [self.navigationController pushViewController:cvc animated:YES];
}

- (IBAction)chooseGoodsClassClicked:(UIButton *)sender {
    self.chooseClassView.goodsDetail = self.goodsDetail;
    hx_weakify(self);
    self.chooseClassView.goodsHandleCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        if (index) {
            if (sender.tag == 1) {
                [strongSelf addOrderCartRequest];
            }else{
                DSUpOrderVC *ovc = [DSUpOrderVC new];
                ovc.isCartPush = NO;
                NSString *goods_data = [NSString stringWithFormat:@"[{\"goods_id\":\"%@\",\"sku_id\":\"%@\",\"num\":\"%@\",\"share_uid\":\"0\"}]",strongSelf.goods_id,strongSelf.goodsDetail.selectSku.sku_id,@(strongSelf.goodsDetail.buyNum)];
                ovc.goods_data = goods_data;
                [strongSelf.navigationController pushViewController:ovc animated:YES];
            }
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:self.chooseClassView duration:0.25 springAnimated:NO];
}
#pragma mark -- 接口请求
-(void)getGoodsDetailRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = self.goods_id;//商品id
    parameters[@"is_member_goods"] = @(0);//是否会员商品，0常规商品，1会员礼包商品

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
    
    self.goodsName.text = self.goodsDetail.goods_name;
    self.price.text = [NSString stringWithFormat:@"折扣价￥%@",self.goodsDetail.discount_price];
    self.marketPrice.text = [NSString stringWithFormat:@"原价￥%@",self.goodsDetail.price];
    self.saleNum.text = [NSString stringWithFormat:@"销量：￥%@",self.goodsDetail.sale_num];
    self.backPrice.text = [NSString stringWithFormat:@"返佣金额：%@",self.goodsDetail.cmm_price];
    self.provider.text = [NSString stringWithFormat:@"  供应商：%@  ",self.goodsDetail.provider];
    self.stockNum.text = self.goodsDetail.stock;
    if ([self.goodsDetail.is_discount isEqualToString:@"1"]) {
        self.coupon.text = [NSString stringWithFormat:@"已领取%@折券",self.goodsDetail.discount];
    }else{
        self.coupon.text = [NSString stringWithFormat:@"可领取%@折券",self.goodsDetail.discount];
    }
    
    if (HX_SCREEN_WIDTH > 375.f) {
        [self.webView loadHTMLString:self.goodsDetail.goods_desc baseURL:nil];
    }else{
        NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:10px 10px;}</style></head><body>%@</body></html>",self.goodsDetail.goods_desc];
        [self.webView loadHTMLString:h5 baseURL:nil];
    }
    
    self.collentBtn.selected = [self.goodsDetail.is_collect isEqualToString:@"1"]?YES:NO;
}
/// 领取优惠券
-(void)setGoodsDiscountRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = self.goods_id;//商品id
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"goods_discount_set" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"领取成功"];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.goodsDetail.is_discount = @"1";
                strongSelf.coupon.text = [NSString stringWithFormat:@"已领取%@折券",strongSelf.goodsDetail.discount];
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
/// 收藏商品
-(void)setGoodsCollectRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = self.goods_id;//商品id
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"collect_goods_set" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([strongSelf.goodsDetail.is_collect isEqualToString:@"0"]) {
                    strongSelf.goodsDetail.is_collect = @"1";
                }else{
                    strongSelf.goodsDetail.is_collect = @"0";
                }
                strongSelf.collentBtn.selected = [strongSelf.goodsDetail.is_collect isEqualToString:@"1"]?YES:NO;
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

/// 加入购物车
-(void)addOrderCartRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = self.goods_id;//商品id
    
    NSMutableString *attr_id = [NSMutableString string];
    for (DSGoodsSpecs *specs in self.goodsDetail.list_specs) {
        if (attr_id.length) {
            [attr_id appendFormat:@",%@",specs.selectAttrs.attr_id];
        }else{
            [attr_id appendFormat:@"%@",specs.selectAttrs.attr_id];
        }
    }
    NSString *sku_id = nil;
    for (DSGoodsSku *sku in self.goodsDetail.goods_sku) {
        if ([sku.specs_attr_ids isEqualToString:attr_id]) {
            sku_id = sku.sku_id;
        }
    }
    parameters[@"sku_id"] = sku_id;
    parameters[@"num"] = @(self.goodsDetail.buyNum);
    
    [HXNetworkTool POST:HXRC_M_URL action:@"add_cart_set" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
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
