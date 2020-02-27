//
//  DSCartVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/11.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSCartVC.h"
#import "DSCartCell.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "DSUpOrderVC.h"
#import "DSCartData.h"

static NSString *const CartCell = @"CartCell";
@interface DSCartVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 编辑 */
@property(nonatomic,strong) UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIView *handleView;
/* 操作 */
@property (weak, nonatomic) IBOutlet UIButton *handleBtn;
/* 全选 */
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;
/* 总价 */
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
/* 件数 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNum;
/** 购物车数组 */
@property (nonatomic,strong) NSMutableArray *cartDataArr;
/* 是否是提交订单push */
@property(nonatomic,assign) BOOL isUpOrder;

@end

@implementation DSCartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HXGlobalBg;
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpRefresh];
    [self setUpEmptyView];
    [self startShimmer];
    [self getOrderCartListRequest];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self isViewLoaded]) {
        [self getOrderCartListRequest];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!self.isUpOrder) {
        [self editOrderCartRequest:^(BOOL isSuccess) {
            if (isSuccess) {
                HXLog(@"保存成功");
            }else{
                HXLog(@"保存失败");
            }
        }];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.isUpOrder = NO;
}
-(NSMutableArray *)cartDataArr
{
    if (_cartDataArr == nil) {
        _cartDataArr = [NSMutableArray array];
    }
    return _cartDataArr;
}
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"购物车"];
    
    UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
    edit.hxn_size = CGSizeMake(40, 44);
    edit.titleLabel.font = [UIFont systemFontOfSize:15];
    [edit setTitle:@"编辑" forState:UIControlStateNormal];
    [edit setTitle:@"完成" forState:UIControlStateSelected];
    [edit addTarget:self action:@selector(editClicked) forControlEvents:UIControlEventTouchUpInside];
    [edit setTitleColor:UIColorFromRGB(0XFFFFFF) forState:UIControlStateNormal];
    self.editBtn = edit;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:edit];
    
    [self.handleBtn.layer addSublayer:[UIColor setGradualChangingColor:self.handleBtn fromColor:@"F9AD28" toColor:@"F95628"]];
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.rowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = HXGlobalBg;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSCartCell class]) bundle:nil] forCellReuseIdentifier:CartCell];
}
-(void)setUpEmptyView
{
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"no_data" titleStr:nil detailStr:@"暂无内容"];
    emptyView.contentViewOffset = -(self.HXNavBarHeight);
    emptyView.subViewMargin = 20.f;
    emptyView.detailLabTextColor = UIColorFromRGB(0x131D2D);
    emptyView.detailLabFont = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
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
        [strongSelf getOrderCartListRequest];
    }];
}
#pragma mark -- 接口请求
-(void)getOrderCartListRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"cart_list_get" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [strongSelf.tableView.mj_header endRefreshing];
            
            [strongSelf.cartDataArr removeAllObjects];
            NSArray *arrt = [NSArray yy_modelArrayWithClass:[DSCartData class] json:responseObject[@"result"][@"list"]];
            [strongSelf.cartDataArr addObjectsFromArray:arrt];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 刷新界面
                hx_strongify(weakSelf);
                strongSelf.tableView.hidden = NO;
                strongSelf.editBtn.hidden = !strongSelf.cartDataArr.count;
                strongSelf.handleView.hidden = !strongSelf.cartDataArr.count;
                [strongSelf checkIsAllSelect];
                [strongSelf calculateGoodsPrice];
                [strongSelf.tableView reloadData];
                if (strongSelf.cartDataArr.count) {
                    [strongSelf.tableView ly_hideEmptyView];
                }else{
                    [strongSelf.tableView ly_showEmptyView];
                }
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [strongSelf.tableView.mj_header endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 点击事件
-(void)editClicked
{
    self.editBtn.selected = !self.editBtn.isSelected;
    if (self.editBtn.isSelected) {
        [self.handleBtn setTitle:@"删除" forState:UIControlStateNormal];
    }else{
        [self.handleBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    }
}
- (IBAction)selectAllClicked:(UIButton *)sender {
    sender.selected = !sender.selected;

    if (sender.isSelected) {
        [self.cartDataArr enumerateObjectsUsingBlock:^(DSCartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.is_checked = 1;
        }];
    }else{
        [self.cartDataArr enumerateObjectsUsingBlock:^(DSCartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.is_checked = 0;
        }];
    }
    [self calculateGoodsPrice];
    
    [self.tableView reloadData];
}
- (IBAction)upLoadOrderClicked:(UIButton *)sender {
    if (![self checkIsHaveSelect]) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择商品"];
        return;
    }
    if (self.editBtn.isSelected) {//删除
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要删除选中商品吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
        hx_weakify(self);
        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
        }];
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"删除" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
            [strongSelf delOrderCartRequest:nil compledCall:nil];
        }];
        cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
        [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
        self.zh_popupController = [[zhPopupController alloc] init];
        [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
    }else{
        self.isUpOrder = YES;
        hx_weakify(self);
        [self editOrderCartRequest:^(BOOL isSuccess) {
            hx_strongify(weakSelf);
            if (isSuccess) {
                DSUpOrderVC *ovc = [DSUpOrderVC new];
                ovc.isCartPush = YES;
                NSMutableString *goods_data = [NSMutableString string];
                [goods_data appendString:@"["];
                [strongSelf.cartDataArr enumerateObjectsUsingBlock:^(DSCartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.is_checked) {
                        if (goods_data.length > 1) {
                            [goods_data appendFormat:@",{\"goods_id\":\"%@\",\"sku_id\":\"%@\",\"num\":\"%@\",\"share_uid\":\"0\"}",obj.goods_id,obj.sku_id,obj.cart_num];
                        }else{
                            [goods_data appendFormat:@"{\"goods_id\":\"%@\",\"sku_id\":\"%@\",\"num\":\"%@\",\"share_uid\":\"0\"}",obj.goods_id,obj.sku_id,obj.cart_num];
                        }
                    }
                }];
                [goods_data appendString:@"]"];
                ovc.goods_data = goods_data;//商品信息
                ovc.upOrderSuccessCall = ^{
                    [strongSelf getOrderCartListRequest];
                };
                [strongSelf.navigationController pushViewController:ovc animated:YES];
            }
        }];
    }
}
#pragma mark -- 业务逻辑
/**
 判断是否全选
 */
