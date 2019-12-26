//
//  DSLoginVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSLoginVC.h"
#import "DSChangePwdVC.h"
#import "DSRegisterVC.h"
#import "HXTabBarController.h"
#import "UITextField+GYExpand.h"

@interface DSLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *loginType;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
/* 验证码id */
@property(nonatomic,copy) NSString *codeId;
@end

@implementation DSLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"登录"];

    [self.registerBtn setAttributedTitle:[self setColorAttributedText:@"没有账号？立即注册" andChangeStr:@"没有账号？" andColor:[UIColor blackColor]] forState:UIControlStateNormal];
    hx_weakify(self);
    [self.phone lengthLimit:^{
        hx_strongify(weakSelf);
        if (strongSelf.phone.text.length > 11) {
            strongSelf.phone.text = [strongSelf.phone.text substringToIndex:11];
        }
    }];
    
    [self.loginBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.phone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入账号"];
            return NO;
        }
        if (strongSelf.phone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机号格式不对"];
            return NO;
        }
        if (strongSelf.loginType.isSelected) {
            if (!strongSelf.codeId) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请获取验证码"];
                return NO;
            }
            if (![strongSelf.code hasText]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入验证码"];
                return NO;
            }
        }else{
            if (![strongSelf.pwd hasText]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入密码"];
                return NO;
            }
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf loginClicked:button];
    }];
}
// 改变某些文字大小和颜色
-(NSMutableAttributedString *)setColorAttributedText:(NSString *)allStr andChangeStr:(NSString *)changeStr andColor:(UIColor *)color
{
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:allStr];
    NSRange range = [allStr rangeOfString:@"没有账号?"];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    NSRange range1 = [allStr rangeOfString:@"立即注册"];
    [attStr addAttribute:NSForegroundColorAttributeName value:HXControlBg range:range1];

    return attStr;
}
- (IBAction)registerClicked:(UIButton *)sender {
    DSRegisterVC *rvc = [DSRegisterVC new];
    [self.navigationController pushViewController:rvc animated:YES];
}
- (IBAction)pwdStatusClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.pwd.secureTextEntry = !sender.isSelected;
}
- (IBAction)loginTypeClicked:(UIButton *)sender {
    self.loginType.selected = !self.loginType.selected;
    if (self.loginType.isSelected) {
        self.codeView.hidden = NO;
        self.pwdView.hidden = YES;
    }else{
        self.codeView.hidden = YES;
        self.pwdView.hidden = NO;
    }
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
    parameters[@"type"] = @"5";//短信场景（1用户注册 2用户忘记密码, 3用户换绑原手机, 4用户换绑新手机号 5登录）
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"get_code" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"status"] integerValue] == 1) {
            strongSelf.codeId = NSStringFormat(@"%@",responseObject[@"result"]);
            [sender startWithTime:59 title:@"获取验证码" countDownTitle:@"s" mainColor:HXControlBg countColor:HXControlBg];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
- (void)loginClicked:(UIButton *)sender {

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.loginType.isSelected) {
        parameters[@"phone"] = self.phone.text;
        parameters[@"sms_id"] = self.codeId;
        parameters[@"sms_code"] = self.code.text;
        parameters[@"device_tokens"] = @"";//设备号，不允许推送时为空
    }else{
        parameters[@"phone"] = self.phone.text;
        parameters[@"pwd"] = self.pwd.text;
        parameters[@"device_tokens"] = @"";//设备号，不允许推送时为空
    }
    
    [HXNetworkTool POST:HXRC_M_URL action:self.loginType.isSelected?@"login_sms_set":@"login_set" parameters:parameters success:^(id responseObject) {
        [sender stopLoading:@"登录" image:nil textColor:nil backgroundColor:nil];
        if ([responseObject[@"status"] integerValue] == 1) {
            [MSUserManager sharedInstance].curUserInfo = [MSUserInfo yy_modelWithDictionary:responseObject[@"result"]];
            [[MSUserManager sharedInstance] saveUserInfo];
            
            HXTabBarController *tab = [[HXTabBarController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tab;
            
            //推出主界面出来
            CATransition *ca = [CATransition animation];
            ca.type = @"movein";
            ca.duration = 0.5;
            [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [sender stopLoading:@"登录" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
    
}
- (IBAction)forgetClicked:(UIButton *)sender {
    DSChangePwdVC *pvc = [DSChangePwdVC new];
    pvc.dataType = 1;
    [self.navigationController pushViewController:pvc animated:YES];
}


@end
