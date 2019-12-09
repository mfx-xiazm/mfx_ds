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

static NSString *const CashNoteCell = @"CashNoteCell";
@interface DSCashNoteVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DSCashNoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"提现记录"];
    [self setUpTableView];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSCashNoteCell class]) bundle:nil] forCellReuseIdentifier:CashNoteCell];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSCashNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:CashNoteCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DSCashNoteDetailVC *dvc = [DSCashNoteDetailVC new];
    [self.navigationController pushViewController:dvc animated:YES];
}

@end
