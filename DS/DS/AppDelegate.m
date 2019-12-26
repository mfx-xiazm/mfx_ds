//
//  AppDelegate.m
//  DS
//
//  Created by 夏增明 on 2019/11/11.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+MSAppService.h"
#import "AppDelegate+MSPushService.h"
#import "DSGoodsShortCode.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 监听网络
    //    [self monitorNetworkStatus];
    
    //初始化window
    [self initWindow];
    
    //初始化 app服务
    [self initService];
    
    //初始化用户系统(根据自己的业务判断如何展示)
    [self initUserManager];
    
    // 注册推送
    //[self initPushService:launchOptions];
    
    // 通知点击检测
    //[self checkPushNotification:launchOptions];
    
    // 检查有没有获取的袋鼠分享口令
    [[DSGoodsShortCode sharedInstance] checkShortCodePush];
    return YES;
}
-(void)applicationWillEnterForeground:(UIApplication *)application
{
    // 检查有没有获取的袋鼠分享口令
    [[DSGoodsShortCode sharedInstance] checkShortCodePush];
}
#pragma mark - UISceneSession lifecycle

/*
1.如果没有在APP的Info.plist文件中包含scene的配置数据，或者要动态更改场景配置数据，需要实现此方法。 UIKit会在创建新scene前调用此方法。
2.方法会返回一个UISceneConfiguration对象，其包含其中包含场景详细信息，包括要创建的场景类型，用于管理场景的委托对象以及包含要显示的初始视图控制器的情节提要。 如果未实现此方法，则必须在应用程序的Info.plist文件中提供场景配置数据。

总结下：默认在info.plist中进行了配置， 不用实现该方法也没有关系。如果没有配置就需要实现这个方法并返回一个UISceneConfiguration对象。
配置参数中Application Session Role 是个数组，每一项有三个参数:
Configuration Name:   当前配置的名字;
Delegate Class Name:  与哪个Scene代理对象关联;
StoryBoard name: 这个Scene使用的哪个storyboard。
注意：代理方法中调用的是配置名为Default Configuration的Scene，则系统就会自动去调用SceneDelegate这个类。这样SceneDelegate和AppDelegate产生了关联。
*/

//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}

/** 在分屏中关闭其中一个或多个scene时候回调用 */
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


@end
