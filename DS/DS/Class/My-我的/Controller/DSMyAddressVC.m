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

static NSString *const MyAddressCell = @"MyAddressCell";
@interface DSMyAddressVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DSMyAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的地址"];
    [self setUpTableView];
//    [self startShimmer];
//    [self getAddressListRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
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
#pragma mark -- 业务逻辑
-(void)getAddressListRequest
{
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getAddressList" parameters:@{} success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        [strongSelf stopShimmer];
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            strongSelf.addressList = [NSArray yy_modelArrayWithClass:[GXMyAddress class] json:responseObject[@"data"]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                strongSelf.tableView.hidden = NO;
//                [strongSelf.tableView reloadData];
//            });
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        hx_strongify(weakSelf);
//        [strongSelf stopShimmer];
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
}
-(void)setDefaultAddressRequest:(NSString *)address_id  is_default:(NSString *)is_default
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"address_id"] = address_id;
//    parameters[@"is_default"] = is_default;
//
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:@"admin/setDefaultAddress" parameters:parameters success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            [strongSelf getAddressListRequest];
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
}
//-(void)delAddressRequest:(GXMyAddress *)address
//{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"address_id"] = address.address_id;
//
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:@"admin/delAddress" parameters:parameters success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            NSMutableArray *temp = [NSMutableArray arrayWithArray:strongSelf.addressList];
//            [temp removeObject:address];
//            strongSelf.addressList = temp;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [strongSelf.tableView reloadData];
//            });
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
//}
#pragma mark -- 点击事件
- (IBAction)addAddressClicked:(UIButton *)sender {
    DSEditAddressVC *avc = [DSEditAddressVC new];
//    hx_weakify(self);
//    avc.editSuccessCall = ^{
//        hx_strongify(weakSelf);
//        [strongSelf getAddressListRequest];
//    };
    [self.navigationController pushViewController:avc animated:YES];
}

#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSMyAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:MyAddressCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    GXMyAddress *address = self.addressList[indexPath.row];
//    cell.address = address;
//    hx_weakify(self);
//    cell.addressClickedCall = ^(NSInteger index) {
//        hx_strongify(weakSelf);
//        if (index == 1) {
//            [strongSelf setDefaultAddressRequest:address.address_id is_default:address.is_default?@"0":@"1"];
//        }else if (index == 2) {
//            zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该地址吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
//            hx_weakify(self);
//            zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
//                hx_strongify(weakSelf);
//                [strongSelf.zh_popupController dismiss];
//            }];
//            zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"删除" handler:^(zhAlertButton * _Nonnull button) {
//                hx_strongify(weakSelf);
//                [strongSelf.zh_popupController dismiss];
//                [strongSelf delAddressRequest:address];
//            }];
//            cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
//            [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
//            okButton.lineColor = UIColorFromRGB(0xDDDDDD);
//            [okButton setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
//            [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
//            strongSelf.zh_popupController = [[zhPopupController alloc] init];
//            [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
//        }else{
//            GXEditAddressVC *avc = [GXEditAddressVC new];
//            avc.address = address;
//            avc.editSuccessCall = ^{
//                [strongSelf getAddressListRequest];
//            };
//            [strongSelf.navigationController pushViewController:avc animated:YES];
//        }
//    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 105.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GXMyAddress *address = self.addressList[indexPath.row];
//    if (self.getAddressCall) {
//        self.getAddressCall(address);
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

@end
