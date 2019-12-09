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

@interface DSMySetVC ()

@end

@implementation DSMySetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"设置"];
}
- (IBAction)setBtnClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        DSChangeBindVC *bvc = [DSChangeBindVC new];
//        bvc.phoneStr = self.mineData.phone;
        [self.navigationController pushViewController:bvc animated:YES];
    }else if (sender.tag == 2) {
        DSChangePwdVC *pvc = [DSChangePwdVC new];
        pvc.dataType = 2;
//        pvc.phoneStr = self.mineData.phone;
        [self.navigationController pushViewController:pvc animated:YES];
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
            
//            [[MSUserManager sharedInstance] logout:nil];//清空登录数据
//
//            HXTabBarController *tab = [[HXTabBarController alloc] init];
//            [UIApplication sharedApplication].keyWindow.rootViewController = tab;
//
//            //推出主界面出来
//            CATransition *ca = [CATransition animation];
//            ca.type = @"movein";
//            ca.duration = 0.5;
//            [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
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

@end
