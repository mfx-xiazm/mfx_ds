//
//  DSEditAddressVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSEditAddressVC.h"
#import "HXPlaceholderTextView.h"
#import "UITextField+GYExpand.h"
#import "GXChooseAddressView.h"
#import "GXSelectRegion.h"
#import <zhPopupController.h>
#import "DSMyAddress.h"

@interface DSEditAddressVC ()
@property (weak, nonatomic) IBOutlet UIView *addressDetailView;
@property (weak, nonatomic) IBOutlet UITextField *receiver_phone;
@property (weak, nonatomic) IBOutlet UITextField *receiver;
@property (weak, nonatomic) IBOutlet UITextField *area_name;
/* 详细地址 */
@property(nonatomic,strong) HXPlaceholderTextView *address_detail;
@property (weak, nonatomic) IBOutlet UIButton *is_defalt;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
/* 行政区id */
@property(nonatomic,copy) NSString *district_id;
/* 所有地区 */
@property(nonatomic,strong) GXSelectRegion *region;
/* 地址 */
@property(nonatomic,strong) GXChooseAddressView *addressView;
@end

@implementation DSEditAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.address) {
        [self.navigationItem setTitle:@"编辑地址"];
        self.receiver.text = _address.receiver;
        self.receiver_phone.text = _address.receiver_phone;
        self.area_name.text = _address.area_name;
        self.address_detail.text = _address.address_detail;
        self.is_defalt.selected = _address.is_default;
        self.district_id = _address.district_id;
    }else{
        [self.navigationItem setTitle:@"添加地址"];
    }
    
    [self.addressDetailView addSubview:self.address_detail];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
    NSString *districtStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    if (districtStr == nil) {
        return ;
    }
    NSData *jsonData = [districtStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *district = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    self.region = [[GXSelectRegion alloc] init];
    self.region.regions = [NSArray yy_modelArrayWithClass:[GXRegion class] json:district[@"result"][@"list"]];
    
    hx_weakify(self);
    [self.receiver_phone lengthLimit:^{
        hx_strongify(weakSelf);
        if (strongSelf.receiver_phone.text.length>11) {
            strongSelf.receiver_phone.text = [strongSelf.receiver_phone.text substringToIndex:11];
        }
    }];
    [self.sureBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.receiver_phone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写收货人电话"];
            return NO;
        }
        if (strongSelf.receiver_phone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机号格式有误"];
            return NO;
        }
        if (![strongSelf.receiver hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写收货人"];
            return NO;
        }
        if (![strongSelf.area_name hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择地区"];
            return NO;
        }
        if (![strongSelf.address_detail hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写详细地址"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf addEditAddressRequest:button];
    }];
}
-(HXPlaceholderTextView *)address_detail
{
    if (_address_detail == nil) {
        _address_detail = [[HXPlaceholderTextView alloc] initWithFrame:self.addressDetailView.bounds];
        _address_detail.placeholder = @"请输入详细地址";
    }
    return _address_detail;
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.address_detail.frame = self.addressDetailView.bounds;
}
-(GXChooseAddressView *)addressView
{
    if (_addressView == nil) {
        _addressView = [GXChooseAddressView loadXibView];
        _addressView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 360);
        __weak __typeof(self) weakSelf = self;
        // 最后一列的行被点击的回调
        _addressView.lastComponentClickedBlock = ^(NSInteger type, GXSelectRegion * _Nullable region) {
            [weakSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
            if (type) {
                weakSelf.area_name.text = [NSString stringWithFormat:@"%@-%@-%@",region.selectRegion.alias,region.selectCity.alias,region.selectArea.alias];
                weakSelf.district_id = region.selectArea.ID;
            }
        };
    }
    return _addressView;
}
#pragma mark -- 点击事件
- (IBAction)setDefaultClicked:(UIButton *)sender {
    self.is_defalt.selected = !self.is_defalt.selected;
}

- (IBAction)addressClicked:(UIButton *)sender {
    if (!self.region || !self.region.regions.count) {
        return;
    }
    [self.view endEditing:YES];
    
    self.addressView.region = self.region;
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:self.addressView duration:0.25 springAnimated:NO];
}
#pragma mark -- 业务逻辑
-(void)addEditAddressRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"receiver"] = self.receiver.text;
    parameters[@"receiver_phone"] = self.receiver_phone.text;
    parameters[@"district_id"] = self.district_id;
    parameters[@"address_detail"] = self.address_detail.text;
    parameters[@"is_default"] = @(self.is_defalt.isSelected);
    if (self.address) {
        parameters[@"address_id"] = self.address.address_id;
    }else{
        parameters[@"address_id"] = @"0";//地址id，如果是新增则为0
    }

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"address_addupdate_set" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (strongSelf.editSuccessCall) {
                strongSelf.editSuccessCall();
            }
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
