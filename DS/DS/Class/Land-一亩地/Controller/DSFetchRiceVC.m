//
//  DSFetchRiceVC.m
//  DS
//
//  Created by huaxin-01 on 2020/7/29.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSFetchRiceVC.h"
#import "DSFetchRiceHeader.h"
#import "DSFetchRiceCell.h"
#import "DSFetchRiceConfirmView.h"
#import <zhPopupController.h>
#import "DSFetchRiceResultVC.h"
#import "DSMyAddressVC.h"

static NSString *const FetchRiceCell = @"FetchRiceCell";
@interface DSFetchRiceVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) DSFetchRiceHeader *header;

@end

@implementation DSFetchRiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 220.f);
}
-(DSFetchRiceHeader *)header
{
    if (!_header) {
        _header = [DSFetchRiceHeader loadXibView];
        _header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 220.f);
        hx_weakify(self);
        _header.addressClickedCall = ^{
            hx_strongify(weakSelf);
            DSMyAddressVC *avc = [DSMyAddressVC new];
//            avc.getAddressCall = ^(DSMyAddress * _Nonnull address) {
//                strongSelf.confirmOrder.address = address;
//                [strongSelf handleConfirmOrderData];
//            };
            [strongSelf.navigationController pushViewController:avc animated:YES];
        };
    }
    return _header;
}
-(void)setUpNavBar
{
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_barTintColor = HXGlobalBg;
    self.hbd_tintColor = [UIColor blackColor];
    self.hbd_barShadowHidden = YES;
    self.hbd_titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName: [UIColor.blackColor colorWithAlphaComponent:1.0]};
    [self.navigationItem setTitle:@"提粮"];
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
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.estimatedRowHeight = 0;//预估高度
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSFetchRiceCell class]) bundle:nil] forCellReuseIdentifier:FetchRiceCell];
    
    self.tableView.tableHeaderView = self.header;
}
#pragma mark -- 点击事件
- (IBAction)fetchClicked:(UIButton *)sender {
    DSFetchRiceConfirmView *pv = [DSFetchRiceConfirmView loadXibView];
    pv.hxn_size = CGSizeMake(HX_SCREEN_WIDTH-36*2, 410);
    hx_weakify(self);
    pv.confirmBtnClickedCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        if (index) {
            DSFetchRiceResultVC *rvc = [DSFetchRiceResultVC new];
            [strongSelf.navigationController pushViewController:rvc animated:YES];
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeCenter;
    self.zh_popupController.dismissOnMaskTouched = NO;
    [self.zh_popupController presentContentView:pv duration:0.25 springAnimated:NO];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSFetchRiceCell *cell = [tableView dequeueReusableCellWithIdentifier:FetchRiceCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
