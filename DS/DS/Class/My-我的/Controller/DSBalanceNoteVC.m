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

static NSString *const MyBalanceCell = @"MyBalanceCell";
@interface DSBalanceNoteVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 时间筛选 */
@property(nonatomic,strong) WSDatePickerView *datePicker;
@end

@implementation DSBalanceNoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(WSDatePickerView *)datePicker
{
    if (_datePicker == nil) {
//        hx_weakify(self);
        _datePicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSString *start, NSString *end) {
//            hx_strongify(weakSelf);
            HXLog(@"%@  %@",start,end);
        }];
        _datePicker.maxLimitDate = [NSDate date];
        _datePicker.dateLabelColor = HXControlBg;//年-月-日 颜色
        _datePicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
        _datePicker.doneButtonColor = HXControlBg;//确定按钮的颜色
    }
    return _datePicker;
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH - 96.f, 30.f)];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 6;
    searchBar.layer.masksToBounds = YES;
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入商品名称查询";
    self.navigationItem.titleView = searchBar;
    
    SPButton *msg = [SPButton buttonWithType:UIButtonTypeCustom];
    msg.imagePosition = SPButtonImagePositionTop;
    msg.imageTitleSpace = 2.f;
    msg.hxn_size = CGSizeMake(44, 44);
    msg.titleLabel.font = [UIFont systemFontOfSize:9];
    [msg setImage:HXGetImage(@"筛选") forState:UIControlStateNormal];
    [msg addTarget:self action:@selector(filterClicked) forControlEvents:UIControlEventTouchUpInside];
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
-(void)filterClicked
{
    HXLog(@"筛选");
    //年-月-日
    [self.datePicker show];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSMyBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:MyBalanceCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

@end
