//
//  DSBalanceNoteVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSBalanceNoteVC.h"
#import "DSMyBalanceCell.h"
#import "HXSearchBar.h"
#import "WSDatePickerView.h"
#import "DSBalanceNote.h"

static NSString *const MyBalanceCell = @"MyBalanceCell";
@interface DSBalanceNoteVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 时间筛选 */
@property(nonatomic,strong) WSDatePickerView *datePicker;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 列表 */
@property(nonatomic,strong) NSMutableArray *notes;
/* 开始时间 */
@property(nonatomic,copy) NSString *begin_date;
/* 结束日期 */
@property(nonatomic,copy) NSString *end_date;
/* 关键ci */
@property(nonatomic,copy) NSString *keyword;
@end

@implementation DSBalanceNoteVC

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
-(WSDatePickerView *)datePicker
{
    if (_datePicker == nil) {
        hx_weakify(self);
        _datePicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSString *start, NSString *end) {
            hx_strongify(weakSelf);
            strongSelf.begin_date = start;
            strongSelf.end_date = end;
            [strongSelf getNoteListDataRequest:YES];
        }];
        _datePicker.dateLabelColor = HXControlBg;//年-月-日 颜色
        _datePicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
        _datePicker.doneButtonColor = HXControlBg;//确定按钮的颜色
    }
    return _datePicker;
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_barTintColor = [UIColor whiteColor];
    self.hbd_tintColor = [UIColor blackColor];
    self.hbd_barShadowHidden = YES;
    
    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH - 70.f, 30.f)];
    searchBar.layer.cornerRadius = 15.f;
    searchBar.layer.masksToBounds = YES;
    searchBar.layer.borderWidth = 1;
    searchBar.layer.borderColor = UIColorFromRGB(0xBBBBBB).CGColor;
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入关键词查询";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backClicked) title:@"取消" font:[UIFont systemFontOfSize:15] titleColor:[UIColor blackColor] highlightedColor:[UIColor blackColor] titleEdgeInsets:UIEdgeInsetsZero];
    /*
    SPButton *msg = [SPButton buttonWithType:UIButtonTypeCustom];
    msg.imagePosition = SPButtonImagePositionTop;
    msg.imageTitleSpace = 2.f;
    msg.hxn_size = CGSizeMake(44, 44);
    msg.titleLabel.font = [UIFont systemFontOfSize:9];
    [msg setImage:HXGetImage(@"筛选") forState:UIControlStateNormal];
    [msg addTarget:self action:@selector(filterClicked) forControlEvents:UIControlEventTouchUpInside];
    [msg setTitleColor:UIColorFromRGB(0XFFFFFF) forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:msg];
     */
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
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 5.f, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSMyBalanceCell class]) bundle:nil] forCellReuseIdentifier:MyBalanceCell];
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.keyword = [textField hasText]?textField.text:@"";
    [self getNoteListDataRequest:YES];
    return YES;
}
#pragma mark -- 接口请求
/** 列表请求 */
-(void)getNoteListDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"reward_type"] = @(self.reward_type);
    if (self.begin_date && self.begin_date.length) {
        parameters[@"begin_date"] = self.begin_date;//开始日期
    }
    if (self.end_date && self.end_date.length) {
        parameters[@"end_date"] = self.end_date;//结束日期
    }
    parameters[@"keywords"] = (self.keyword&&self.keyword.length)?self.keyword:@"";
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger pagenum = self.pagenum+1;
        parameters[@"page"] = @(pagenum);//第几页
    }

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"reward_list_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.notes removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[DSBalanceNote class] json:responseObject[@"result"][@"list"]];
                [strongSelf.notes addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"result"][@"list"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"result"][@"list"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[DSBalanceNote class] json:responseObject[@"result"][@"list"]];
                    [strongSelf.notes addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
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
#pragma mark -- 点击事件
-(void)backClicked
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)filterClicked
{
    //年-月-日
    [self.datePicker show];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notes.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSMyBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:MyBalanceCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DSBalanceNote *note = self.notes[indexPath.row];
    cell.note = note;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DSBalanceNote *note = self.notes[indexPath.row];
    if ([note.finance_log_type isEqualToString:@"2"] || [note.finance_log_type isEqualToString:@"3"] || [note.finance_log_type isEqualToString:@"4"] || [note.finance_log_type isEqualToString:@"5"]) {
        return note.textHeight + 110.f;
    }else{
        return 90.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

@end
