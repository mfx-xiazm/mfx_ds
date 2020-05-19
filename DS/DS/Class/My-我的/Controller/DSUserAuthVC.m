//
//  DSUserAuthVC.m
//  DS
//
//  Created by huaxin-01 on 2020/5/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSUserAuthVC.h"
#import "FSActionSheet.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "DSUserSignVC.h"
#import "DSUpCashVC.h"

@interface DSUserAuthVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *auth_view;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIImageView *card_fornt;
@property (weak, nonatomic) IBOutlet UIImageView *card_back;
@property (nonatomic, assign) NSInteger current_card_index;
@property (weak, nonatomic) IBOutlet UIView *auth_fail_view;
@property (weak, nonatomic) IBOutlet UIView *auth_success_view;
@property (weak, nonatomic) IBOutlet UIView *auth_msg_view;
@property (weak, nonatomic) IBOutlet UIButton *signOrCashBtn;
@property (weak, nonatomic) IBOutlet UIView *sign_success_view;

@end

@implementation DSUserAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCardTap];
    [self.submitBtn.layer addSublayer:[UIColor setGradualChangingColor:self.submitBtn fromColor:@"F9AD28" toColor:@"F95628"]];
    [self.signOrCashBtn.layer addSublayer:[UIColor setGradualChangingColor:self.signOrCashBtn fromColor:@"F9AD28" toColor:@"F95628"]];
}
#pragma mark -- 视图
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"用户认证"];
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_barTintColor = HXGlobalBg;
    self.hbd_tintColor = [UIColor blackColor];
    self.hbd_barShadowHidden = YES;
    self.hbd_titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName: [UIColor.blackColor colorWithAlphaComponent:1.0]};
}
-(void)setUpCardTap
{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapClicked:)];
    [self.card_fornt addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapClicked:)];
    [self.card_back addGestureRecognizer:tap2];
}
#pragma mark -- 点击事件
-(void)cardTapClicked:(UITapGestureRecognizer *)tap
{
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择"]];
    hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        hx_strongify(weakSelf);
        strongSelf.current_card_index = tap.view.tag;
        if (selectedIndex == 0) {
            [strongSelf awakeImagePickerController:@"1"];
        }else{
            [strongSelf awakeImagePickerController:@"2"];
        }
    }];
}
- (IBAction)submitAuthClicked:(UIButton *)sender {
    int type = arc4random() % 2;
    if (type) {
        self.auth_view.hidden = YES;
        self.auth_fail_view.hidden = YES;
        self.auth_success_view.hidden = NO;
        self.auth_msg_view.hidden = YES;
        self.sign_success_view.hidden = YES;
    }else{
        self.auth_view.hidden = YES;
        self.auth_fail_view.hidden = NO;
        self.auth_success_view.hidden = YES;
        self.auth_msg_view.hidden = YES;
        self.sign_success_view.hidden = YES;
    }
}
- (IBAction)reNewToAuthClicked:(UIButton *)sender {
    self.auth_view.hidden = NO;
    self.auth_fail_view.hidden = YES;
    self.auth_success_view.hidden = YES;
    self.auth_msg_view.hidden = YES;
    self.sign_success_view.hidden = YES;
}
- (IBAction)lookAuthMsgClicked:(UIButton *)sender {
    self.auth_view.hidden = YES;
    self.auth_fail_view.hidden = YES;
    self.auth_success_view.hidden = YES;
    self.auth_msg_view.hidden = NO;
    self.sign_success_view.hidden = YES;
}

- (IBAction)signClicked:(UIButton *)sender {
    DSUserSignVC *svc = [DSUserSignVC new];
    hx_weakify(self);
    svc.signSuccessCall = ^{
        hx_strongify(weakSelf);
        strongSelf.auth_view.hidden = YES;
        strongSelf.auth_fail_view.hidden = YES;
        strongSelf.auth_success_view.hidden = YES;
        strongSelf.auth_msg_view.hidden = YES;
        strongSelf.sign_success_view.hidden = NO;
    };
    [self.navigationController pushViewController:svc animated:YES];
}
- (IBAction)signOrCashClicked:(UIButton *)sender {
    DSUserSignVC *svc = [DSUserSignVC new];
    hx_weakify(self);
    svc.signSuccessCall = ^{
        hx_strongify(weakSelf);
        strongSelf.auth_view.hidden = YES;
        strongSelf.auth_fail_view.hidden = YES;
        strongSelf.auth_success_view.hidden = YES;
        strongSelf.auth_msg_view.hidden = YES;
        strongSelf.sign_success_view.hidden = NO;
    };
    [self.navigationController pushViewController:svc animated:YES];
}
- (IBAction)goCashClicked:(UIButton *)sender {
    DSUpCashVC *cvc = [DSUpCashVC new];
//    hx_weakify(self);
//    cvc.upCashActionCall = ^{
//        hx_strongify(weakSelf);
//        [strongSelf getMyBalanceRequest];
//    };
    [self.navigationController pushViewController:cvc animated:YES];
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
@end
