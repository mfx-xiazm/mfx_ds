//
//  DSVipVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/11.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSVipVC.h"
#import "DSVipHeader.h"
#import "DSVipCell.h"
#import "DSVipCardVC.h"
#import "DSVipGoodsDetailVC.h"

static NSString *const VipCell = @"VipCell";
@interface DSVipVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) DSVipHeader *header;

@end

@implementation DSVipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 135.f+(HX_SCREEN_WIDTH-10.f*3)/2.0*9/17.f+60.f);
}
-(DSVipHeader *)header
{
    if (_header == nil) {
        _header = [DSVipHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 135.f+(HX_SCREEN_WIDTH-10.f*3)/2.0*9/17.f+60.f);
        hx_weakify(self);
        _header.vipHeaderBtnClickedCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            if (index == 0) {
                
            }else{
                DSVipCardVC *ovc = [DSVipCardVC new];
                [strongSelf.navigationController pushViewController:ovc animated:YES];
            }
        };
    }
    return _header;
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"会员"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(vipQestionClicked) image:HXGetImage(@"问号")];
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
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSVipCell class]) bundle:nil] forCellReuseIdentifier:VipCell];
    
    self.tableView.tableHeaderView = self.header;
    
    self.tableView.backgroundColor= [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
    imageView.image = [UIImage imageNamed:@"会员背景"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    self.tableView.backgroundView = imageView;
}
#pragma mark -- 点击
-(void)vipQestionClicked
{
    
}
#pragma mark -- 业务逻辑

#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSVipCell *cell = [tableView dequeueReusableCellWithIdentifier:VipCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DSVipGoodsDetailVC *dvc = [DSVipGoodsDetailVC new];
    [self.navigationController pushViewController:dvc animated:YES];
}


@end
