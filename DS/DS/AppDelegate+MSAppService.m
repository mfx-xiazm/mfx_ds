//
//  AppDelegate+MSAppService.m
//  KYPX
//
//  Created by hxrc on 2018/2/9.
//  Copyright © 2018年 KY. All rights reserved.
//

#import "AppDelegate+MSAppService.h"
#import "HXTabBarController.h"
#import "HXGuideViewController.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import <AlipaySDK/AlipaySDK.h>

@implementation AppDelegate (MSAppService)

#pragma mark ————— 初始化服务 —————
-(void)initService{
//    /* ————— 友盟 初始化 ————— */
//    [[UMSocialManager defaultManager] openLog:NO];
//    [UMConfigure initWithAppkey:HXUMengKey channel:@"App Store"];
//    
//    [self configUSharePlatforms];
    
    //->微信支付相关//
    [WXApi registerApp:HXWXKey];
}
-(void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:HXWXKey appSecret:HXWXSecret redirectURL:@"http://mobile.umeng.com/social"];
}
/*
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url  sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                // 1成功 2取消支付 3支付失败
                if ([resultDic[@"resultStatus"] intValue] == 9000) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:HXPayPushNotification object:nil userInfo:@{@"result":@"1"}];
                }else if ([resultDic[@"resultStatus"] intValue] == 6001){
                    [[NSNotificationCenter defaultCenter] postNotificationName:HXPayPushNotification object:nil userInfo:@{@"result":@"2"}];
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:HXPayPushNotification object:nil userInfo:@{@"result":@"3"}];
                }
            }];
        }else if ([url.host isEqualToString:@"pay"]) { //微信支付回调
            return [WXApi handleOpenURL:url delegate:self];
        }
    }
    return result;
}
 */
/*
 //9.0前的方法，为了适配低版本 保留
 - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
 BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
 if (!result) {
 // 其他如支付等SDK的回调
 if ([url.host isEqualToString:@"safepay"]) {
 //跳转支付宝钱包进行支付，处理支付结果
 [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
 // 1成功 2取消支付 3支付失败
 if ([resultDic[@"resultStatus"] intValue] == 9000) {
 [[NSNotificationCenter defaultCenter] postNotificationName:HXPayPushNotification object:nil userInfo:@{@"result":@"1"}];
 }else if ([resultDic[@"resultStatus"] intValue] == 6001){
 [[NSNotificationCenter defaultCenter] postNotificationName:HXPayPushNotification object:nil userInfo:@{@"result":@"2"}];
 }else{
 [[NSNotificationCenter defaultCenter] postNotificationName:HXPayPushNotification object:nil userInfo:@{@"result":@"3"}];
 }
 }];
 }else if ([url.host isEqualToString:@"pay"]) { //微信支付回调
 return [WXApi handleOpenURL:url delegate:self];
 }
 }
 return result;
 }
 */
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                // 1成功 2取消支付 3支付失败
                if ([resultDic[@"resultStatus"] intValue] == 9000) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:HXPayPushNotification object:nil userInfo:@{@"result":@"1"}];
                }else if ([resultDic[@"resultStatus"] intValue] == 6001){
                    [[NSNotificationCenter defaultCenter] postNotificationName:HXPayPushNotification object:nil userInfo:@{@"result":@"2"}];
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:HXPayPushNotification object:nil userInfo:@{@"result":@"3"}];
                }
            }];
        }else if ([url.host isEqualToString:@"pay"]) { //微信支付回调
            return [WXApi handleOpenURL:url delegate:self];
        }
    }
    return result;
}
#pragma mark ————— 微信支付回调 —————
//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
-(void)onResp:(BaseResp*)resp
{
    //启动微信支付的response
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        // 1成功 2取消支付 3支付失败
        if (resp.errCode == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:HXPayPushNotification object:nil userInfo:@{@"result":@"1"}];
        }else if (resp.errCode == -2){
            [[NSNotificationCenter defaultCenter] postNotificationName:HXPayPushNotification object:nil userInfo:@{@"result":@"2"}];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:HXPayPushNotification object:nil userInfo:@{@"result":@"3"}];
        }
    }
}
#pragma mark ————— 初始化window —————
-(void)initWindow{
    // 1.创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    // 3.显示窗口
    [self.window makeKeyAndVisible];
    
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}

#pragma mark ————— 初始化用户系统(业务自定义) —————
-(void)initUserManager{
    
//    // 2.设置根控制器
//    NSString *key = @"CFBundleShortVersionString";
//    // 上一次的使用版本（存储在沙盒中的版本号）
//    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
//    // 当前软件的版本号（从Info.plist中获得）
//    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
//    if ([currentVersion isEqualToString:lastVersion]) { // 版本号相同：这次打开和上次打开的是同一个版本
            HXTabBarController *tabBarController = [[HXTabBarController alloc] init];
            self.window.rootViewController = tabBarController;
//    } else {   // 这次打开的版本和上一次不一样，显示引导页
//        // 真实情况改成引导页
//        HXGuideViewController *gvc = [[HXGuideViewController alloc] init];
//        self.window.rootViewController = gvc;
//        // 将当前的版本号存进沙盒
//        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }

}
#pragma mark ————— 网络状态监听 —————
- (void)monitorNetworkStatus
{
    // 网络状态改变一次, networkStatusWithBlock就会响应一次
    [HXNetworkTool  networkStatusWithBlock:^(HXNetworkStatusType status) {
        switch (status) {
            case HXNetworkStatusUnknown: {
                /// 未知网络
                HXLog(@"--未知网络--");
                //[JMNotifyView showNotify:@"未知网络"];
            }
                break;
            case HXNetworkStatusNotReachable: {
                /// 无网络
                HXLog(@"--无网络--");
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"网络连接不可用，请检查网络设置"];
            }
                break;
            case HXNetworkStatusReachableViaWWAN: {
                /// 手机网络
                HXLog(@"--手机网络--");
                //[JMNotifyView showNotify:@"手机网络"];
            }
                break;
            case HXNetworkStatusReachableViaWiFi: {
                /// WIFI网络
                HXLog(@"--WIFI网络--");
                //[JMNotifyView showNotify:@"WIFI网络"];
            }
                break;
            default:
                break;
        }
    }];
}

+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end

