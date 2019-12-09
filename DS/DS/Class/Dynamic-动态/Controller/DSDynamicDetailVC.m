//
//  DSDynamicDetailVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSDynamicDetailVC.h"
#import "DSDynamicDetailHeader.h"
#import "DSDynamicDetailCell.h"
#import "DSDynamicDetailFooter.h"

static NSString *const DynamicDetailCell = @"DynamicDetailCell";
@interface DSDynamicDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
/** tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) DSDynamicDetailHeader *header;
/* 尾视图 */
@property(nonatomic,strong) DSDynamicDetailFooter *footer;

@end

@implementation DSDynamicDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"动态详情"];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 60.f);
    self.footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 50.f);
}
-(DSDynamicDetailHeader *)header
{
    if (_header == nil) {
        _header = [DSDynamicDetailHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 60.f);
    }
    return _header;
}
-(DSDynamicDetailFooter *)footer
{
    if (_footer == nil) {
        _footer = [DSDynamicDetailFooter loadXibView];
        _footer.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 50.f);
    }
    return _footer;
}
#pragma mark -- 视图相关
/**
 初始化tableView
 */
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
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSDynamicDetailCell class]) bundle:nil] forCellReuseIdentifier:DynamicDetailCell];
    
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSDynamicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:DynamicDetailCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row %2) {
        cell.content_img.hidden = NO;
        cell.content_text.hidden = YES;
    }else{
        cell.content_img.hidden = YES;
        cell.content_text.hidden = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    if (indexPath.row %2) {
        return 180.f;
    }else{
        return UITableViewAutomaticDimension;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
