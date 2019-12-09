//
//  GXSaveImageToPHAsset.m
//  GX
//
//  Created by 夏增明 on 2019/11/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXSaveImageToPHAsset.h"
#import <Photos/Photos.h>
#import "zhAlertView.h"
#import <zhPopupController.h>

@interface GXSaveImageToPHAsset()
@property (nonatomic, strong) NSMutableArray *listOfDownLoadImageArr;
@end

@implementation GXSaveImageToPHAsset

-(NSMutableArray *)listOfDownLoadImageArr {
    if (!_listOfDownLoadImageArr) {
        _listOfDownLoadImageArr = [NSMutableArray array];
    }
    return _listOfDownLoadImageArr;
}
- (void)saveImages:(NSArray *)imageArrs comletedCall:(saveComletedCall _Nullable)comletedCall
{
    self.saveComletedCall = comletedCall;
        
    if ([imageArrs.firstObject isKindOfClass:[NSString class]]) {
        for (int i = 0; i <imageArrs.count; i++) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:imageArrs[i]]];
            UIImage *image = [UIImage imageWithData:data]; // 取得图片
            [self.listOfDownLoadImageArr addObject:image];
        }
    }else{
        for (int i = 0; i <imageArrs.count; i++) {
            UIImage *image = imageArrs[i]; // 取得图片
            [self.listOfDownLoadImageArr addObject:image];
        }
    }
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    // 2.判断用户的授权状态
    if (status == PHAuthorizationStatusNotDetermined) {
        // 如果状态是不确定的话,block中的内容会等到授权完成再调用
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            // 授权完成就会调用
            if (status == PHAuthorizationStatusAuthorized) {
                //调用存储图片的方法
                [self CWWSavePhotos];
            }
        }];
        //如果允许访问
    } else if (status == PHAuthorizationStatusAuthorized) {
        //调用存储图片的方法
        [self CWWSavePhotos];
        //如果权限是拒绝
    } else {
        // 使用第三方框架,弹出一个页面提示用户去打开授权
        hx_weakify(self);
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相册权限" message:@"设置-隐私-相册" constantWidth:HX_SCREEN_WIDTH - 50*2];
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
            [weakSelf.targetVC.zh_popupController dismiss];
        }];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
        [alert addAction:okButton];
        weakSelf.targetVC.zh_popupController = [[zhPopupController alloc] init];
        [weakSelf.targetVC.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
    }
}
- (void)CWWSavePhotos {
    if (self.listOfDownLoadImageArr.count > 0) {
        UIImage *image = [self.listOfDownLoadImageArr objectAtIndex:0];
        [self savePhoto:image];
    }else {
        if (self.saveComletedCall) {
            self.saveComletedCall();
        }
    }
}
#pragma mark - 该方法获取在图库中是否已经创建该App的相册
//该方法的作用,获取系统中所有的相册,进行遍历,若是已有相册,返回该相册,若是没有返回nil,参数为需要创建  的相册名称
- (PHAssetCollection *)fetchAssetColletion:(NSString *)albumTitle
{
    // 获取所有的相册
    PHFetchResult *result = [PHAssetCollection           fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    //遍历相册数组,是否已创建该相册
    for (PHAssetCollection *assetCollection in result) {
        if ([assetCollection.localizedTitle isEqualToString:albumTitle]) {
            return assetCollection;
        }
    }
    return nil;
    
}
#pragma mark - 保存图片的方法

- (void)savePhoto:(UIImage *)imagePhoto

{
    //修改系统相册用PHPhotoLibrary单粒,调用performChanges,否则苹果会报错,并提醒你使用
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 调用判断是否已有该名称相册
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        //以项目名字命名相册
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        PHAssetCollection *assetCollection = [self fetchAssetColletion:app_Name];
        //创建一个操作图库的对象
        
        PHAssetCollectionChangeRequest *assetCollectionChangeRequest;
        if (assetCollection) {
            // 已有相册
            assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            
        } else {
            // 1.创建自定义相册
            assetCollectionChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:app_Name];
        }
        // 2.保存你需要保存的图片到系统相册(这里保存的是_imageView上的图片)
        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:imagePhoto];
        // 3.把创建好图片添加到自己相册(ps:想保存到系统相册，就注释掉下边一行代码就ok)
        //这里使用了占位图片,为什么使用占位图片呢
        //这个block是异步执行的,使用占位图片先为图片分配一个内存,等到有图片的时候,再对内存进行赋值
        PHObjectPlaceholder *placeholder = [assetChangeRequest placeholderForCreatedAsset];
        [assetCollectionChangeRequest addAssets:@[placeholder]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        //弹出一个界面提醒用户是否保存成功
        if (error) {
            //[SVProgressHUD showErrorWithStatus:@"保存失败"];
        } else {
            // [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            [self.listOfDownLoadImageArr removeObjectAtIndex:0];
        }
        [self CWWSavePhotos];
    }];
    
}
@end
