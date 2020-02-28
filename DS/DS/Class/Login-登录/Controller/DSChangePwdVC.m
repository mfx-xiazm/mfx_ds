//
//  DSChangePwdVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSChangePwdVC.h"
#import "UITextField+GYExpand.h"

@interface DSChangePwdVC ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwd;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
/* 验证码id */
@property(nonatomic,copy) NSString *codeId;
@end

@implementation DSChangePwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:(self.dataType==1)?@"忘记密码":@"修改密码"];
    if (self.dataType == 2) {
        self.phone.text = [MSUserManager sharedInstance].curUserInfo.phone;
        self.phone.enabled = NO;
    }
    hx_weakify(self);
    [self.phone lengthLimit:^{
        hx_strongify(weakSelf);
        if (strongSelf.phone.text.length > 11) {
            strongSelf.phone.text = [strongSelf.phone.text substringToIndex:11];
        }
    }];
    [self.sureBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.phone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入手机号"];
            return NO;
        }
        if (strongSelf.phone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机号格式不对"];
            return NO;
        }
        if (!strongSelf.codeId) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请获取验证码"];
            return NO;
        }
        if (![strongSelf.code hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入验证码"];
            return NO;
        }
        if (![strongSelf.pwd hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请设置密码"];
            return NO;
        }
        if (![strongSelf.confirmPwd hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请确认密码"];
            return NO;
        }
        if (![strongSelf.pwd.text isEqualToString:strongSelf.confirmPwd.text]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"密码前后不一致"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf changePwdSetRequest:button];
    }];
}
- (IBAction)getCodeRequest:(UIButton *)sender {
    if (![self.phone hasText]) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入手机号"];
        return;
    }
    if (self.phone.text.length != 11) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机号格式不对"];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"phone"] = self.phone.text;
    parameters[@"type"] = @"2";//短信场景（1用户注册 2用户忘记密码, 3用户换绑原手机, 4用户换绑新手机号 5登录）
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"get_code" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"status"] integerValue] == 1) {
            strongSelf.codeId = NSStringFormat(@"%@",responseObject[@"result"]);
            [sender startWithTime:59 title:@"再次发送" countDownTitle:@"s" mainColor:HXControlBg countColor:HXControlBg];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}

-(void)changePwdSetRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"phone"] = self.phone.text;
    parameters[@"pwd"] = self.pwd.text;
    parameters[@"sms_id"] = self.codeId;
    parameters[@"sms_code"] = self.code.text;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"change_pwd_set" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
        if ([responseObject[@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}


@end
