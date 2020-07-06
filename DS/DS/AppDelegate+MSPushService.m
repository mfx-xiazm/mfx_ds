//
//  AppDelegate+MSPushService.m
//  KYPX
//
//  Created by hxrc on 2018/2/9.
//  Copyright © 2018年 KY. All rights reserved.
//

#import "AppDelegate+MSPushService.h"
#import <UMPush/UMessage.h>
#import "DSWebContentVC.h"
#import "DSDynamicDetailVC.h"
#import "DSCashNoteVC.h"
#import "DSMyTeamVC.h"
#import <UMCommon/UMCommon.h>

@implementation AppDelegate (MSPushService)
-(void)initPushService:(NSDictionary *)launchOptions
{
    /* ————— 友盟 初始化 ————— */
    [UMConfigure initWithAppkey:HXUMengKey channel:@"App Store"];
    //注册通知
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
       //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
}
-(void)checkPushNotification:(NSDictionary *)launchOptions
{
    // 判断是否有通知
    NSDictionary *pushNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (pushNotification != nil) {
        HXLog(@"###应用杀死点击通知进入应用###");
        [self doHandleRemoteNotification:pushNotification];
    }
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    // HXLog(@"token--%@",hexToken);
    // 保存tokenString
    [[NSUserDefaults standardUserDefaults] setObject:hexToken forKey:HXDeviceTokens];
    [[NSUserDefaults standardUserDefaults] synchronize];

    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    // [UMessage registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    HXLog(@"Failed to get token, error:%@", error_str);
}
#pragma mark -- 处理远程通知
// iOS10以下使用这个方法接收通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion] intValue] < 10) {
        [UMessage didReceiveRemoteNotification:userInfo];

        if(application.applicationState == UIApplicationStateActive) {
            HXLog(@"####iOS 10下 前台推送通知####");
        }else {
            // 处理推送通知,跳转页面
            HXLog(@"####iOS 10下 后台推送通知####");
            [self doHandleRemoteNotification:userInfo];
        }
    }
    //过滤掉Push的撤销功能，因为PushSDK内部已经调用的completionHandler(UIBackgroundFetchResultNewData)，
    //防止两次调用completionHandler引起崩溃
    if(![userInfo valueForKeyPath:@"aps.recall"]) {
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)) API_AVAILABLE(ios(10.0)) API_AVAILABLE(ios(10.0)){
    NSDictionary *userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        HXLog(@"####iOS 10 前台收到推送通知--%@####",userInfo);
    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}
//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        HXLog(@"####iOS 10 后台点击推送通知####");
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];

        [self doHandleRemoteNotification:userInfo];
    }else{
        //应用处于后台时的本地推送接受
    }
    completionHandler();
}
#pragma mark -- 处理通知点击事件
-(void)doHandleRemoteNotification:(NSDictionary *)userInfo
{
    if (![MSUserManager sharedInstance].isLogined) {
        return;
    }
    UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
    UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
    
    NSInteger push_type = [userInfo[@"push_type"] integerValue];
    NSString *msg_id = [NSString stringWithFormat:@"%@",userInfo[@"msg_id"]];

    // 1系统消息(后台发送)；2业务消息(动态)；3邀请好友通知；4提现通知
    if (push_type == 1) {
        DSWebContentVC *wvc = [DSWebContentVC new];
        wvc.navTitle = @"消息详情";
        wvc.isNeedRequest = YES;
        wvc.requestType = 2;
        wvc.msg_id = msg_id;
        [nav pushViewController:wvc animated:YES];
    }else if (push_type == 2) {
        DSDynamicDetailVC *dvc = [DSDynamicDetailVC new];
        dvc.msg_id = msg_id;
        [nav pushViewController:dvc animated:YES];
    }else if (push_type == 3) {
        DSMyTeamVC *tvc = [DSMyTeamVC new];
        [nav pushViewController:tvc animated:YES];
    }else {
        DSCashNoteVC *nvc = [DSCashNoteVC new];
        [nav pushViewController:nvc animated:YES];
    }
}
//#pragma mark -- 程序进入活跃 角标清零
//-(void)applicationDidBecomeActive:(UIApplication *)application
//{
//    [application setApplicationIconBadgeNumber:0];
//}
@end
