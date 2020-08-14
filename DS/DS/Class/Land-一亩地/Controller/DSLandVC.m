//
//  DSLandVC.m
//  DS
//
//  Created by huaxin-01 on 2020/7/29.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSLandVC.h"
#import "DSLandHeader.h"
#import "DSLandCell.h"
#import "DSLandDetailVC.h"
#import "DSLand.h"
#import "DSWebContentVC.h"
#import "DSGoodsDetailVC.h"

static NSString *const LandCell = @"LandCell";
@interface DSLandVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) DSLandHeader *header;
/* 一亩地数据 */
@property (nonatomic, strong) DSLand *land;
@end

@implementation DSLandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F6F7"];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpRefresh];
    [self startShimmer];
    [self getLandHomeDataRequest:YES];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, (HX_SCREEN_WIDTH)*140/375.0 + 115);
}
-(DSLandHeader *)header
{
    if (!_header) {
        _header = [DSLandHeader loadXibView];
        _header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, (HX_SCREEN_WIDTH)*140/375.0 + 115);
        hx_weakify(self);
        _header.landHeaderClickCall = ^(NSInteger type, NSInteger index) {
            hx_strongify(weakSelf);
            DSLandAdv *adv = nil;
            if (type == 1) {
                adv = strongSelf.land.jgq[index];
            }else{
                adv = strongSelf.land.adv[index];
            }
            /**1仅图片；2链接；3html内容；4商品详情，类型未html时不返回adv_content，通过详情接口获取*/
            if ([adv.adv_type isEqualToString:@"1"]) {
                
            }else if ([adv.adv_type isEqualToString:@"2"]) {
                DSWebContentVC *wvc = [DSWebContentVC new];
                wvc.navTitle = adv.adv_name;
                wvc.isNeedRequest = NO;
                wvc.url = adv.adv_content;
                [strongSelf.navigationController pushViewController:wvc animated:YES];
            }else if ([adv.adv_type isEqualToString:@"3"]) {
                DSWebContentVC *wvc = [DSWebContentVC new];
                wvc.navTitle = adv.adv_name;
                wvc.isNeedRequest = YES;
                wvc.requestType = 1;
                wvc.adv_id = adv.adv_id;
                [strongSelf.navigationController pushViewController:wvc animated:YES];
            }else{
                DSGoodsDetailVC *dvc = [DSGoodsDetailVC new];
                dvc.goods_id = adv.adv_content;
                [strongSelf.navigationController pushViewController:dvc animated:YES];
            }
        };
    }
    return _header;
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"鲸宇粮仓"];
    
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_barTintColor = [UIColor whiteColor];
    self.hbd_tintColor = [UIColor blackColor];
    self.hbd_barShadowHidden = YES;
    self.hbd_titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName: [UIColor.blackColor colorWithAlphaComponent:1.0]};
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
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F6F7"];
    self.tableView.estimatedRowHeight = 0;//预估高度
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSLandCell class]) bundle:nil] forCellReuseIdentifier:LandCell];
    
    self.tableView.tableHeaderView = self.header;
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getLandHomeDataRequest:YES];
    }];
//    //追加尾部刷新
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        hx_strongify(weakSelf);
//        [strongSelf getMemberGoodsDataRequest:NO];
//    }];
}
-(void)getLandHomeDataRequest:(BOOL)isRefresh
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"land_home_get" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [strongSelf.tableView.mj_header endRefreshing];
        if ([responseObject[@"status"] integerValue] == 1) {
            strongSelf.land = [DSLand yy_modelWithDictionary:responseObject[@"result"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.header.land = strongSelf.land;
                [strongSelf.tableView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [strongSelf.tableView.mj_header endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.land.land_goods.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSLandCell *cell = [tableView dequeueReusableCellWithIdentifier:LandCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DSLandGoods *landGood = self.land.land_goods[indexPath.row];
    cell.landGood = landGood;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 195.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DSLandDetailVC *dvc = [DSLandDetailVC new];
    DSLandGoods *landGood = self.land.land_goods[indexPath.row];
    dvc.goods_id = landGood.goods_id;
    [self.navigationController pushViewController:dvc animated:YES];
}
@end