-(void)checkIsAllSelect
{
    __block BOOL isAllSelect = YES;
    [self.cartDataArr enumerateObjectsUsingBlock:^(DSCartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.is_checked) {
            isAllSelect = NO;
            *stop = YES;
        }
    }];
    self.selectAllBtn.selected = isAllSelect;
}
/**
 检查是否有选中的商品
 
 @return Yes存在选中/No不存在选中
 */
-(BOOL)checkIsHaveSelect
{
    __block BOOL isHaveSelect = NO;
    [self.cartDataArr enumerateObjectsUsingBlock:^(DSCartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.is_checked) {
            isHaveSelect = YES;
            *stop = YES;
        }
    }];
    return isHaveSelect;
}
/**
 计算商品价格
 */
-(void)calculateGoodsPrice
{
    __block CGFloat price = 0;
    __block NSInteger num = 0;
    [self.cartDataArr enumerateObjectsUsingBlock:^(DSCartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.is_checked) {
            if ([obj.is_discount isEqualToString:@"1"]) {
                price += ([obj.discount_price floatValue])*[obj.cart_num integerValue];
            }else{
                price += ([obj.price floatValue])*[obj.cart_num integerValue];
            }
            num++;
        }
    }];
    [self.totalPrice setFontAttributedText:[NSString stringWithFormat:@"￥%.2f",fabs(price)] andChangeStr:@"￥" andFont:[UIFont systemFontOfSize:12]];
    self.goodsNum.text = [NSString stringWithFormat:@"共%zd件",num];
}
-(void)delOrderCartRequest:(NSString *)sku_id compledCall:(void(^)(void))compledCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    if (sku_id) {
        parameters[@"sku_ids"] = sku_id;//删除多个id间用逗号隔开
    }else{
        NSMutableString *sku_ids = [NSMutableString string];
        [self.cartDataArr enumerateObjectsUsingBlock:^(DSCartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.is_checked) {
                [sku_ids appendFormat:@"%@",sku_ids.length?[NSString stringWithFormat:@",%@",obj.sku_id]:[NSString stringWithFormat:@"%@",obj.sku_id]];
            }
        }];
        parameters[@"sku_ids"] = sku_ids;//删除多个id间用逗号隔开
    }
    

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"cart_delete_set" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"删除成功"];
            if (sku_id) {
                compledCall();
            }else{
                NSMutableArray *tempArr = [NSMutableArray arrayWithArray:strongSelf.cartDataArr];
                [tempArr enumerateObjectsUsingBlock:^(DSCartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.is_checked) {
                        [strongSelf.cartDataArr removeObject:obj];
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf checkIsAllSelect];
                    [strongSelf calculateGoodsPrice];
                    [strongSelf.tableView reloadData];
                    if (strongSelf.cartDataArr.count) {
                        [strongSelf.tableView ly_hideEmptyView];
                    }else{
                        [strongSelf.tableView ly_showEmptyView];
                    }
                });
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)editOrderCartRequest:(void(^)(BOOL isSuccess))completeCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableString *goods_data = [NSMutableString string];
    [goods_data appendString:@"["];
    [self.cartDataArr enumerateObjectsUsingBlock:^(DSCartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (goods_data.length == 1) {
            [goods_data appendFormat:@"{\"goods_id\":\"%@\",\"sku_id\":\"%@\",\"num\":\"%@\",\"is_checked\":\"%@\"}",obj.goods_id,obj.sku_id,obj.cart_num,@(obj.is_checked)];
        }else{
            [goods_data appendFormat:@",{\"goods_id\":\"%@\",\"sku_id\":\"%@\",\"num\":\"%@\",\"is_checked\":\"%@\"}",obj.goods_id,obj.sku_id,obj.cart_num,@(obj.is_checked)];
        }
    }];
    [goods_data appendString:@"]"];
    parameters[@"goods_data"] = goods_data;//cartData

    //hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"cart_asyn_set" parameters:parameters success:^(id responseObject) {
        //hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            completeCall(YES);
        }else{
            completeCall(NO);
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        //hx_strongify(weakSelf);
        completeCall(NO);
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cartDataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSCartCell *cell = [tableView dequeueReusableCellWithIdentifier:CartCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DSCartData *cart = self.cartDataArr[indexPath.row];
    //cell.flag.hidden = [cart.is_discount isEqualToString:@"1"]?NO:YES;
    cell.flag.hidden = YES;
    cell.cart = cart;
    hx_weakify(self);
    cell.cartHandleCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        if (index == 2) {
            [strongSelf checkIsAllSelect];
            [strongSelf calculateGoodsPrice];
        }else{
            [strongSelf calculateGoodsPrice];
        }
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 180.f+16.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    hx_weakify(self);
    DSCartData *cart = self.cartDataArr[indexPath.row];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删\n除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        hx_strongify(weakSelf);
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要删除选中商品吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
            [strongSelf.zh_popupController dismiss];
        }];
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"删除" handler:^(zhAlertButton * _Nonnull button) {
            [strongSelf.zh_popupController dismiss];
            [strongSelf delOrderCartRequest:cart.sku_id compledCall:^{
                [strongSelf.cartDataArr removeObject:cart];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf checkIsAllSelect];
                    [strongSelf calculateGoodsPrice];
                    [strongSelf.tableView reloadData];
                    if (strongSelf.cartDataArr.count) {
                        [strongSelf.tableView ly_hideEmptyView];
                    }else{
                        [strongSelf.tableView ly_showEmptyView];
                    }
                });
            }];
        }];
        cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
        [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
        strongSelf.zh_popupController = [[zhPopupController alloc] init];
        [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
    }];
    deleteAction.backgroundColor = HXControlBg;
    
    return @[deleteAction];
}
@end
