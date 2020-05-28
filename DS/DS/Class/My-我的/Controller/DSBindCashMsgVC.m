//
//  DSBindCashMsgVC.m
//  DS
//
//  Created by huaxin-01 on 2020/5/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSBindCashMsgVC.h"

@interface DSBindCashMsgVC ()
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *account_type;
@property (weak, nonatomic) IBOutlet UITextField *realName;
@property (weak, nonatomic) IBOutlet UITextField *account_no;

@end

@implementation DSBindCashMsgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    self.realName.text = self.realNameTxt;
    self.account_type.text = self.dataType==1?@"代发账号":@"支付宝账号";
    self.account_no.placeholder = self.dataType==1?[NSString stringWithFormat:@"请输入%@的银行卡号",self.realNameTxt]:@"请输入支付宝账号";
    [self.sureBtn.layer addSublayer:[UIColor setGradualChangingColor:self.sureBtn fromColor:@"F9AD28" toColor:@"F95628"]];
}
#pragma mark -- 视图
-(void)setUpNavBar
{
    [self.navigationItem setTitle:self.dataType==1?@"绑定银行卡":@"绑定支付宝账号"];
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_barTintColor = HXGlobalBg;
    self.hbd_tintColor = [UIColor blackColor];
    self.hbd_barShadowHidden = YES;
    self.hbd_titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName: [UIColor.blackColor colorWithAlphaComponent:1.0]};
}
#pragma mark -- 接口
-(IBAction)bindAccountRequest:(UIButton *)btn
{
    if (self.dataType == 1) {// 银行卡
        if (![self.account_no hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:self.account_no.placeholder];
            return;
        }
    }else{// 支付宝
        if (![self.account_no hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:self.account_no.placeholder];
            return;
        }
    }
    if (self.bindSuccessCall) {
        self.bindSuccessCall(self.account_no.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
