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

static NSString *const MyTeamCell = @"MyTeamCell";
@interface DSMyTeamVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) DSMyTeamHeader *header;

@end

@implementation DSMyTeamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的团队"];
    [self setUpTableView];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 185.f);
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

#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSMyTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:MyTeamCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
