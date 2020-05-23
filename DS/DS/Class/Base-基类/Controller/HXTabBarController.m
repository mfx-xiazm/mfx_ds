//
//  HXTabBarController.m
//  HX
//
//  Created by hxrc on 17/3/2.
//  Copyright © 2017年 HX. All rights reserved.
//

#import "HXTabBarController.h"
#import "UIImage+HXNExtension.h"
#import "HXNavigationController.h"
#import "DSAfreshHomeVC.h"
#import "DSHomeVC.h"
#import "DSVipVC.h"
#import "DSDynamicVC.h"
#import "DSCartVC.h"
#import "DSMyVC.h"

@interface HXTabBarController ()<UITabBarControllerDelegate>

@end

@implementation HXTabBarController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
    attrs[NSForegroundColorAttributeName] = UIColorFromRGB(0x666666);
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = HXControlBg;
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    [self setupChildVc:[[DSAfreshHomeVC alloc] init] title:@"鲸品库" image:@"首页图标" selectedImage:@"首页图标选中"];
//    [self setupChildVc:[[DSHomeVC alloc] init] title:@"鲸品库" image:@"首页图标" selectedImage:@"首页图标选中"];
    [self setupChildVc:[[DSVipVC alloc] init] title:@"VIP会员" image:@"会员图标" selectedImage:@"会员图标选中"];
    [self setupChildVc:[[DSDynamicVC alloc] init] title:@"鲸学院" image:@"动态图标" selectedImage:@"动态图标选中"];
    //[self setupChildVc:[[DSCartVC alloc] init] title:@"购物车" image:@"购物车图标" selectedImage:@"购物车图标选中"];
    [self setupChildVc:[[DSMyVC alloc] init] title:@"我的" image:@"我的图标" selectedImage:@"我的图标选中"];

    self.delegate = self;
    
    // 设置透明度和背景颜色
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    self.tabBar.translucent = NO;//这句表示取消tabBar的透明效果。
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setShadowImage:[UIImage new]];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, HX_SCREEN_WIDTH, 0.5)];
    view.backgroundColor = [UIColor whiteColor];
    [[UITabBar appearance] insertSubview:view atIndex:0];
    
    self.tabBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -2);
    self.tabBar.layer.shadowOpacity = 0.10;
}
/**
 * 初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.title = title;
    
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 包装一个自定义的导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}
#pragma mark -- ————— UITabBarController 代理 —————
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
//    if ([viewController.tabBarItem.title isEqualToString:@"购物车"] || [viewController.tabBarItem.title isEqualToString:@"我的"]){
//        if (![MSUserManager sharedInstance].isLogined){// 未登录
//            DSLoginVC *lvc = [DSLoginVC new];
//            HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:lvc];
//            if (@available(iOS 13.0, *)) {
//                nav.modalPresentationStyle = UIModalPresentationFullScreen;
//                /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
//                nav.modalInPresentation = YES;
//                
//            }
//            [tabBarController.selectedViewController presentViewController:nav animated:YES completion:nil];
//            return NO;
//        }else{ // 如果已登录
//            return YES;
//        }
//    }else{
//        return YES;
//    }
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
