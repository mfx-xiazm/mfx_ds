//
//  DSGoodsShortCode.m
//  DS
//
//  Created by 夏增明 on 2019/12/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSGoodsShortCode.h"
#import "DSGoodsDetailVC.h"
#import "zhAlertView.h"
#import <zhPopupController.h>

static DSGoodsShortCode *_instance = nil;

@implementation DSGoodsShortCode
+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
/** 检查剪切板有没有本APP的口令 */
-(void)checkShortCodePush
{
    UIPasteboard *pasteboard= [UIPasteboard generalPasteboard];
    if(!pasteboard.string) {
        return;
    }
    if([pasteboard.string rangeOfString:@"【DS】"].location == NSNotFound){
        return;
    }

    NSString *shortCodeStr = [pasteboard.string substringFromIndex:4];
    NSArray *tempArr = [shortCodeStr componentsSeparatedByString:@"】"];
    NSString *goods_name = nil;
    NSString *goods_id = nil;
    NSString *share_uid = nil;
    //【DS】【{0}】【{1}】{2}
    // 0是商品名称，1是商品goods_Id，2是分享人的uid，两个id是base64编码的
    for (int i=0;i<tempArr.count;i++) {
        NSString *str = tempArr[i];
        if ([str hasPrefix:@"【"]) {
            if (i==0) {
                goods_name = [str substringFromIndex:1];
                //HXLog(@"袋鼠口令短码---%@",goods_name);
            }else{
                NSData *data = [[NSData alloc] initWithBase64EncodedString:[str substringFromIndex:1] options:0];
                goods_id = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                //HXLog(@"袋鼠口令短码---%@",goods_id);
            }
        }else{
            NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:0];
            share_uid = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //HXLog(@"袋鼠口令短码---%@",share_uid);
        }
    }

        // 根据预先设定的规则，进行取值并展示跳转
    if ([MSUserManager sharedInstance].isLogined) {
        UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *nav = tab.viewControllers[tab.selectedIndex];

        __weak UINavigationController *weakNav = nav;
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"袋鼠精选口令" message:goods_name constantWidth:HX_SCREEN_WIDTH - 50*2];
        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
            [weakNav.zh_popupController dismiss];
        }];
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"查看商品" handler:^(zhAlertButton * _Nonnull button) {
            [nav.zh_popupController dismiss];
            DSGoodsDetailVC *dvc = [DSGoodsDetailVC new];
            dvc.goods_id = goods_id;
            dvc.share_uid = share_uid;
            [weakNav pushViewController:dvc animated:YES];
        }];
        cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
        [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
        nav.zh_popupController = [[zhPopupController alloc] init];
        [nav.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
        
        // 将剪切板置空
        pasteboard.string = @"";
    }
}
@end
