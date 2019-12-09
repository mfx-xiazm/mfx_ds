//
//  DSMyBalanceVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMyBalanceVC.h"
#import "DSMyBalanceHeader.h"
#import "DSMyBalanceCell.h"
#import "DSMyBalanceSectionHeader.h"
#import "DSUpCashVC.h"
#import "DSBalanceNoteVC.h"

static NSString *const MyBalanceCell = @"MyBalanceCell";
@interface DSMyBalanceVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) DSMyBalanceHeader *header;

@end

@implementation DSMyBalanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的余额"];
    [self setUpTableView];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 225.f);
}
-(DSMyBalanceHeader *)header
{
    if (_header == nil) {
        _header = [DSMyBalanceHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 225.f);
        hx_weakify(self);
        _header.balanceBtnCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            if (index == 0) {
                DSUpCashVC *cvc = [DSUpCashVC new];
                [strongSelf.navigationController pushViewController:cvc animated:YES];
            }else{
                DSBalanceNoteVC *nvc = [DSBalanceNoteVC new];
                [strongSelf.navigationController pushViewController:nvc animated:YES];
            }
        };
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
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 5.f, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSMyBalanceCell class]) bundle:nil] forCellReuseIdentifier:MyBalanceCell];
    
    self.tableView.tableHeaderView = self.header;
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DSMyBalanceSectionHeader *header = [DSMyBalanceSectionHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44.f);
    
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}
@end
