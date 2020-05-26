//
//  DSRegisterVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSRegisterVC.h"
#import "UITextField+GYExpand.h"
#import "HXTabBarController.h"
#import "DSWebContentVC.h"

@interface DSRegisterVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *comfirmPwd;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *inviteCode;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextView *agreeMentTV;
/* 验证码id */
@property(nonatomic,copy) NSString *codeId;
@end

@implementation DSRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"注册"];
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_barTintColor = HXGlobalBg;
    self.hbd_tintColor = [UIColor blackColor];
    self.hbd_barShadowHidden = YES;
    self.hbd_titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName: [UIColor.blackColor colorWithAlphaComponent:1.0]};
    [self setAgreeMentProtocol];

    [self.registerBtn.layer addSublayer:[UIColor setGradualChangingColor:self.registerBtn fromColor:@"F9AD28" toColor:@"F95628"]];

    hx_weakify(self);
    [self.phone lengthLimit:^{
        hx_strongify(weakSelf);
        if (strongSelf.phone.text.length > 11) {
            strongSelf.phone.text = [strongSelf.phone.text substringToIndex:11];
        }
    }];
    [self.registerBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.phone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入手机号"];
            return NO;
        }
        if (strongSelf.phone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机号格式不对"];
            return NO;
        }
        if (![strongSelf.pwd hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入您的密码"];
            return NO;
        }
        if (![strongSelf.comfirmPwd hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请重新输入您的密码"];
            return NO;
        }
        if (![strongSelf.pwd.text isEqualToString:strongSelf.comfirmPwd.text]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"您的密码前后不一致"];
            return NO;
        }
        if (![strongSelf.inviteCode hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入邀请码"];
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
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf regidterUserRequest:button];
    }];
}
-(void)setAgreeMentProtocol
{
    NSString *agreeStr = @"已阅读并同意以下协议:《用户协议》《隐私协议》";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:agreeStr];
    [attributedString addAttribute:NSLinkAttributeName value:@"yhxy://" range:[[attributedString string] rangeOfString:@"《用户协议》"]];
    [attributedString addAttribute:NSLinkAttributeName value:@"ysxy://" range:[[attributedString string] rangeOfString:@"《隐私协议》"]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x999999) range:NSMakeRange(0, agreeStr.length)];
    
    _agreeMentTV.attributedText = attributedString;
    _agreeMentTV.linkTextAttributes = @{NSForegroundColorAttributeName: UIColorFromRGB(0x527CF8),NSUnderlineColorAttributeName: UIColorFromRGB(0x527CF8),NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    _agreeMentTV.delegate = self;
    _agreeMentTV.editable = NO;        //必须禁止输入，否则点击将弹出输入键盘
    _agreeMentTV.scrollEnabled = NO;
}
- (IBAction)pwdStatusClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.tag == 1) {
        self.comfirmPwd.secureTextEntry = !sender.isSelected;
    }else{
        self.pwd.secureTextEntry = !sender.isSelected;
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
    parameters[@"type"] = @"1";//短信场景（1用户注册 2用户忘记密码, 3用户换绑原手机, 4用户换绑新手机号 5登录）
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"get_code" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"status"] integerValue] == 1) {
            strongSelf.codeId = NSStringFormat(@"%@",responseObject[@"result"]);
            [sender startWithTime:59 title:@"再次发送" countDownTitle:@"s" mainColor:nil countColor:nil];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}

-(void)regidterUserRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"phone"] = self.phone.text;
    parameters[@"pwd"] = self.pwd.text;
    parameters[@"sms_id"] = self.codeId;
    parameters[@"sms_code"] = self.code.text;
    parameters[@"share_code"] = [self.inviteCode hasText]?self.inviteCode.text:@"";
    parameters[@"device_tokens"] = @"";//设备号，不允许推送时为空
    
    [HXNetworkTool POST:HXRC_M_URL action:@"register_set" parameters:parameters success:^(id responseObject) {
        [btn stopLoading:@"注册" image:nil textColor:nil backgroundColor:nil];
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
        [btn stopLoading:@"注册" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
// 改变某些文字大小和颜色
-(NSMutableAttributedString *)setColorAttributedText:(NSString *)allStr andChangeStr:(NSString *)changeStr andColor:(UIColor *)color
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:allStr];
    NSRange range = [allStr rangeOfString:@"已有账号?"];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    NSRange range1 = [allStr rangeOfString:@"立即登录"];
    [attStr addAttribute:NSForegroundColorAttributeName value:HXControlBg range:range1];

    return attStr;
}

#pragma mark -- UITextView代理
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"yhxy"]) {
        DSWebContentVC *wvc = [DSWebContentVC new];
        wvc.navTitle = @"用户协议";
        wvc.isNeedRequest = NO;
        wvc.url = @"http://apiadmin.whaleupgo.com/webapp/page/userAgreement.html";
        [self.navigationController pushViewController:wvc animated:YES];
        return NO;
    }else if ([[URL scheme] isEqualToString:@"ysxy"]) {
        DSWebContentVC *wvc = [DSWebContentVC new];
        wvc.navTitle = @"隐私政策";
        wvc.requestType = 6;
        wvc.url = @"http://apiadmin.whaleupgo.com/webapp/page/privacyPolicy.html";
        [self.navigationController pushViewController:wvc animated:YES];
        return NO;
    }
    return YES;
}
@end
