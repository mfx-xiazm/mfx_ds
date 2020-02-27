//
//  DSMyTeamVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMyTeamVC.h"
#import "DSMyTeamHeader.h"
#import "DSMyTeamCell.h"
#import "DSMyTeam.h"

static NSString *const MyTeamCell = @"MyTeamCell";
@interface DSMyTeamVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) DSMyTeamHeader *header;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 列表 */
@property(nonatomic,strong) NSMutableArray *teams;
/* 团队总数 */
@property(nonatomic,strong) NSString *teamNum;
@end

@implementation DSMyTeamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hbd_barShadowHidden = YES;
    [self.navigationItem setTitle:@"我的团队"];
    [self setUpTableView];
    [self setUpEmptyView];
    [self setUpRefresh];
    [self startShimmer];
    [self getTeamListDataRequest:YES];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 185.f);
}
-(NSMutableArray *)teams
{
    if (_teams == nil) {
        _teams = [NSMutableArray array];
    }
    return _teams;
}
-(DSMyTeamHeader *)header
{
    if (_header == nil) {
        _header = [DSMyTeamHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 185.f);
    }
    return _header;
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
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 15.f, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSMyTeamCell class]) bundle:nil] forCellReuseIdentifier:MyTeamCell];
    
    self.tableView.tableHeaderView = self.header;
}
-(void)setUpEmptyView
{
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"no_data" titleStr:nil detailStr:@"暂无内容"];
    emptyView.contentViewOffset = -(self.HXNavBarHeight);
    emptyView.subViewMargin = 20.f;
    emptyView.detailLabTextColor = UIColorFromRGB(0x131D2D);
    emptyView.detailLabFont = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
    emptyView.autoShowEmptyView = NO;
    self.tableView.ly_emptyView = emptyView;
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getTeamListDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getTeamListDataRequest:NO];
    }];
}
#pragma mark -- 接口请求
/** 列表请求 */
-(void)getTeamListDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger pagenum = self.pagenum+1;
        parameters[@"page"] = @(pagenum);//第几页
    }

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"myteam_list_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"status"] integerValue] == 1) {
            if (isRefresh) {
                strongSelf.teamNum = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"num"]];
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.teams removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[DSMyTeam class] json:responseObject[@"result"][@"list"]];
                [strongSelf.teams addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"result"][@"list"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"result"][@"list"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[DSMyTeam class] json:responseObject[@"result"][@"list"]];
                    [strongSelf.teams addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.header.teamNum.text = strongSelf.teamNum;
                [strongSelf.tableView reloadData];
                if (strongSelf.teams.count) {
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
    return self.teams.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSMyTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:MyTeamCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DSMyTeam *team = self.teams[indexPath.row];
    cell.team = team;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}
@end
