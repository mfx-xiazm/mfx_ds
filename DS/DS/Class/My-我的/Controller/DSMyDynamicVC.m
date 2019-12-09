//
//  DSMyDynamicVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMyDynamicVC.h"
#import "DSDynamicCell.h"
#import "DSDynamicLayout.h"

@interface DSMyDynamicVC ()<UITableViewDelegate,UITableViewDataSource,DSDynamicCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 布局数组 */
@property (nonatomic,strong) NSMutableArray *layoutsArr;

@end

@implementation DSMyDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的动态"];
    [self setUpTableView];
}
-(NSMutableArray *)layoutsArr
{
    if (!_layoutsArr) {
        _layoutsArr = [NSMutableArray array];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"moment2" ofType:@"plist"];
        NSArray *dataArray = [NSArray arrayWithContentsOfFile:plistPath];
        for (NSDictionary *dict in dataArray) {
            DSDynamic *model = [DSDynamic yy_modelWithDictionary:dict];
            DSDynamicLayout *layout = [[DSDynamicLayout alloc] initWithModel:model];
            [_layoutsArr addObject:layout];
        }
    }
    return _layoutsArr;
}
#pragma mark -- 视图相关
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
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma arguments DSDynamicCell代理
/** 点赞 */
- (void)didClickThumbInCell:(DSDynamicCell *)Cell
{
    
}
/** 分享 */
- (void)didClickShareInCell:(DSDynamicCell *)Cell
{
    
}

@end
