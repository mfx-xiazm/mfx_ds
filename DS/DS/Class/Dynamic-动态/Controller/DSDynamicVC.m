//
//  DSDynamicVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/11.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSDynamicVC.h"
#import "DSDynamicCell.h"
#import "DSDynamicLayout.h"
#import "HXSearchBar.h"
#import "DSPublishDynamicVC.h"
#import "DSDynamicDetailVC.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "DSSearchDynamicVC.h"

@interface DSDynamicVC ()<UITableViewDelegate,UITableViewDataSource,DSDynamicCellDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 布局数组 */
@property (nonatomic,strong) NSMutableArray *layoutsArr;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
@end

@implementation DSDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpEmptyView];
    [self setUpRefresh];
    [self startShimmer];
    [self getDynamicDataRequest:YES];
}
-(NSMutableArray *)layoutsArr
{
    if (!_layoutsArr) {
        _layoutsArr = [NSMutableArray array];
    }
    return _layoutsArr;
}
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH - 70.f, 30.f)];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 6;
    searchBar.layer.masksToBounds = YES;
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入动态标题查询";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    
    SPButton *msg = [SPButton buttonWithType:UIButtonTypeCustom];
    msg.hxn_size = CGSizeMake(44, 44);
    msg.titleLabel.font = [UIFont systemFontOfSize:9];
    [msg setImage:HXGetImage(@"发布") forState:UIControlStateNormal];
    [msg addTarget:self action:@selector(publishClicked) forControlEvents:UIControlEventTouchUpInside];
    [msg setTitleColor:UIColorFromRGB(0XFFFFFF) forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:msg];
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
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        [strongSelf getDynamicDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getDynamicDataRequest:NO];
    }];
}
-(void)publishClicked
{
    DSPublishDynamicVC *pvc = [DSPublishDynamicVC new];
    [self.navigationController pushViewController:pvc animated:YES];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    DSSearchDynamicVC *svc = [DSSearchDynamicVC new];
    [self.navigationController pushViewController:svc animated:YES];
    return NO;
}
#pragma mark -- 接口请求
/** 列表请求 */
-(void)getDynamicDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"is_self"] = @"0";//是否仅返回自己的，0返回全部动态动态，1仅返回自己的动态
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger pagenum = self.pagenum+1;
        parameters[@"page"] = @(pagenum);//第几页
    }

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"treads_list_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.layoutsArr removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[DSDynamic class] json:responseObject[@"result"][@"list"]];
                for (DSDynamic *dynamic in arrt) {
                    DSDynamicLayout *layout = [[DSDynamicLayout alloc] initWithModel:dynamic];
                    [strongSelf.layoutsArr addObject:layout];
                }
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"result"][@"list"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"result"][@"list"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[DSDynamic class] json:responseObject[@"result"][@"list"]];
                    for (DSDynamic *dynamic in arrt) {
                        DSDynamicLayout *layout = [[DSDynamicLayout alloc] initWithModel:dynamic];
                        [strongSelf.layoutsArr addObject:layout];
                    }
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
                if (strongSelf.layoutsArr.count) {
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
-(void)setDynamicPraiseRequest:(NSString *)treads_id isPraise:(NSString *)is_praise completedCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"treads_id"] = treads_id;//动态id
    parameters[@"is_praise"] = is_praise;//是否点赞，1点赞，0取消点赞

    [HXNetworkTool POST:HXRC_M_URL action:@"treads_praise_set" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            if (completedCall) {
                completedCall();
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)setDynamicDeleteRequest:(NSString *)treads_id completedCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"treads_id"] = treads_id;//动态id

    [HXNetworkTool POST:HXRC_M_URL action:@"treads_delete_set" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
            if (completedCall) {
                completedCall();
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.layoutsArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DSDynamicLayout *layout = self.layoutsArr[indexPath.row];
    return layout.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DSDynamicCell * cell = [DSDynamicCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DSDynamicLayout *layout = self.layoutsArr[indexPath.row];
    cell.dynamicLayout = layout;
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DSDynamicLayout *layout = self.layoutsArr[indexPath.row];
    DSDynamicDetailVC *dvc = [DSDynamicDetailVC new];
    dvc.treads_id = layout.dynamic.treads_id;
    hx_weakify(self);
    dvc.dynamicDetailCall = ^(NSUInteger type) {
        hx_strongify(weakSelf);
        if (type == 1) {
            layout.dynamic.is_praise = !layout.dynamic.is_praise;
        }else{
            [strongSelf.layoutsArr removeObject:layout];
        }
        [strongSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:dvc animated:YES];
}
#pragma mark -- DSDynamicCell代理
/** 点赞 */
- (void)didClickThumbInCell:(DSDynamicCell *)Cell
{
    DSDynamic *dynamic = Cell.dynamicLayout.dynamic;
    
    hx_weakify(self);
    [self setDynamicPraiseRequest:dynamic.treads_id isPraise:dynamic.is_praise?@"0":@"1" completedCall:^{
        hx_strongify(weakSelf);
        dynamic.is_praise = !dynamic.is_praise;
        [strongSelf.tableView reloadData];
    }];
}
/** 分享 */
- (void)didClickShareInCell:(DSDynamicCell *)Cell
{
    HXLog(@"分享");
}
/** 删除 */
- (void)didClickDeleteInCell:(DSDynamicCell *)Cell
{
    DSDynamicLayout *layout = Cell.dynamicLayout;
    DSDynamic *dynamic = layout.dynamic;

    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该条动态吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
    hx_weakify(self);
    zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
    }];
    zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"删除" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
        [strongSelf setDynamicDeleteRequest:dynamic.treads_id completedCall:^{
            [weakSelf.layoutsArr removeObject:layout];
            [weakSelf.tableView reloadData];
        }];
    }];
    cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    okButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
    [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
    self.zh_popupController = [[zhPopupController alloc] init];
    [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
}
@end
