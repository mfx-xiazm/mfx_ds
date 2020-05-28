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
#import "DSUserAuthInfo.h"
#import "DSUserAuthView.h"
#import "FCTextField.h"

@interface DSUserAuthVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/** 认证页面  */
@property (weak, nonatomic) IBOutlet UIScrollView *auth_view;
@property (weak, nonatomic) IBOutlet UITextField *realname;
@property (weak, nonatomic) IBOutlet FCTextField *centNo;
@property (weak, nonatomic) IBOutlet UIImageView *card_fornt;
@property (weak, nonatomic) IBOutlet UIImageView *card_back;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic, copy) NSString *card_fornt_url;
@property (nonatomic, copy) NSString *card_back_url;
@property (nonatomic, assign) NSInteger current_card_index;
/** 认证失败页面  */
@property (weak, nonatomic) IBOutlet UIView *auth_fail_view;
@property (weak, nonatomic) IBOutlet UILabel *fail_reason;
/** 认证成功页面  */
@property (weak, nonatomic) IBOutlet UIView *auth_success_view;
/** 认证信息页面  */
@property (weak, nonatomic) IBOutlet UIView *auth_msg_view;
@property (weak, nonatomic) IBOutlet UILabel *show_name;
@property (weak, nonatomic) IBOutlet UILabel *show_centNo;
@property (weak, nonatomic) IBOutlet UIImageView *show_card_fornt;
@property (weak, nonatomic) IBOutlet UIImageView *show_card_back;

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
    
    //is_auth为0未认证，需要显示认证协议，用户同意后进入认证信息输入界面，然后提交认证信息。is_auth返回1则表示已认证，相关认证信息同时返回，显示在认证界面。 is_sign为0未签约；为1已签约
    if ([self.authInfo.is_auth isEqualToString:@"0"] && [self.authInfo.is_sign isEqualToString:@"0"]) {//未认证、未签约
        self.auth_view.hidden = NO;
        self.auth_fail_view.hidden = YES;
        self.auth_success_view.hidden = YES;
        self.auth_msg_view.hidden = YES;
        self.sign_success_view.hidden = YES;
        [self showUserAuthView];
        hx_weakify(self);
        [self.submitBtn BindingBtnJudgeBlock:^BOOL{
            hx_strongify(weakSelf);
            if (![strongSelf.realname hasText]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入您的真实姓名"];
                return NO;
            }
            if (![strongSelf.centNo hasText]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入身份证号码"];
                return NO;
            }
            if (!strongSelf.card_fornt_url.length) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传人像面照片"];
                return NO;
            }
            if (!strongSelf.card_back_url.length) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传国徽面照片"];
                return NO;
            }
            return YES;
        } ActionBlock:^(UIButton * _Nullable button) {
            hx_strongify(weakSelf);
            [strongSelf userVerifyRequest:button];
        }];
    }else if ([self.authInfo.is_auth isEqualToString:@"1"] && [self.authInfo.is_sign isEqualToString:@"0"]){//已认证、未签约
        self.auth_view.hidden = YES;
        self.auth_fail_view.hidden = YES;
        self.auth_success_view.hidden = YES;
        self.auth_msg_view.hidden = NO;
        self.sign_success_view.hidden = YES;
        
        self.show_name.text = self.authInfo.realname;
        self.show_centNo.text = self.authInfo.idcard;
        [self.show_card_fornt sd_setImageWithURL:[NSURL URLWithString:self.authInfo.idcard_front_img]];
        [self.show_card_fornt sd_setImageWithURL:[NSURL URLWithString:self.authInfo.idcard_back_img]];
    }else{// 已认证、已签约
        self.auth_view.hidden = YES;
        self.auth_fail_view.hidden = YES;
        self.auth_success_view.hidden = YES;
        self.auth_msg_view.hidden = YES;
        self.sign_success_view.hidden = NO;
    }
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
-(void)showUserAuthView
{
    DSUserAuthView *auth = [DSUserAuthView loadXibView];
    auth.hxn_width = HX_SCREEN_WIDTH - 30*2;
    auth.hxn_height = 460.f;
    hx_weakify(self);
    auth.userAuthCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        if (index) {
            // 填写认证信息
        }else{
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.dismissOnMaskTouched = NO;
    [self.zh_popupController presentContentView:auth duration:0.25 springAnimated:NO];
}
#pragma mark -- 接口
-(void)userVerifyRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"realname"] = self.realname.text;
    parameters[@"centNo"] = self.centNo.text;
    parameters[@"icCardFrontPicUrl"] = self.card_fornt_url;
    parameters[@"icCardBackPicUrl"] = self.card_back_url;

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"xinbao_verify_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"提交认证" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.auth_view.hidden = YES;
            strongSelf.auth_fail_view.hidden = YES;
            strongSelf.auth_success_view.hidden = NO;
            strongSelf.auth_msg_view.hidden = YES;
            strongSelf.sign_success_view.hidden = YES;
            
            strongSelf.authInfo.realname = strongSelf.realname.text;
            strongSelf.authInfo.idcard = strongSelf.centNo.text;
            strongSelf.authInfo.idcard_front_img = strongSelf.card_fornt_url;
            strongSelf.authInfo.idcard_back_img = strongSelf.card_back_url;
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            strongSelf.auth_view.hidden = YES;
            strongSelf.auth_fail_view.hidden = NO;
            strongSelf.fail_reason.text = responseObject[@"message"];
            strongSelf.auth_success_view.hidden = YES;
            strongSelf.auth_msg_view.hidden = YES;
            strongSelf.sign_success_view.hidden = YES;
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"提交认证" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 点击事件
// 身份证点击
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
// 认证失败重新认证
- (IBAction)reNewToAuthClicked:(UIButton *)sender {
    self.auth_view.hidden = NO;
    self.auth_fail_view.hidden = YES;
    self.auth_success_view.hidden = YES;
    self.auth_msg_view.hidden = YES;
    self.sign_success_view.hidden = YES;
}
// 认证成功查看认证信息
- (IBAction)lookAuthMsgClicked:(UIButton *)sender {
    self.auth_view.hidden = YES;
    self.auth_fail_view.hidden = YES;
    self.auth_success_view.hidden = YES;
    self.auth_msg_view.hidden = NO;
    self.sign_success_view.hidden = YES;
    
    self.show_name.text = self.authInfo.realname;
    self.show_centNo.text = self.authInfo.idcard;
    [self.show_card_fornt sd_setImageWithURL:[NSURL URLWithString:self.authInfo.idcard_front_img]];
    [self.show_card_fornt sd_setImageWithURL:[NSURL URLWithString:self.authInfo.idcard_back_img]];
}
// 去签约
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
    svc.realName = self.authInfo.realname;
    svc.centNo = self.authInfo.idcard;
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
    cvc.realNameTxt = self.authInfo.realname;
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
            if (strongSelf.current_card_index == 1) {
                strongSelf.card_fornt_url = imageUrl;
                [strongSelf.card_fornt sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
            }else{
                strongSelf.card_back_url = imageUrl;
                [strongSelf.card_back sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
            }
        }];
    }];
}
-(void)upImageRequestWithImage:(UIImage *)image completedCall:(void(^)(NSString * imageUrl))completedCall
{
    [HXNetworkTool uploadImagesWithURL:HXRC_M_URL action:@"multifileupload" parameters:@{} name:@"filename" images:@[image] fileNames:nil imageScale:0.8 imageType:@"png" progress:nil success:^(id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            // 将上传完成返回的图片链接存入数组
            NSDictionary *dict = ((NSArray *)responseObject[@"result"]).firstObject;
            completedCall([NSString stringWithFormat:@"%@",dict[@"url"]]);
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
