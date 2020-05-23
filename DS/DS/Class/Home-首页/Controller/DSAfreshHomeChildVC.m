//
//  DSAfreshHomeChildVC.m
//  DS
//
//  Created by huaxin-01 on 2020/5/18.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSAfreshHomeChildVC.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "DSShopGoodsCell.h"
#import "DSShopGoods.h"
#import "DSTaoGoodsDetailVC.h"
#import "DSGoodsDetailVC.h"

static NSString *const ShopGoodsCell = @"ShopGoodsCell";
@interface DSAfreshHomeChildVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 消息列表 */
@property(nonatomic,strong) NSMutableArray *goods;
@end

@implementation DSAfreshHomeChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCollectionView];
    [self setUpRefresh];
    [self setUpEmptyView];
    [self startShimmer];
    [self getGoodsListDataRequest:YES contentScrollView:self.collectionView];
}
-(NSMutableArray *)goods
{
    if (_goods == nil) {
        _goods = [NSMutableArray array];
    }
    return _goods;
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
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DSShopGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:ShopGoodsCell];
}
-(void)setUpEmptyView
{
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"no_data" titleStr:nil detailStr:@"暂无内容"];
    emptyView.contentViewOffset = -(self.HXNavBarHeight);
    emptyView.subViewMargin = 20.f;
    emptyView.detailLabTextColor = UIColorFromRGB(0x909090);
    emptyView.detailLabFont = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
    emptyView.autoShowEmptyView = NO;
    self.collectionView.ly_emptyView = emptyView;
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    //追加尾部刷新
    hx_weakify(self);
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getGoodsListDataRequest:NO contentScrollView:strongSelf.collectionView];
    }];
}
#pragma mark -- 接口请求
/** 列表请求 */
-(void)getGoodsListDataRequest:(BOOL)isRefresh contentScrollView:(UIScrollView *)contentScrollView
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"cate_id"] = self.cate_id;//二级分类id
    parameters[@"cate_mode"] = self.cate_mode;//分类方式：1袋鼠自营商品分类；2京东自营商品分类；3京东联盟商品分类；4淘宝商品分类
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger pagenum = self.pagenum+1;
        parameters[@"page"] = @(pagenum);//第几页
    }

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"cate_goods_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"status"] integerValue] == 1) {
            if (isRefresh) {
                [contentScrollView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.goods removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[DSShopGoods class] json:responseObject[@"result"][@"list"]];
                [strongSelf.goods addObjectsFromArray:arrt];
            }else{
                [contentScrollView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"result"][@"list"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"result"][@"list"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[DSShopGoods class] json:responseObject[@"result"][@"list"]];
                    [strongSelf.goods addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [contentScrollView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.collectionView reloadData];
                if (strongSelf.goods.count) {
                    [strongSelf.collectionView ly_hideEmptyView];
                }else{
                    [strongSelf.collectionView ly_showEmptyView];
                }
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
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goods.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DSShopGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShopGoodsCell forIndexPath:indexPath];
    DSShopGoods *goods = self.goods[indexPath.row];
    cell.goods = goods;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DSShopGoods *goods = self.goods[indexPath.row];
    if ([goods.cate_mode isEqualToString:@"4"]) {
        DSTaoGoodsDetailVC *dvc = [DSTaoGoodsDetailVC new];
        dvc.goods_id = goods.goods_id;
        [self.navigationController pushViewController:dvc animated:YES];
    }else{
        DSGoodsDetailVC *dvc = [DSGoodsDetailVC new];
        dvc.goods_id = goods.goods_id;
        [self.navigationController pushViewController:dvc animated:YES];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = HX_SCREEN_WIDTH;
    CGFloat height = 146;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsZero;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

#pragma mark -- JXPagingViewListViewDelegate

/**
 返回listView。如果是vc包裹的就是vc.view；如果是自定义view包裹的，就是自定义view自己。

 @return UIView
 */
- (UIView *)listView
{
    return self.view;
}

/**
 返回listView内部持有的UIScrollView或UITableView或UICollectionView
 主要用于mainTableView已经显示了header，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView

 @return listView内部持有的UIScrollView或UITableView或UICollectionView
 */
- (UIScrollView *)listScrollView
{
    return self.collectionView;
}

/**
 当listView内部持有的UIScrollView或UITableView或UICollectionView的代理方法`scrollViewDidScroll`回调时，需要调用该代理方法传入的callback

 @param callback `scrollViewDidScroll`回调时调用的callback
 */
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *scrollView))callback
{
    self.scrollCallback = callback;
}

@end
