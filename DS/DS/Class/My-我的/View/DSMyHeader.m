//
//  DSMyHeader.m
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMyHeader.h"

@interface DSMyHeader ()
@property (weak, nonatomic) IBOutlet UIImageView *head_pic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *sex;
@property (weak, nonatomic) IBOutlet UIImageView *vip;
@property (weak, nonatomic) IBOutlet UILabel *shareCode;
@property (weak, nonatomic) IBOutlet UILabel *phone;

@end
@implementation DSMyHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClicked)];
    [self.head_pic addGestureRecognizer:tap];
    
    [self showUserInfo];
}
-(void)setIsReload:(BOOL)isReload
{
    _isReload = isReload;
    if (_isReload) {
        [self showUserInfo];
    }
}
-(void)showUserInfo
{
    [self.head_pic sd_setImageWithURL:[NSURL URLWithString:[MSUserManager sharedInstance].curUserInfo.avatar] placeholderImage:HXGetImage(@"avatar")];
    self.name.text = [MSUserManager sharedInstance].curUserInfo.nick_name;
    
    if ([[MSUserManager sharedInstance].curUserInfo.sex isEqualToString:@"0"]) {
        self.sex.hidden = YES;
    }else{
        self.sex.hidden = NO;
        self.sex.image = [[MSUserManager sharedInstance].curUserInfo.sex isEqualToString:@"1"]?HXGetImage(@"男"):HXGetImage(@"女");
    }
    self.vip.hidden = ([MSUserManager sharedInstance].curUserInfo.ulevel != 1)?NO:YES;
    self.shareCode.text = [NSString stringWithFormat:@"邀请码：%@",[MSUserManager sharedInstance].curUserInfo.share_code];
    self.phone.text = [MSUserManager sharedInstance].curUserInfo.phone;
}
-(void)headClicked
{
    if (self.myHeaderBtnClickedCall) {
        self.myHeaderBtnClickedCall(6);
    }
}
- (IBAction)myHeaderBtnClicked:(UIButton *)sender {
    if (self.myHeaderBtnClickedCall) {
        self.myHeaderBtnClickedCall(sender.tag);
    }
}
@end
