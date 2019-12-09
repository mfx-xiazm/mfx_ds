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
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 购物车数组 */
@property (nonatomic,strong) NSMutableArray *cartDataArr;
/* 是否是提交订单push */
@property(nonatomic,assign) BOOL isUpOrder;

@end

@implementation DSCartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
//    [self setUpRefresh];
//    [self startShimmer];
//    [self getOrderCartListRequest:YES];
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
    UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
    edit.hxn_size = CGSizeMake(40, 44);
    edit.titleLabel.font = [UIFont systemFontOfSize:15];
    [edit setTitle:@"编辑" forState:UIControlStateNormal];
    [edit setTitle:@"完成" forState:UIControlStateSelected];
    [edit addTarget:self action:@selector(editClicked) forControlEvents:UIControlEventTouchUpInside];
    [edit setTitleColor:UIColorFromRGB(0XFFFFFF) forState:UIControlStateNormal];
    self.editBtn = edit;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:edit];
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
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSCartCell class]) bundle:nil] forCellReuseIdentifier:CartCell];
    
//    hx_weakify(self);
//    [self.tableView zx_setEmptyView:[GYEmptyView class] isFull:YES clickedBlock:^(UIButton * _Nullable btn) {
//        [weakSelf startShimmer];
//        [weakSelf getOrderCartListRequest:YES];
//    }];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getOrderCartListRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getOrderCartListRequest:NO];
    }];
}
#pragma mark -- 接口请求
-(void)getOrderCartListRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"getOrderCartData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            if (isRefresh) {
//                [strongSelf.tableView.mj_header endRefreshing];
//                strongSelf.pagenum = 1;
//
//                [strongSelf.cartDataArr removeAllObjects];
//                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GYCartData class] json:responseObject[@"data"]];
//                [strongSelf.cartDataArr addObjectsFromArray:arrt];
//            }else{
//                [strongSelf.tableView.mj_footer endRefreshing];
//                strongSelf.pagenum ++;
//
//                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
//                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GYCartData class] json:responseObject[@"data"]];
//                    [strongSelf.cartDataArr addObjectsFromArray:arrt];
//                }else{// 提示没有更多数据
//                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//                }
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // 刷新界面
//                hx_strongify(weakSelf);
//                strongSelf.tableView.hidden = NO;
//                strongSelf.editBtn.hidden = !strongSelf.cartDataArr.count;
//                strongSelf.handleView.hidden = !strongSelf.cartDataArr.count;
//                strongSelf.handleViewHeight.constant = strongSelf.cartDataArr.count?44.f:0.f;
//                [strongSelf checkIsAllSelect];
//                [strongSelf calculateGoodsPrice];
//                [strongSelf.tableView reloadData];
//            });
//        }else{
//            strongSelf.tableView.zx_emptyContentView.zx_type = GYUIApiErrorState;
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
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
//
//    if (sender.isSelected) {
//        [self.cartDataArr enumerateObjectsUsingBlock:^(GYCartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            obj.is_checked = 1;
//        }];
//    }else{
//        [self.cartDataArr enumerateObjectsUsingBlock:^(GYCartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            obj.is_checked = 0;
//        }];
//    }
    [self calculateGoodsPrice];
    
    [self.tableView reloadData];
}
- (IBAction)upLoadOrderClicked:(UIButton *)sender {
    DSUpOrderVC *ovc = [DSUpOrderVC new];
    [self.navigationController pushViewController:ovc animated:YES];
//    if (![self checkIsHaveSelect]) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择商品"];
//        return;
//    }
//    if (self.editBtn.isSelected) {//删除
//        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要删除选中商品吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
//        hx_weakify(self);
//        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
//            hx_strongify(weakSelf);
//            [strongSelf.zh_popupController dismiss];
//        }];
//        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"删除" handler:^(zhAlertButton * _Nonnull button) {
//            hx_strongify(weakSelf);
//            [strongSelf.zh_popupController dismiss];
//            [strongSelf delOrderCartRequest];
//        }];
//        cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
//        [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
//        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
//        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
//        [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
//        self.zh_popupController = [[zhPopupController alloc] init];
//        [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
//    }else{
//        self.isUpOrder = YES;
//        hx_weakify(self);
//        [self editOrderCartRequest:^(BOOL isSuccess) {
//            hx_strongify(weakSelf);
//            if (isSuccess) {
//                GYUpOrderVC *ovc = [GYUpOrderVC new];
//                NSMutableString *cart_id = [NSMutableString string];
//                [strongSelf.cartDataArr enumerateObjectsUsingBlock:^(GYCartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if (obj.is_checked) {
//                        [cart_id appendFormat:@"%@",cart_id.length?[NSString stringWithFormat:@",%@",obj.cart_id]:[NSString stringWithFormat:@"%@",obj.cart_id]];
//                    }
//                }];
//                ovc.isCartPush = YES;
//                ovc.cart_ids = cart_id;//cart_id
//                ovc.upOrderSuccessCall = ^{
//                    [strongSelf getOrderCartListRequest:YES];
//                };
//                [strongSelf.navigationController pushViewController:ovc animated:YES];
//            }
//        }];
//    }
}
#pragma mark -- 业务逻辑
/**
 判断是否全选
 */
