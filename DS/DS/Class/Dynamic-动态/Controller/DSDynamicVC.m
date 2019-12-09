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

@interface DSDynamicVC ()<UITableViewDelegate,UITableViewDataSource,DSDynamicCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 布局数组 */
@property (nonatomic,strong) NSMutableArray *layoutsArr;
@end

@implementation DSDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
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
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH - 70.f, 30.f)];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 6;
    searchBar.layer.masksToBounds = YES;
    //searchBar.delegate = self;
    searchBar.placeholder = @"请输入商品名称查询";
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
-(void)publishClicked
{
    DSPublishDynamicVC *pvc = [DSPublishDynamicVC new];
    [self.navigationController pushViewController:pvc animated:YES];
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
    DSDynamicDetailVC *dvc = [DSDynamicDetailVC new];
    [self.navigationController pushViewController:dvc animated:YES];
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
