//
//  DSVipVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/11.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSVipVC.h"
#import "DSVipHeader.h"
#import "DSVipCell.h"
#import "DSVipCardVC.h"
#import "DSVipGoodsDetailVC.h"
#import "DSVipGoods.h"
#import "DSWebContentVC.h"

static NSString *const VipCell = @"VipCell";
@interface DSVipVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) DSVipHeader *header;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 列表 */
@property(nonatomic,strong) NSMutableArray *vipGoods;
/* 头部状态 */
@property(nonatomic,assign) CGFloat gradientProgress;
@end

@implementation DSVipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpRefresh];
    [self startShimmer];
    [self getMemberGoodsDataRequest:YES];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 150.f+(HX_SCREEN_WIDTH)*170/375.f+(HX_SCREEN_WIDTH)*110/375.f);
}
-(NSMutableArray *)vipGoods
{
    if (_vipGoods == nil) {
        _vipGoods = [NSMutableArray array];
    }
    return _vipGoods;
}
-(DSVipHeader *)header
{
    if (_header == nil) {
        _header = [DSVipHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 150.f+(HX_SCREEN_WIDTH)*170/375.f+(HX_SCREEN_WIDTH)*110/375.f);
        hx_weakify(self);
        _header.vipHeaderBtnClickedCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            DSWebContentVC *wvc = [DSWebContentVC new];
            wvc.navTitle = @"积分时代";
            wvc.isNeedRequest = YES;
            wvc.requestType = 7;
            [strongSelf.navigationController pushViewController:wvc animated:YES];
        };
    }
    return _header;
}
-(void)setUpNavBar
{
    self.hbd_barAlpha = 0.0;

    [self.navigationItem setTitle:@"会员"];
    
    self.hbd_titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor.whiteColor colorWithAlphaComponent:0]};

    //self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(vipQestionClicked) image:HXGetImage(@"问号")];
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 0;//预估高度
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSVipCell class]) bundle:nil] forCellReuseIdentifier:VipCell];
    
    self.tableView.tableHeaderView = self.header;
    
    self.tableView.backgroundColor= [UIColor clearColor];
    
    self.tableView.bounces = NO;
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
//    imageView.image = [UIImage imageNamed:@"会员背景"];
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.layer.masksToBounds = YES;
//    self.tableView.backgroundView = imageView;
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getMemberGoodsDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getMemberGoodsDataRequest:NO];
    }];
}
#pragma mark -- 点击
-(void)vipQestionClicked
{
    DSWebContentVC *wvc = [DSWebContentVC new];
    wvc.navTitle = @"会员权益说明";
    wvc.isNeedRequest = YES;
    wvc.requestType = 3;
    [self.navigationController pushViewController:wvc animated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat progress = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGFloat gradientProgress = MIN(1, MAX(0, progress / 180.f));
    if (gradientProgress != _gradientProgress) {
        _gradientProgress = gradientProgress;
        if (_gradientProgress < 0.1) {
            //self.hbd_barStyle = UIBarStyleBlack;
            //self.hbd_tintColor = UIColor.clearColor;
            self.hbd_titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor.whiteColor colorWithAlphaComponent:0]};
        } else {
            //self.hbd_barStyle = UIBarStyleDefault;
            //self.hbd_tintColor = UIColor.whiteColor;
            self.hbd_titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor.whiteColor colorWithAlphaComponent:_gradientProgress] };
        }
        self.hbd_barAlpha = _gradientProgress;
        [self hbd_setNeedsUpdateNavigationBar];
    }
   
    if (progress <= 0) {
        self.tableView.bounces = NO;
        
        CGPoint offset = self.tableView.contentOffset;
        offset.y = 0;
        self.tableView.contentOffset = offset;
    }else {
        self.tableView.bounces = YES;
    }
}

#pragma mark -- 接口请求
/** 列表请求 */
-(void)getMemberGoodsDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger pagenum = self.pagenum+1;
        parameters[@"page"] = @(pagenum);//第几页
    }

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"member_goods_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.vipGoods removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[DSVipGoods class] json:responseObject[@"result"][@"list"]];
                [strongSelf.vipGoods addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"result"][@"list"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"result"][@"list"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[DSVipGoods class] json:responseObject[@"result"][@"list"]];
                    [strongSelf.vipGoods addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
                if (strongSelf.vipGoods.count) {
                    [strongSelf.tableView ly_hideEmptyView];
                }else{
                    [strongSelf.tableView ly_showEmptyView];
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

#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.vipGoods.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSVipCell *cell = [tableView dequeueReusableCellWithIdentifier:VipCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DSVipGoods *goods = self.vipGoods[indexPath.row];
    cell.goods = goods;
    hx_weakify(self);
    cell.buyClickCall = ^{
        hx_strongify(weakSelf);
        DSVipGoodsDetailVC *dvc = [DSVipGoodsDetailVC new];
        dvc.goods_id = goods.goods_id;
        [strongSelf.navigationController pushViewController:dvc animated:YES];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DSVipGoods *goods = self.vipGoods[indexPath.row];
    DSVipGoodsDetailVC *dvc = [DSVipGoodsDetailVC new];
    dvc.goods_id = goods.goods_id;
    [self.navigationController pushViewController:dvc animated:YES];
}


@end
