//
//  DSChangeInfoVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSChangeInfoVC.h"
#import "LEEAlert.h"
#import "zhAlertView.h"
#import <zhPopupController.h>

@interface DSChangeInfoVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UITextField *nick;
@property (weak, nonatomic) IBOutlet UITextField *sex;
/* 头像url */
@property(nonatomic,copy) NSString *headPicUrl;
@end

@implementation DSChangeInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"个人资料"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(setUserInfoRequest) title:@"确定" font:[UIFont systemFontOfSize:15] titleColor:[UIColor whiteColor] highlightedColor:[UIColor whiteColor] titleEdgeInsets:UIEdgeInsetsZero];
    
    [self.headPic sd_setImageWithURL:[NSURL URLWithString:[MSUserManager sharedInstance].curUserInfo.avatar] placeholderImage:HXGetImage(@"avatar")];
    self.nick.text = [MSUserManager sharedInstance].curUserInfo.nick_name.length ?[MSUserManager sharedInstance].curUserInfo.nick_name:@"";
    if ([[MSUserManager sharedInstance].curUserInfo.sex isEqualToString:@"0"]) {
        self.sex.text = @"";
    }else{
        self.sex.text = [[MSUserManager sharedInstance].curUserInfo.sex isEqualToString:@"1"]?@"男":@"女";
    }
}
- (IBAction)changeHeadPic:(UIButton *)sender {
    hx_weakify(self);
    [LEEAlert actionsheet].config
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeDefault;
        action.title = @"拍照";
        action.titleColor = UIColorFromRGB(0x333333);
        action.font = [UIFont systemFontOfSize:17.0f];
        action.clickBlock = ^{
            // 点击事件Block
            hx_strongify(weakSelf);
            [strongSelf awakeImagePickerController:@"1"];
        };
    })
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeDefault;
        action.title = @"从手机相册选择";
        action.titleColor = UIColorFromRGB(0x333333);
        action.font = [UIFont systemFontOfSize:17.0f];
        action.clickBlock = ^{
            // 点击事件Block
            hx_strongify(weakSelf);
            [strongSelf awakeImagePickerController:@"2"];
        };
    })
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeCancel;
        action.title = @"取消";
        action.titleColor = UIColorFromRGB(0x333333);
        action.font = [UIFont systemFontOfSize:17.0f];
    })
    .LeeActionSheetCancelActionSpaceColor(UIColorFromRGB(0xF6F7F8)) // 设置取消按钮间隔的颜色
    .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
    .LeeBackgroundStyleTranslucent(0.50)
    .LeeCornerRadii(CornerRadiiMake(0, 0, 0, 0))   // 指定整体圆角半径
    .LeeActionSheetHeaderCornerRadii(CornerRadiiZero()) // 指定头部圆角半径
    .LeeActionSheetCancelActionCornerRadii(CornerRadiiZero()) // 指定取消按钮圆角半径
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
        // 这是最大宽度为屏幕宽度 (横屏和竖屏)
        return CGRectGetWidth([[UIScreen mainScreen] bounds]);
    })
    .LeeActionSheetBackgroundColor([UIColor whiteColor]) // 通过设置背景颜色来填充底部间隙
    .LeeShow();
}
- (IBAction)changeSex:(UIButton *)sender {
    hx_weakify(self);
    [LEEAlert actionsheet].config
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeDefault;
        action.title = @"男";
        action.titleColor = UIColorFromRGB(0x333333);
        action.font = [UIFont systemFontOfSize:17.0f];
        action.clickBlock = ^{
            // 点击事件Block
            hx_strongify(weakSelf);
            strongSelf.sex.text = @"男";
        };
    })
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeDefault;
        action.title = @"女";
        action.titleColor = UIColorFromRGB(0x333333);
        action.font = [UIFont systemFontOfSize:17.0f];
        action.clickBlock = ^{
            // 点击事件Block
            hx_strongify(weakSelf);
            strongSelf.sex.text = @"女";
        };
    })
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeCancel;
        action.title = @"取消";
        action.titleColor = UIColorFromRGB(0x333333);
        action.font = [UIFont systemFontOfSize:17.0f];
    })
    .LeeActionSheetCancelActionSpaceColor(UIColorFromRGB(0xF6F7F8)) // 设置取消按钮间隔的颜色
    .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
    .LeeBackgroundStyleTranslucent(0.50)
    .LeeCornerRadii(CornerRadiiMake(0, 0, 0, 0))   // 指定整体圆角半径
    .LeeActionSheetHeaderCornerRadii(CornerRadiiZero()) // 指定头部圆角半径
    .LeeActionSheetCancelActionCornerRadii(CornerRadiiZero()) // 指定取消按钮圆角半径
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
        // 这是最大宽度为屏幕宽度 (横屏和竖屏)
        return CGRectGetWidth([[UIScreen mainScreen] bounds]);
    })
    .LeeActionSheetBackgroundColor([UIColor whiteColor]) // 通过设置背景颜色来填充底部间隙
    .LeeShow();
}
#pragma mark -- 唤起相机
- (void)awakeImagePickerController:(NSString *)pickerType {
    if ([pickerType isEqualToString:@"1"]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            if ([self isCanUseCamera]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                //前后摄像头是否可用
                [UIImagePickerController isCameraDeviceAvailable:YES];
                //相机闪光灯是否OK
                [UIImagePickerController isFlashAvailableForCameraDevice:YES];
                if (@available(iOS 13.0, *)) {
                    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
                    /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
                    imagePickerController.modalInPresentation = YES;
                }
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else{
                hx_weakify(self);
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.zh_popupController dismiss];
                }];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert addAction:okButton];
                self.zh_popupController = [[zhPopupController alloc] init];
                [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }
        }else{
            [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionTop title:@"相机不可用"];
            return;
        }
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            if ([self isCanUsePhotos]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //前后摄像头是否可用
                [UIImagePickerController isCameraDeviceAvailable:YES];
                //相机闪光灯是否OK
                [UIImagePickerController isFlashAvailableForCameraDevice:YES];
                if (@available(iOS 13.0, *)) {
                    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
                    /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
                    imagePickerController.modalInPresentation = YES;
                }
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else{
                hx_weakify(self);
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相册权限" message:@"设置-隐私-相册" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.zh_popupController dismiss];
                }];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert addAction:okButton];
                self.zh_popupController = [[zhPopupController alloc] init];
                [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }
        }else{
            [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionTop title:@"相册不可用"];
            return;
        }
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    hx_weakify(self);
    [picker dismissViewControllerAnimated:YES completion:^{
        hx_strongify(weakSelf);
        // 显示保存图片
        [strongSelf upImageRequestWithImage:info[UIImagePickerControllerEditedImage] completedCall:^(NSString *imageUrl) {
            strongSelf.headPic.image = info[UIImagePickerControllerEditedImage];
            strongSelf.headPicUrl = imageUrl;
        }];
    }];
}
-(void)upImageRequestWithImage:(UIImage *)image completedCall:(void(^)(NSString * imageUrl))completedCall
{
    [HXNetworkTool uploadImagesWithURL:HXRC_M_URL action:@"multifileupload" parameters:@{} name:@"filename" images:@[image] fileNames:nil imageScale:0.8 imageType:@"png" progress:nil success:^(id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            // 将上传完成返回的图片链接存入数组
            NSDictionary *dict = ((NSArray *)responseObject[@"result"]).firstObject;
            completedCall([NSString stringWithFormat:@"%@",dict[@"relative_url"]]);
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)setUserInfoRequest
{
//    if (![self.nick hasText]) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入昵称"];
//        return;
//    }
    if (![self.sex hasText]) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择性别"];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
 
    parameters[@"avatar"] = (self.headPicUrl && self.headPicUrl.length)?self.headPicUrl:@"";//传空表示头像不修改。传递相对路径
    parameters[@"nick_name"] = [self.nick hasText]?self.nick.text:@"";//昵称
    parameters[@"sex"] = [self.sex.text isEqualToString:@"男"]?@"1":@"2";//性别：1男；2女
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"user_info_set" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"修改成功"];
           
            [MSUserManager sharedInstance].curUserInfo = [MSUserInfo yy_modelWithDictionary:responseObject[@"result"]];
            [[MSUserManager sharedInstance] saveUserInfo];
            
            [strongSelf.navigationController popViewControllerAnimated:YES];
           
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
