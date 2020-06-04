//
//  AppDelegate.h
//  DS
//
//  Created by 夏增明 on 2019/11/11.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WXApi.h>
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIWindowSceneDelegate,WXApiDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow * window;

@end

