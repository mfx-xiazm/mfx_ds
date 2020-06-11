//
//  DSCashNoteVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSCashNoteVC.h"
#import "DSCashNoteCell.h"
#import "DSCashNoteDetailVC.h"
#import "DSCashNote.h"
#import "DSDatePickerView.h"

static NSString *const CashNoteCell = @"CashNoteCell";
@interface DSCashNoteVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *cash_total;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 列表 */
@property(nonatomic,strong) NSMutableArray *notes;
/* 时间 */
@property (nonatomic, copy) NSString *time_region;
@end

@implementation DSCashNoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpEmptyView];
    [self setUpRefresh];
    [self startShimmer];
    [self getNoteListDataRequest:YES];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(NSMutableArray *)notes
{
    if (_notes == nil) {
        _notes = [NSMutableArray array];
    }
    return _notes;
}
-(void)setUpNavBar
{
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_barTintColor = [UIColor whiteColor];
    self.hbd_tintColor = [UIColor blackColor];
    self.hbd_barShadowHidden = YES;
    self.hbd_titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName: [UIColor.blackColor colorWithAlphaComponent:1.0]};
    [self.navigationItem setTitle:@"提现记录"];
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
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 110.f;//预估高度
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSCashNoteCell class]) bundle:nil] forCellReuseIdentifier:CashNoteCell];
}
-(void)setUpEmptyView
{
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"no_data" titleStr:nil detailStr:@"暂无内容"];
    emptyView.contentViewOffset = -(self.HXNavBarHeight);
    emptyView.subViewMargin = 20.f;
    emptyView.detailLabTextColor = UIColorFromRGB(0x909090);
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
        [strongSelf getNoteListDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getNoteListDataRequest:NO];
    }];
}
#pragma mark -- 点击事件
- (IBAction)chooseTimeClicked:(SPButton *)sender {
    NSDate *scrollToDate = [sender.currentTitle isEqualToString:@"全部"]?[NSDate date]:[NSDate date:sender.currentTitle WithFormat:@"yyyy-MM"];
    hx_weakify(self);
    DSDatePickerView *datepicker = [[DSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonth scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
        hx_strongify(weakSelf);
        NSTimeZone *nowTimeZone = [NSTimeZone localTimeZone];
        NSInteger timeOffset = [nowTimeZone secondsFromGMTForDate:selectDate];
        NSDate *newDate = [selectDate dateByAddingTimeInterval:timeOffset];
        NSString *date = [newDate stringWithFormat:@"yyyy-MM"];
        [sender setTitle:date forState:UIControlStateNormal];
        
        strongSelf.time_region = date;
        [strongSelf getNoteListDataRequest:YES];
    }];
    datepicker.maxLimitDate = [NSDate date];
       
    [datepicker show];
}
#pragma mark -- 接口请求
/** 列表请求 */
-(void)getNoteListDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger pagenum = self.pagenum+1;
        parameters[@"page"] = @(pagenum);//第几页
    }
    parameters[@"time_region"] = self.time_region?self.time_region:@"";

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"apply_log_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.notes removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[DSCashNote class] json:responseObject[@"result"][@"list"]];
                [strongSelf.notes addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"result"][@"list"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"result"][@"list"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[DSCashNote class] json:responseObject[@"result"][@"list"]];
                    [strongSelf.notes addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.cash_total.text = [NSString stringWithFormat:@"已提现：¥%@",[[NSString stringWithFormat:@"%@",responseObject[@"result"][@"total_amount"]] reviseString]];
                [strongSelf.tableView reloadData];
                if (strongSelf.notes.count) {
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
    return self.notes.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSCashNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:CashNoteCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DSCashNote *note = self.notes[indexPath.row];
    cell.note = note;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DSCashNoteDetailVC *dvc = [DSCashNoteDetailVC new];
//    DSCashNote *note = self.notes[indexPath.row];
//    dvc.finance_apply_id = note.finance_apply_id;
//    [self.navigationController pushViewController:dvc animated:YES];
}

@end
