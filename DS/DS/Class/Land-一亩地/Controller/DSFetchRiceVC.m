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
#import "DSGranary.h"
#import "DSMyAddress.h"

static NSString *const FetchRiceCell = @"FetchRiceCell";
@interface DSFetchRiceVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *fetch_num;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
/* 头视图 */
@property(nonatomic,strong) DSFetchRiceHeader *header;

@end

@implementation DSFetchRiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self handleFetchData];
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
            avc.getAddressCall = ^(DSMyAddress * _Nonnull address) {
                strongSelf.granary.address = address;
                [strongSelf handleFetchData];
            };
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
    if (!self.granary.address) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择地址"];
        return;
    }
//    if (self.granary.pick_num < [self.granary.min_pick_num floatValue]) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[NSString stringWithFormat:@"每次提粮总重量不能低于%@kg",self.granary.min_pick_num]];
//        return;
//    }
    if (self.granary.pick_num > self.granary.millet) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"粮票不足"];
        return;
    }
    DSFetchRiceConfirmView *pv = [DSFetchRiceConfirmView loadXibView];
    pv.hxn_size = CGSizeMake(HX_SCREEN_WIDTH-36*2, 410);
    pv.granary = self.granary;
    hx_weakify(self);
    pv.confirmBtnClickedCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        if (index) {
            [strongSelf landPickMilletSetRequest];
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeCenter;
    self.zh_popupController.dismissOnMaskTouched = NO;
    [self.zh_popupController presentContentView:pv duration:0.25 springAnimated:NO];
}
#pragma mark -- 业务逻辑
-(void)handleFetchData
{
    self.header.granary = self.granary;

    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hx_strongify(weakSelf);
        [strongSelf.tableView reloadData];
    });
}
-(void)handleFetchRiceNumData
{
    __block NSInteger pick_num = 0;
    [self.granary.goods enumerateObjectsUsingBlock:^(DSGranaryGoods * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.sku enumerateObjectsUsingBlock:^(DSGranaryGoodSku * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            pick_num += obj.fetch_num * obj.millet;
        }];
    }];
    
    self.fetch_num.text = [NSString stringWithFormat:@"%zd张",pick_num];
    if (pick_num > 0) {
        self.submitBtn.enabled = YES;
        self.submitBtn.backgroundColor = UIColorFromRGB(0x48B664);
    }else{
        self.submitBtn.enabled = NO;
        self.submitBtn.backgroundColor = UIColorFromRGB(0xEDEDED);
    }
    
    self.granary.pick_num = pick_num;
}
-(void)landPickMilletSetRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableString *goods_data = [NSMutableString string];
    [goods_data appendString:@"["];
    [self.granary.goods enumerateObjectsUsingBlock:^(DSGranaryGoods * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.sku enumerateObjectsUsingBlock:^(DSGranaryGoodSku * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.fetch_num != 0) {
                if (goods_data.length == 1) {
                    [goods_data appendFormat:@"{\"goods_id\":\"%@\",\"sku_id\":\"%@\",\"num\":\"%@\",\"share_uid\":\"%@\"}",obj.goods_id,obj.sku_id,@(obj.fetch_num),@(0)];
                }else{
                    [goods_data appendFormat:@",{\"goods_id\":\"%@\",\"sku_id\":\"%@\",\"num\":\"%@\",\"share_uid\":\"%@\"}",obj.goods_id,obj.sku_id,@(obj.fetch_num),@(0)];
                }
            }
        }];
    }];
    [goods_data appendString:@"]"];
    parameters[@"goods_data"] = goods_data;
    parameters[@"address_id"] = self.granary.address.address_id;
    parameters[@"pick_millet"] = @(self.granary.pick_num);

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"land_pick_millet_set" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (strongSelf.fetchRiceCall) {
                strongSelf.fetchRiceCall();
            }
            DSFetchRiceResultVC *rvc = [DSFetchRiceResultVC new];
            [strongSelf.navigationController pushViewController:rvc animated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.granary.goods.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSFetchRiceCell *cell = [tableView dequeueReusableCellWithIdentifier:FetchRiceCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DSGranaryGoods *goods = self.granary.goods[indexPath.row];
    cell.goods = goods;
    hx_weakify(self);
    cell.fetchRiceNumCall = ^{
        hx_strongify(weakSelf);
        [strongSelf handleFetchRiceNumData];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DSGranaryGoods *goods = self.granary.goods[indexPath.row];
    return 30.f + (goods.row_num * 105.f);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
