//
//  HXBaseViewController.m
//  KYPX
//
//  Created by hxrc on 17/7/13.
//  Copyright © 2017年 KY. All rights reserved.
//

#import "HXBaseViewController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <sys/utsname.h>
#import "AILoadingView.h"

@interface HXBaseViewController ()
/** Shimmering */
@property(nonatomic,weak)AILoadingView *loadingView;
@end

@implementation HXBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hbd_barStyle = UIBarStyleBlack;
    self.hbd_tintColor = [UIColor whiteColor];

    if ([self isiPhoneXLater]) {
        self.iPhoneXLater = YES;
        self.HXNavBarHeight = 88.f;
        self.HXTabBarHeight = 83.f;
        self.HXButtomHeight = 34.f;
        self.HXStatusHeight = 44.f;
    }else{
        self.iPhoneXLater = NO;
        self.HXNavBarHeight = 64.f;
        self.HXTabBarHeight = 49.f;
        self.HXButtomHeight = 0.f;
        self.HXStatusHeight = 20.f;
    }

    AILoadingView *loadingView  = [[AILoadingView alloc] initWithFrame:self.view.bounds];
    loadingView.backgroundColor = HXGlobalBg;
    loadingView.strokeColor     = HXControlBg;
    loadingView.hidden = YES;
    self.loadingView            = loadingView;
    [self.view addSubview:loadingView];
}
//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
-(void)reloadDataRequest
{
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.loadingView.frame = self.view.bounds;
}
-(BOOL)isiPhoneXLater
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*phoneType = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    /*
     if([phoneType  isEqualToString:@"iPhone10,3"]) return@"iPhone X";
     
     if([phoneType  isEqualToString:@"iPhone10,6"]) return@"iPhone X";
     
     if([phoneType  isEqualToString:@"iPhone11,8"]) return@"iPhone XR";
     
     if([phoneType  isEqualToString:@"iPhone11,2"]) return@"iPhone XS";
     
     if([phoneType  isEqualToString:@"iPhone11,4"]) return@"iPhone XS Max";
     
     if([phoneType  isEqualToString:@"iPhone11,6"]) return@"iPhone XS Max";
     */
    if([phoneType  isEqualToString:@"iPhone10,3"] || [phoneType  isEqualToString:@"iPhone10,6"] || [phoneType  isEqualToString:@"iPhone11,8"] || [phoneType  isEqualToString:@"iPhone11,2"] || [phoneType  isEqualToString:@"iPhone11,4"] || [phoneType  isEqualToString:@"iPhone11,6"] || [phoneType  isEqualToString:@"iPhone12,1"] || [phoneType  isEqualToString:@"iPhone12,3"] || [phoneType  isEqualToString:@"iPhone12,5"]) {
        return YES;
    }else{
        return NO;
    }
}
-(void)startShimmer
{
    self.loadingView.hidden = NO;
    [self.loadingView starAnimation];
}
-(void)stopShimmer
{
    [self.loadingView stopAnimation];
    self.loadingView.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 隐私->照片界面
 
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"]];
 隐私->相机界面
 
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"]];

 */
/**
 判断是否有相册权限

 @return yes有权限；no无权限
 */
- (BOOL)isCanUsePhotos {
//    if (@available(iOS 8.0, *)) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted ||
            status == PHAuthorizationStatusDenied) {
            //无权限
            return NO;
        }
//    }else{
//        ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
//        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
//            //无权限
//            return NO;
//        }
//    }
    return YES;
}
/**
 检测相机是否授权
 */
- (BOOL)isCanUseCamera
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    /*
    AVAuthorizationStatusNotDetermined = 0,// 系统还未知是否访问，第一次开启相机时
    AVAuthorizationStatusRestricted, // 受限制的
    AVAuthorizationStatusDenied, //不允许
    AVAuthorizationStatusAuthorized // 允许状态
    */
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}
- (BOOL)isCanUseLocation
{
    if(![CLLocationManager locationServicesEnabled]){
       return NO;
    }
    CLAuthorizationStatus locationStatus =  [CLLocationManager authorizationStatus];
    if (locationStatus == kCLAuthorizationStatusRestricted || locationStatus == kCLAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}


@end
