//
//  DSMySetVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMySetVC.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "DSChangePwdVC.h"
#import "DSChangeBindVC.h"
#import "DSLoginVC.h"
#import "HXNavigationController.h"
#import "DSMyAddressVC.h"
#import "DSWebContentVC.h"
#import <AlibabaAuthSDK/ALBBSDK.h>
#import <AlibabaAuthSDK/ALBBSession.h>

@interface DSMySetVC ()

@end

@implementation DSMySetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"设置"];
}
- (IBAction)setBtnClicked:(UIButton *)sender {
    if (sender.tag == 0) {
        DSChangeBindVC *pvc = [DSChangeBindVC new];
        [self.navigationController pushViewController:pvc animated:YES];
    }else if (sender.tag == 1) {
        DSChangePwdVC *pvc = [DSChangePwdVC new];
        pvc.dataType = 2;
        [self.navigationController pushViewController:pvc animated:YES];
    }else if (sender.tag == 2) {
        DSMyAddressVC *avc = [DSMyAddressVC new];
        [self.navigationController pushViewController:avc animated:YES];
    }else if (sender.tag == 3) {
        DSWebContentVC *wvc = [DSWebContentVC new];
        wvc.navTitle = @"用户协议";
        wvc.isNeedRequest = NO;
        wvc.url = @"http://apiadmin.whaleupgo.com/webapp/page/userAgreement.html";
        [self.navigationController pushViewController:wvc animated:YES];
    }else if (sender.tag == 4) {
        DSWebContentVC *wvc = [DSWebContentVC new];
        wvc.navTitle = @"隐私政策";
        wvc.requestType = 6;
        wvc.url = @"http://apiadmin.whaleupgo.com/webapp/page/privacyPolicy.html";
        [self.navigationController pushViewController:wvc animated:YES];
    }else if (sender.tag == 5) {
        HXLog(@"用户认证协议");
    }else if (sender.tag == 6) {
        HXLog(@"用户签约协议");
    }else{
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要退出登录？" constantWidth:HX_SCREEN_WIDTH - 50*2];
        hx_weakify(self);
        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
        }];
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"退出" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
            [strongSelf setLoginOutRequest];
        }];
        cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
        [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
        self.zh_popupController = [[zhPopupController alloc] init];
        [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
    }
}
-(void)setLoginOutRequest
{
    [HXNetworkTool POST:HXRC_M_URL action:@"login_out_set" parameters:@{} success:^(id responseObject) {
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [[MSUserManager sharedInstance] logout:nil];//清空登录数据
            [[ALBBSDK sharedInstance] logout];
            HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:[DSLoginVC new]];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            
            //推出主界面出来
            CATransition *ca = [CATransition animation];
            ca.type = @"movein";
            ca.duration = 0.5;
            [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
