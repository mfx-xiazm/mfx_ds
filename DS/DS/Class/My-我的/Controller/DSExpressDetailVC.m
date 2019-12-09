//
//  DSExpressDetailVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSExpressDetailVC.h"
#import "DSExpressDetailCell.h"

static NSString *const ExpressDetailCell = @"ExpressDetailCell";
@interface DSExpressDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DSExpressDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"物流详情"];
    [self setUpTableView];
}
#pragma mark -- 懒加载

#pragma mark -- 页面设置
/** 页面设置 */
-(void)setUpTableView
{
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.estimatedRowHeight = 85.f;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSExpressDetailCell class]) bundle:nil] forCellReuseIdentifier:ExpressDetailCell];
    
    UIView *header = [UIView new];
    header.backgroundColor = [UIColor whiteColor];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 30);
    _tableView.tableHeaderView = header;
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSExpressDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:ExpressDetailCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