-(void)checkIsAllSelect
{
//    __block BOOL isAllSelect = YES;
//    [self.cartDataArr enumerateObjectsUsingBlock:^(GYCartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (!obj.is_checked) {
//            isAllSelect = NO;
//            *stop = YES;
//        }
//    }];
//    self.selectAllBtn.selected = isAllSelect;
}
/**
 检查是否有选中的商品
 
 @return Yes存在选中/No不存在选中
 */
-(BOOL)checkIsHaveSelect
{
//    __block BOOL isHaveSelect = NO;
//    [self.cartDataArr enumerateObjectsUsingBlock:^(GYCartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.is_checked) {
//            isHaveSelect = YES;
//            *stop = YES;
//        }
//    }];
//    return isHaveSelect;
    return YES;
}
/**
 计算商品价格
 */
-(void)calculateGoodsPrice
{
//    __block CGFloat price = 0;
//    [self.cartDataArr enumerateObjectsUsingBlock:^(GYCartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.is_checked) {
//            price += ([obj.price floatValue] + [obj.freight floatValue])*[obj.cart_num integerValue];
//        }
//    }];
//    self.totalPrice.text = [NSString stringWithFormat:@"%.2f元",fabs(price)];
}
-(void)delOrderCartRequest
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//
//    NSMutableString *cart_id = [NSMutableString string];
//    [self.cartDataArr enumerateObjectsUsingBlock:^(GYCartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.is_checked) {
//            [cart_id appendFormat:@"%@",cart_id.length?[NSString stringWithFormat:@",%@",obj.cart_id]:[NSString stringWithFormat:@"%@",obj.cart_id]];
//        }
//    }];
//    parameters[@"cartIds"] = cart_id;//删除多个id间用逗号隔开
//
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:@"delOrderCart" parameters:parameters success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//
//            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:strongSelf.cartDataArr];
//            [tempArr enumerateObjectsUsingBlock:^(GYCartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if (obj.is_checked) {
//                    [strongSelf.cartDataArr removeObject:obj];
//                }
//            }];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [strongSelf checkIsAllSelect];
//                [strongSelf calculateGoodsPrice];
//                [strongSelf.tableView reloadData];
//            });
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
}
-(void)editOrderCartRequest:(void(^)(BOOL isSuccess))completeCall
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    NSMutableString *cartData = [NSMutableString string];
//    [cartData appendString:@"["];
//    [self.cartDataArr enumerateObjectsUsingBlock:^(GYCartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (cartData.length == 1) {
//            [cartData appendFormat:@"{\"cart_id\":\"%@\",\"cart_num\":\"%@\",\"is_checked\":\"%@\"}",obj.cart_id,obj.cart_num,@(obj.is_checked)];
//        }else{
//            [cartData appendFormat:@",{\"cart_id\":\"%@\",\"cart_num\":\"%@\",\"is_checked\":\"%@\"}",obj.cart_id,obj.cart_num,@(obj.is_checked)];
//        }
//    }];
//    [cartData appendString:@"]"];
//    parameters[@"cartData"] = cartData;//cartData
//
//    //hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:@"editOrderCart" parameters:parameters success:^(id responseObject) {
//        //hx_strongify(weakSelf);
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            completeCall(YES);
//        }else{
//            completeCall(NO);
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        //hx_strongify(weakSelf);
//        completeCall(NO);
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.cartDataArr.count;
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSCartCell *cell = [tableView dequeueReusableCellWithIdentifier:CartCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    GYCartData *cart = self.cartDataArr[indexPath.row];
//    cell.cart = cart;
//    hx_weakify(self);
//    cell.cartHandleCall = ^(NSInteger index) {
//        hx_strongify(weakSelf);
//        if (index == 2) {
//            [strongSelf checkIsAllSelect];
//            [strongSelf calculateGoodsPrice];
//        }else{
//            [strongSelf calculateGoodsPrice];
//        }
//    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 115.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
