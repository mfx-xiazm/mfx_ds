//
//  DSOrderDetailVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSOrderDetailVC.h"
#import "DSOrderDetailHeader.h"
#import "DSMyOrderCell.h"
#import "DSOrderDetailFooter.h"
#import "DSRefundDetailFooter.h"
#import "DSExpressDetailVC.h"
#import "DSApplyRefundVC.h"

static NSString *const MyOrderCell = @"MyOrderCell";
@interface DSOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) DSOrderDetailHeader *header;
/* 退款状态尾部视图 */
@property(nonatomic,strong) DSRefundDetailFooter *footer;
/* 订单操作视图 */
@property (weak, nonatomic) IBOutlet UIView *handleView;
/* 订单操作视图高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *handleViewHeight;
/* 订单操作第一个按钮 */
@property (weak, nonatomic) IBOutlet UIButton *firstHandleBtn;
/* 订单操作第二个按钮 */
@property (weak, nonatomic) IBOutlet UIButton *secondHandleBtn;
/* 订单操作第三个按钮 */
@property (weak, nonatomic) IBOutlet UIButton *thirdHandleBtn;

@end

@implementation DSOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"订单详情"];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 225);
    self.footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 110);
}

-(DSOrderDetailHeader *)header
{
    if (_header == nil) {
        _header = [DSOrderDetailHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 225);
    }
    return _header;
}
-(DSRefundDetailFooter *)footer
{
    if (_footer == nil) {
        _footer = [DSRefundDetailFooter loadXibView];
        _footer.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 110);
    }
    return _footer;
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
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSMyOrderCell class]) bundle:nil] forCellReuseIdentifier:MyOrderCell];
    
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
}
#pragma mark -- 接口请求
-(void)getOrderInfoRequest
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    if (self.refund_id && self.refund_id.length) {
//        parameters[@"refund_id"] = self.refund_id;
//    }else{
//        parameters[@"oid"] = self.oid;
//    }
//    NSString *action = nil;
//    if ([[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"1"]) {//母婴店
//        action = (self.refund_id && self.refund_id.length)?@"admin/orderRefundInfo":@"admin/getOrderInfo";
//    }else if ([[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"2"]) {//供应商
//        action = (self.refund_id && self.refund_id.length)?@"index/orderRefundInfo":@"index/getOrderInfo";
//    }else{
//        action = @"program/getOrderInfo";
//    }
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:action parameters:parameters success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        [strongSelf stopShimmer];
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            if (strongSelf.refund_id && strongSelf.refund_id.length) {
//                strongSelf.refundDetail = [GXMyRefund yy_modelWithDictionary:responseObject[@"data"]];
//            }else{
//                strongSelf.orderDetail = [GXMyOrder yy_modelWithDictionary:responseObject[@"data"]];
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [strongSelf handleOrderDetailData];
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
-(void)handleOrderDetailData
{
//    self.tableView.hidden = NO;
//
//    if ([[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"1"]) {//母婴店
//        if (self.refund_id && self.refund_id.length) {
//            if ([self.refundDetail.refund_status isEqualToString:@"4"] || [self.refundDetail.refund_status isEqualToString:@"6"]) {
//                self.handleView.hidden = NO;
//                self.handleViewHeight.constant = 50.f;
//
//                self.firstHandleBtn.hidden = YES;
//                self.secondHandleBtn.hidden = YES;
//
//                self.thirdHandleBtn.hidden = NO;
//                [self.thirdHandleBtn setTitle:@"查看原因" forState:UIControlStateNormal];
//                self.thirdHandleBtn.backgroundColor = [UIColor whiteColor];
//                self.thirdHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
//                [self.thirdHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            }else{
//                self.handleView.hidden = YES;
//                self.handleViewHeight.constant = 0.f;
//                self.firstHandleBtn.hidden = YES;
//                self.secondHandleBtn.hidden = YES;
//                self.thirdHandleBtn.hidden = YES;
//            }
//
//            self.header.refundDetail = self.refundDetail;
//            hx_weakify(self);
//            self.header.lookLogisCall = ^{
//                hx_strongify(weakSelf);
//                //HXLog(@"查看物流");
//                GXWebContentVC *cvc = [GXWebContentVC new];
//                cvc.navTitle = @"物流详情";
//                cvc.isNeedRequest = NO;
//                cvc.url = strongSelf.refundDetail.url;
//                [strongSelf.navigationController pushViewController:cvc animated:YES];
//            };
//
//            self.footer.refundDetail = self.refundDetail;// 退款地址
//            self.tableView.tableFooterView = self.footer;
//
//        }else{
//            if ([self.orderDetail.status isEqualToString:@"待付款"]) {
//                self.handleView.hidden = NO;
//                self.handleViewHeight.constant = 50.f;
//
//                self.firstHandleBtn.hidden = YES;
//
//                self.secondHandleBtn.hidden = NO;
//                [self.secondHandleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
//                self.secondHandleBtn.backgroundColor = [UIColor whiteColor];
//                self.secondHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
//                [self.secondHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
//                self.thirdHandleBtn.hidden = NO;
//                [self.thirdHandleBtn setTitle:@"立即支付" forState:UIControlStateNormal];
//                self.thirdHandleBtn.backgroundColor = HXControlBg;
//                self.thirdHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
//                [self.thirdHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//            }else if ([self.orderDetail.status isEqualToString:@"待发货"]) {
//                if ([self.orderDetail.pay_type isEqualToString:@"3"]) {// 线下付款
//                    if ([self.orderDetail.approve_status isEqualToString:@"2"]) {//订单审核通过
//                        self.handleView.hidden = NO;
//                        self.handleViewHeight.constant = 50.f;
//
//                        self.firstHandleBtn.hidden = YES;
//                        self.secondHandleBtn.hidden = YES;
//
//                        self.thirdHandleBtn.hidden = NO;
//                        [self.thirdHandleBtn setTitle:@"申请退款" forState:UIControlStateNormal];
//                        self.thirdHandleBtn.backgroundColor = [UIColor whiteColor];
//                        self.thirdHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
//                        [self.thirdHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                    }else{
//                        self.handleView.hidden = YES;
//                        self.handleViewHeight.constant = 0.f;
//
//                        self.firstHandleBtn.hidden = YES;
//                        self.secondHandleBtn.hidden = YES;
//                        self.thirdHandleBtn.hidden = YES;
//                    }
//                }else{
//                    self.handleView.hidden = NO;
//                    self.handleViewHeight.constant = 50.f;
//
//                    self.firstHandleBtn.hidden = YES;
//                    self.secondHandleBtn.hidden = YES;
//
//                    self.thirdHandleBtn.hidden = NO;
//                    [self.thirdHandleBtn setTitle:@"申请退款" forState:UIControlStateNormal];
//                    self.thirdHandleBtn.backgroundColor = [UIColor whiteColor];
//                    self.thirdHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
//                    [self.thirdHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                }
//            }else if ([self.orderDetail.status isEqualToString:@"待收货"]) {
//                self.handleView.hidden = NO;
//                self.handleViewHeight.constant = 50.f;
//
//                self.firstHandleBtn.hidden = NO;
//                [self.firstHandleBtn setTitle:@"申请退款" forState:UIControlStateNormal];
//                self.firstHandleBtn.backgroundColor = [UIColor whiteColor];
//                self.firstHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
//                [self.firstHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
//                self.secondHandleBtn.hidden = NO;
//                [self.secondHandleBtn setTitle:@"查看物流" forState:UIControlStateNormal];
//                self.secondHandleBtn.backgroundColor = [UIColor whiteColor];
//                self.secondHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
//                [self.secondHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
//                self.thirdHandleBtn.hidden = NO;
//                [self.thirdHandleBtn setTitle:@"确认收货" forState:UIControlStateNormal];
//                self.thirdHandleBtn.backgroundColor = HXControlBg;
//                self.thirdHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
//                [self.thirdHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            }else if ([self.orderDetail.status isEqualToString:@"待评价"]) {
//                self.handleView.hidden = NO;
//                self.handleViewHeight.constant = 50.f;
//
//                self.firstHandleBtn.hidden = YES;
//                self.secondHandleBtn.hidden = YES;
//
//                self.thirdHandleBtn.hidden = NO;
//                [self.thirdHandleBtn setTitle:@"评价" forState:UIControlStateNormal];
//                self.thirdHandleBtn.backgroundColor = HXControlBg;
//                self.thirdHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
//                [self.thirdHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//            }else{
//                self.handleView.hidden = YES;
//                self.handleViewHeight.constant = 0.f;
//
//                self.firstHandleBtn.hidden = YES;
//                self.secondHandleBtn.hidden = YES;
//                self.thirdHandleBtn.hidden = YES;
//            }
//
//            self.header.orderDetail = self.orderDetail;
//            hx_weakify(self);
//            self.header.lookLogisCall = ^{
//                hx_strongify(weakSelf);
//                //HXLog(@"查看物流");
//                GXWebContentVC *cvc = [GXWebContentVC new];
//                cvc.navTitle = @"物流详情";
//                cvc.isNeedRequest = NO;
//                cvc.url = strongSelf.orderDetail.url;
//                [strongSelf.navigationController pushViewController:cvc animated:YES];
//            };
//        }
//    }else {//供应商或者销售员
//        self.handleView.hidden = YES;
//        self.handleViewHeight.constant = 0.f;
//        self.firstHandleBtn.hidden = YES;
//        self.secondHandleBtn.hidden = YES;
//        self.thirdHandleBtn.hidden = YES;
//
//        if (self.refund_id && self.refund_id.length) {
//
//            self.header.refundDetail = self.refundDetail;
//            hx_weakify(self);
//            self.header.lookLogisCall = ^{
//                hx_strongify(weakSelf);
//                //HXLog(@"查看物流");
//                GXWebContentVC *cvc = [GXWebContentVC new];
//                cvc.navTitle = @"物流详情";
//                cvc.isNeedRequest = NO;
//                cvc.url = strongSelf.refundDetail.url;
//                [strongSelf.navigationController pushViewController:cvc animated:YES];
//            };
//            self.footer.refundDetail = self.refundDetail;// 退款地址
//            self.tableView.tableFooterView = self.footer;
//
//        }else{
//            self.header.orderDetail = self.orderDetail;
//            hx_weakify(self);
//            self.header.lookLogisCall = ^{
//                hx_strongify(weakSelf);
//                //HXLog(@"查看物流");
//                GXWebContentVC *cvc = [GXWebContentVC new];
//                cvc.navTitle = @"物流详情";
//                cvc.isNeedRequest = NO;
//                cvc.url = strongSelf.orderDetail.url;
//                [strongSelf.navigationController pushViewController:cvc animated:YES];
//            };
//        }
//    }
//
//    [self.tableView reloadData];
}
#pragma mark -- 业务逻辑
/** 取消订单 */
-(void)cancelOrderRequest
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"oid"] = self.oid;
//
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:@"admin/cancelOrder" parameters:parameters success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            if (strongSelf.orderHandleCall) {
//                strongSelf.orderHandleCall(0);
//            }
//            [strongSelf getOrderInfoRequest];
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
}
/** 申请退款 */
-(void)orderRefundRequest
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"oid"] = self.oid;
//
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:@"admin/orderRefund" parameters:parameters success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            strongSelf.refund_id = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
//            if (strongSelf.orderHandleCall) {
//                strongSelf.orderHandleCall(2);
//            }
//            [strongSelf getOrderInfoRequest];
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
}
/** 确认收货 */
-(void)confirmReceiveGoodRequest
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"oid"] = self.oid;
//
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:@"admin/confirmReceiveGood" parameters:parameters success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//           if (strongSelf.orderHandleCall) {
//                strongSelf.orderHandleCall(3);
//            }
//            [strongSelf getOrderInfoRequest];
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
}
#pragma mark -- 点击事件
- (IBAction)orderHandleBtnClicked:(UIButton *)sender {
    /** 待付款 - 取消订单、立即付款  待发货 - 申请退款[线下审核未通过 - 无]  待收货 - 申请退款、查看物流、确认收货  待评价 - 评价  已完成/退款列表 - 无 */
//    if (self.refund_id && self.refund_id.length) {
//        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"原因" message:self.refundDetail.reject_reason constantWidth:HX_SCREEN_WIDTH - 50*2];
//        hx_weakify(self);
//        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"我知道了" handler:^(zhAlertButton * _Nonnull button) {
//            hx_strongify(weakSelf);
//            [strongSelf.zh_popupController dismiss];
//        }];
//        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
//        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
//        [alert addAction:okButton];
//        self.zh_popupController = [[zhPopupController alloc] init];
//        [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
//    }else{
//        if (sender.tag == 1) {
//            if ([self.orderDetail.status isEqualToString:@"待收货"]) {
//                //HXLog(@"申请退款");
//                [self orderRefundRequest];
//            }
//        }else if (sender.tag == 2){
//            if ([self.orderDetail.status isEqualToString:@"待付款"]) {
//                //HXLog(@"取消订单");
//                [self cancelOrderRequest];
//            }else if ([self.orderDetail.status isEqualToString:@"待收货"]) {
//                //HXLog(@"查看物流");
//                GXWebContentVC *cvc = [GXWebContentVC new];
//                cvc.navTitle = @"物流详情";
//                cvc.isNeedRequest = NO;
//                cvc.url = self.orderDetail.url;
//                [self.navigationController pushViewController:cvc animated:YES];
//            }
//        }else{
//            if ([self.orderDetail.status isEqualToString:@"待付款"]) {
//                //HXLog(@"立即付款");
//                GXPayTypeVC *pvc = [GXPayTypeVC new];
//                pvc.oid = self.orderDetail.oid;
//                pvc.order_no = self.orderDetail.order_no;
//                pvc.isOrderPush = YES;
//                [self.navigationController pushViewController:pvc animated:YES];
//            }else if ([self.orderDetail.status isEqualToString:@"待发货"]) {
//                //HXLog(@"申请退款");
//                [self orderRefundRequest];
//            }else if ([self.orderDetail.status isEqualToString:@"待收货"]) {
//                //HXLog(@"确认收货");
//                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要确认收货吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
//                hx_weakify(self);
//                zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
//                    hx_strongify(weakSelf);
//                    [strongSelf.zh_popupController dismiss];
//                }];
//                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确认" handler:^(zhAlertButton * _Nonnull button) {
//                    hx_strongify(weakSelf);
//                    [strongSelf.zh_popupController dismiss];
//                    [strongSelf confirmReceiveGoodRequest];
//                }];
//                cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
//                [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
//                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
//                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
//                [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
//                self.zh_popupController = [[zhPopupController alloc] init];
//                [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
//            }else if ([self.orderDetail.status isEqualToString:@"待评价"]) {
//                //HXLog(@"评价");
//                GXEvaluateVC *evc = [GXEvaluateVC new];
//                evc.oid = self.oid;
//                hx_weakify(self);
//                evc.evaluatSuccessCall = ^{
//                    hx_strongify(weakSelf);
//                    [strongSelf getOrderInfoRequest];
//                    if (strongSelf.orderHandleCall) {
//                        strongSelf.orderHandleCall(4);
//                    }
//                };
//                [self.navigationController pushViewController:evc animated:YES];
//            }
//        }
//    }
    
    if (sender.tag == 1) {
        DSExpressDetailVC *dvc = [DSExpressDetailVC new];
        [self.navigationController pushViewController:dvc animated:YES];
    }else if (sender.tag == 2) {
        DSApplyRefundVC *rvc = [DSApplyRefundVC new];
        [self.navigationController pushViewController:rvc animated:YES];
    }
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (self.refund_id && self.refund_id.length) {
//        GYMyRefundGoods *refundGoods = self.refundDetail.goods[indexPath.row];
//        cell.refundGoods = refundGoods;
//    }else{
//        GXMyOrderGoods *goods = self.orderDetail.goods[indexPath.row];
//        cell.goods = goods;
//    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 120.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [UIView new];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 10.f);
    header.backgroundColor = HXGlobalBg;
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 270.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    DSOrderDetailFooter *footer = [DSOrderDetailFooter loadXibView];
    footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 270.f);
//    if (self.refund_id && self.refund_id.length) {
//        footer.refundDetail = self.refundDetail;
//    }else{
//        footer.orderDetail = self.orderDetail;
//    }
    return footer;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
//    if (self.refund_id && self.refund_id.length) {
//        GYMyRefundGoods *refundGoods = self.refundDetail.goods[indexPath.row];
//        dvc.goods_id = refundGoods.goods_id;
//    }else{
//        GXMyOrderGoods *goods = self.orderDetail.goods[indexPath.row];
//        dvc.goods_id = goods.goods_id;
//    }
//    [self.navigationController pushViewController:dvc animated:YES];
}

@end
