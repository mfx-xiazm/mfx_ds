//
//  DSChangeBindVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSChangeBindVC.h"
#import "UITextField+GYExpand.h"

@interface DSChangeBindVC ()
@property (weak, nonatomic) IBOutlet UITextField *oldPhone;
@property (weak, nonatomic) IBOutlet UITextField *oldCode;
@property (weak, nonatomic) IBOutlet UITextField *nowPhone;
@property (weak, nonatomic) IBOutlet UITextField *nowCode;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property(nonatomic,copy) NSString *oldCodeId;
@property(nonatomic,copy) NSString *nowCodeId;
@end

@implementation DSChangeBindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"更换绑定手机号"];
    
    self.oldPhone.text = [MSUserManager sharedInstance].curUserInfo.phone;
    
    hx_weakify(self);
    [self.oldPhone lengthLimit:^{
        hx_strongify(weakSelf);
        if (strongSelf.oldPhone.text.length > 11) {
            strongSelf.oldPhone.text = [strongSelf.oldPhone.text substringToIndex:11];
        }
    }];
    [self.nowPhone lengthLimit:^{
        hx_strongify(weakSelf);
        if (strongSelf.nowPhone.text.length > 11) {
            strongSelf.nowPhone.text = [strongSelf.nowPhone.text substringToIndex:11];
        }
    }];
    
    [self.sureBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.oldPhone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入旧手机号"];
            return NO;
        }
        if (strongSelf.oldPhone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"旧手机号格式不对"];
            return NO;
        }
        if (!strongSelf.oldCodeId) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请获取旧手机验证码"];
            return NO;
        }
        if (![strongSelf.oldCode hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入旧手机验证码"];
            return NO;
        }
        if (![strongSelf.nowPhone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入新手机号"];
            return NO;
        }
        if (strongSelf.nowPhone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"新手机号格式不对"];
            return NO;
        }
        if (!strongSelf.nowCodeId) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请获取新手机验证码"];
            return NO;
        }
        if (![strongSelf.nowCode hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入新手机验证码"];
            return NO;
        }
        
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf setChangePhoneRequest:button];
    }];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIView *view = [[UIView alloc] initWithFrame:self.sureBtn.bounds];
    [view.layer addSublayer:[UIColor setGradualChangingColor:self.sureBtn fromColor:@"F9AD28" toColor:@"F95628"]];
    [self.sureBtn setBackgroundImage:[view imageWithUIView] forState:UIControlStateNormal];
}
- (IBAction)getCodeRequest:(UIButton *)sender {
    if (sender.tag == 1) {
        if (![self.oldPhone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入旧手机号"];
            return;
        }
        if (self.oldPhone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"旧手机号格式不对"];
            return;
        }
    }else{
        if (![self.nowPhone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入新手机号"];
            return;
        }
        if (self.nowPhone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"新手机号格式不对"];
            return;
        }
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"phone"] = (sender.tag == 1)?self.oldPhone.text:self.nowPhone.text;
    parameters[@"type"] = (sender.tag == 1)?@"3":@"4";//短信场景（1用户注册 2用户忘记密码, 3用户换绑原手机, 4用户换绑新手机号 5登录）
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"get_code" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"status"] integerValue] == 1) {
            if (sender.tag == 1) {
                strongSelf.oldCodeId = NSStringFormat(@"%@",responseObject[@"result"]);
            }else{
                strongSelf.nowCodeId = NSStringFormat(@"%@",responseObject[@"result"]);
            }
            [sender startWithTime:59 title:@"再次发送" countDownTitle:@"s" mainColor:nil countColor:nil];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}

-(void)setChangePhoneRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"old_phone"] = self.oldPhone.text;//
    parameters[@"old_sms_id"] = self.oldCodeId;//
    parameters[@"old_sms_code"] = self.oldCode.text;//
    parameters[@"new_phone"] = self.nowPhone.text;//
    parameters[@"new_sms_id"] = self.nowCodeId;//
    parameters[@"new_sms_code"] = self.nowCode.text;//
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"change_phone_set" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"确定修改" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"修改成功"];
            [MSUserManager sharedInstance].curUserInfo.phone = strongSelf.nowPhone.text;
            [[MSUserManager sharedInstance] saveUserInfo];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"确定修改" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
