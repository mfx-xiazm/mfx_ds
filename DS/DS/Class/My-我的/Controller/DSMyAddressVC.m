//
//  DSMyAddressVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMyAddressVC.h"
#import "DSMyAddressCell.h"
#import "DSEditAddressVC.h"
#import "DSMyAddress.h"
#import "zhAlertView.h"
#import <zhPopupController.h>

static NSString *const MyAddressCell = @"MyAddressCell";
@interface DSMyAddressVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 列表 */
@property(nonatomic,strong) NSMutableArray *addresses;
/* 添加 */
@property(nonatomic,strong) UIBarButtonItem *addItem;
@end

@implementation DSMyAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的地址"];
    UIBarButtonItem *addItem = [UIBarButtonItem itemWithTarget:self action:@selector(addAddressClicked) title:@"添加" font:[UIFont systemFontOfSize:15] titleColor:[UIColor whiteColor] highlightedColor:[UIColor whiteColor] titleEdgeInsets:UIEdgeInsetsZero];
    self.addItem = addItem;
    [self setUpTableView];
    [self setUpEmptyView];
    [self setUpRefresh];
    [self startShimmer];
    [self getAddressListRequest:YES];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(NSMutableArray *)addresses
{
    if (_addresses == nil) {
        _addresses = [NSMutableArray array];
    }
    return _addresses;
}
-(void)setUpTableView
{
    self.tableView.rowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSMyAddressCell class]) bundle:nil] forCellReuseIdentifier:MyAddressCell];
}
-(void)setUpEmptyView
{
    hx_weakify(self);
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"no_address" titleStr:@"您还没有添加地址" detailStr:nil btnTitleStr:@"去添加" btnClickBlock:^{
        hx_strongify(weakSelf);
        [strongSelf addAddressClicked];
    }];
    emptyView.titleLabFont = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
    emptyView.titleLabTextColor = UIColorFromRGB(0x666666);
    emptyView.actionBtnFont = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
    emptyView.actionBtnTitleColor = HXControlBg;
    emptyView.contentViewOffset = -(self.HXNavBarHeight);
    emptyView.subViewMargin = 20.f;
    emptyView.autoShowEmptyView = NO;
    self.tableView.ly_emptyView = emptyView;
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getAddressListRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getAddressListRequest:NO];
    }];
}
#pragma mark -- 业务逻辑
-(void)getAddressListRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger pagenum = self.pagenum+1;
        parameters[@"page"] = @(pagenum);//第几页
    }
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"address_list_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.addresses removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[DSMyAddress class] json:responseObject[@"result"][@"list"]];
                [strongSelf.addresses addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"result"][@"list"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"result"][@"list"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[DSMyAddress class] json:responseObject[@"result"][@"list"]];
                    [strongSelf.addresses addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
                if (strongSelf.addresses.count) {
                    [strongSelf.tableView ly_hideEmptyView];
                    strongSelf.navigationItem.rightBarButtonItem = self.addItem;
                }else{
                    [strongSelf.tableView ly_showEmptyView];
                    strongSelf.navigationItem.rightBarButtonItem = nil;
                }
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)setDefaultAddressRequestWithAddressId:(NSString *)address_id isDefault:(NSString *)is_default completedCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"address_id"] = address_id;
    parameters[@"is_default"] = is_default;

    [HXNetworkTool POST:HXRC_M_URL action:@"address_default_set" parameters:parameters success:^(id responseObject) {
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (completedCall) {
                completedCall();
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)delAddressRequest:(DSMyAddress *)address
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"address_id"] = address.address_id;

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"address_delete_set" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            NSMutableArray *temp = [NSMutableArray arrayWithArray:strongSelf.addresses];
            [temp removeObject:address];
            strongSelf.addresses = temp;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
                if (strongSelf.addresses.count) {
                    [strongSelf.tableView ly_hideEmptyView];
                    strongSelf.navigationItem.rightBarButtonItem = self.addItem;
                }else{
                    [strongSelf.tableView ly_showEmptyView];
                    strongSelf.navigationItem.rightBarButtonItem = nil;
                }
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 点击事件
- (void)addAddressClicked {
    DSEditAddressVC *avc = [DSEditAddressVC new];
    hx_weakify(self);
    avc.editSuccessCall = ^{
        hx_strongify(weakSelf);
        [strongSelf getAddressListRequest:YES];
    };
    [self.navigationController pushViewController:avc animated:YES];
}

#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addresses.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSMyAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:MyAddressCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DSMyAddress *address = self.addresses[indexPath.row];
    cell.address = address;
    hx_weakify(self);
    cell.addressClickedCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        if (index == 1) {
            [strongSelf setDefaultAddressRequestWithAddressId:address.address_id isDefault:address.is_default?@"0":@"1" completedCall:^{
                [weakSelf getAddressListRequest:YES];
            }];
        }else if (index == 2) {
            zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"是否要删除该地址？" constantWidth:HX_SCREEN_WIDTH - 50*2];
            hx_weakify(self);
            zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                hx_strongify(weakSelf);
                [strongSelf.zh_popupController dismiss];
            }];
            zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"删除" handler:^(zhAlertButton * _Nonnull button) {
                hx_strongify(weakSelf);
                [strongSelf.zh_popupController dismiss];
                [strongSelf delAddressRequest:address];
            }];
            cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            okButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
            [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
            strongSelf.zh_popupController = [[zhPopupController alloc] init];
            [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
        }else{
            DSEditAddressVC *avc = [DSEditAddressVC new];
            avc.address = address;
            avc.editSuccessCall = ^{
                [strongSelf getAddressListRequest:YES];
            };
            [strongSelf.navigationController pushViewController:avc animated:YES];
        }
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 110.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DSMyAddress *address = self.addresses[indexPath.row];
    if (self.getAddressCall) {
        self.getAddressCall(address);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
