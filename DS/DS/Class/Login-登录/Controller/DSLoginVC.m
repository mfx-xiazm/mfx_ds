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

@interface DSLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIButton *loginType;

@end

@implementation DSLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"登录"];

//    hx_weakify(self);
//    [self.loginBtn BindingBtnJudgeBlock:^BOOL{
//        hx_strongify(weakSelf);
//        if (![strongSelf.phone hasText]) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入账号"];
//            return NO;
//        }
//        if (![strongSelf.pwd hasText]) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入密码"];
//            return NO;
//        }
//        return YES;
//    } ActionBlock:^(UIButton * _Nullable button) {
//        hx_strongify(weakSelf);
//        [strongSelf loginClicked:button];
//    }];
    
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

- (IBAction)loginClicked:(UIButton *)sender {
    
    HXTabBarController *tab = [[HXTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tab;
    
    //推出主界面出来
    CATransition *ca = [CATransition animation];
    ca.type = @"movein";
    ca.duration = 0.5;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
    
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"username"] = self.phone.text;
//    parameters[@"password"] = self.pwd.text;
//
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:@"userLogin" parameters:parameters success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        [sender stopLoading:@"登录" image:nil textColor:nil backgroundColor:nil];
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            MSUserInfo *info = [MSUserInfo yy_modelWithDictionary:responseObject[@"data"]];
//            [MSUserManager sharedInstance].curUserInfo = info;
//            [[MSUserManager sharedInstance] saveUserInfo];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                HXTabBarController *tabvc = (HXTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//                if (info.utype == 1) {
//                    if (tabvc.viewControllers.count == 4) {
//                        [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
//                    }else{
//                        HXTabBarController *tab = [[HXTabBarController alloc] init];
//                        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
//
//                        //推出主界面出来
//                        CATransition *ca = [CATransition animation];
//                        ca.type = @"movein";
//                        ca.duration = 0.5;
//                        [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
//                    }
//                }else if (info.utype == 2) {
//                    if (tabvc.viewControllers.count == 3) {
//                        [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
//                    }else{
//                        HXTabBarController *tab = [[HXTabBarController alloc] init];
//                        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
//
//                        //推出主界面出来
//                        CATransition *ca = [CATransition animation];
//                        ca.type = @"movein";
//                        ca.duration = 0.5;
//                        [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
//                    }
//                }else{
//                    if (tabvc.viewControllers.count == 2) {
//                        [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
//                    }else{
//                        HXTabBarController *tab = [[HXTabBarController alloc] init];
//                        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
//
//                        //推出主界面出来
//                        CATransition *ca = [CATransition animation];
//                        ca.type = @"movein";
//                        ca.duration = 0.5;
//                        [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
//                    }
//                }
//            });
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [sender stopLoading:@"登录" image:nil textColor:nil backgroundColor:nil];
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
    
}
- (IBAction)forgetClicked:(UIButton *)sender {
    DSChangePwdVC *pvc = [DSChangePwdVC new];
    pvc.dataType = 1;
    [self.navigationController pushViewController:pvc animated:YES];
}


@end
