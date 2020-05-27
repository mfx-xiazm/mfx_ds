//
//  DSMyVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/11.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMyVC.h"
#import "DSMyHeader.h"
#import "DSMyCell.h"
#import "DSMyOrderVC.h"
#import "DSChangeInfoVC.h"
#import "DSMySetVC.h"
#import "DSMyTeamVC.h"
#import "DSMyCardVC.h"
#import "DSMyCollectVC.h"
#import "DSMyAddressVC.h"
#import "DSMyBalanceVC.h"
#import "DSMyDynamicVC.h"
#import "DSMyAfterOrderVC.h"
#import "DSAllOrderVC.h"
#import "DSCartVC.h"
#import "UIView+WZLBadge.h"

@interface DSMyVC ()
@property (weak, nonatomic) IBOutlet UIImageView *header_img;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *vip;
@property (weak, nonatomic) IBOutlet UILabel *shareCode;
@property (weak, nonatomic) IBOutlet UILabel *collectCnt;
@property (weak, nonatomic) IBOutlet UILabel *teamCnt;
@property (weak, nonatomic) IBOutlet UILabel *cartCnt;
@property (weak, nonatomic) IBOutlet UILabel *cardCnt;
@property (weak, nonatomic) IBOutlet UILabel *total_amount;
@property (weak, nonatomic) IBOutlet UILabel *today_amount;
@property (weak, nonatomic) IBOutlet UILabel *cur_month_amount;
@property (weak, nonatomic) IBOutlet UILabel *last_month_amount;
@property (weak, nonatomic) IBOutlet UIImageView *noPayItem;
@property (weak, nonatomic) IBOutlet UIImageView *noDeItem;
@property (weak, nonatomic) IBOutlet UIImageView *noTakeItem;
@property (weak, nonatomic) IBOutlet UIImageView *completedItem;
@property (weak, nonatomic) IBOutlet UIImageView *refundItem;

@end

@implementation DSMyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    self.header_img.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileInfoClicked:)];
    [self.header_img addGestureRecognizer:tap];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserInfoRequest];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    self.hbd_barShadowHidden = YES;
    UIBarButtonItem *kefu = [UIBarButtonItem itemWithTarget:self action:@selector(kefuClicked) image:HXGetImage(@"客服")];
    UIBarButtonItem *set = [UIBarButtonItem itemWithTarget:self action:@selector(setClicked) image:HXGetImage(@"设 置")];
    self.navigationItem.rightBarButtonItems = @[set,kefu];
}
#pragma mark -- 点击
-(void)kefuClicked
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"LFy-122h";
    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"已复制客服微信号到剪切板"];
}
-(void)setClicked
{
    DSMySetVC *svc = [DSMySetVC new];
    [self.navigationController pushViewController:svc animated:YES];
}
-(void)profileInfoClicked:(UITapGestureRecognizer *)tap
{
    DSChangeInfoVC *ivc = [DSChangeInfoVC new];
    [self.navigationController pushViewController:ivc animated:YES];
}
- (IBAction)myCollectBtnClicked:(UIButton *)sender {
    DSMyCollectVC *cvc = [DSMyCollectVC new];
    [self.navigationController pushViewController:cvc animated:YES];
}
- (IBAction)myCartBtnClicked:(UIButton *)sender {
    DSCartVC *cvc = [DSCartVC new];
    [self.navigationController pushViewController:cvc animated:YES];
}

- (IBAction)myCardBtnClicked:(UIButton *)sender {
    DSMyCardVC *gvc = [DSMyCardVC new];
    [self.navigationController pushViewController:gvc animated:YES];
}

- (IBAction)myBalanceBtnClicked:(UIButton *)sender {
    DSMyBalanceVC *nvc = [DSMyBalanceVC new];
    [self.navigationController pushViewController:nvc animated:YES];
}
- (IBAction)pasteBtnClicked:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [MSUserManager sharedInstance].curUserInfo.share_code;
    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"复制成功"];
}
- (IBAction)myOrderClicked:(UIButton *)sender {
    if (sender.tag == 5){
        DSMyAfterOrderVC *dvc = [DSMyAfterOrderVC new];
        [self.navigationController pushViewController:dvc animated:YES];
    }else{
        if (sender.tag == 0) {
            DSAllOrderVC *ovc = [DSAllOrderVC new];
            [self.navigationController pushViewController:ovc animated:YES];
        }else{
            DSMyOrderVC *ovc = [DSMyOrderVC new];
            ovc.selectIndex = sender.tag;
            [self.navigationController pushViewController:ovc animated:YES];
        }
    }
}
- (IBAction)myTeamBtnClicked:(UIButton *)sender {
    DSMyTeamVC *avc = [DSMyTeamVC new];
    [self.navigationController pushViewController:avc animated:YES];
}
- (IBAction)myAddressBtnClicked:(UIButton *)sender {
    DSMyAddressVC *avc = [DSMyAddressVC new];
    [self.navigationController pushViewController:avc animated:YES];
}
- (IBAction)myDynamicBtnClicked:(UIButton *)sender {
    DSMyDynamicVC *bvc = [DSMyDynamicVC new];
    [self.navigationController pushViewController:bvc animated:YES];
}
#pragma mark -- 业务逻辑
-(void)getUserInfoRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"user_info_get" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MSUserManager sharedInstance].curUserInfo = [MSUserInfo yy_modelWithDictionary:responseObject[@"result"]];
            [[MSUserManager sharedInstance] saveUserInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf showUserInfo];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)showUserInfo
{
    [self.header_img sd_setImageWithURL:[NSURL URLWithString:[MSUserManager sharedInstance].curUserInfo.avatar] placeholderImage:HXGetImage(@"avatar")];
    self.name.text = [MSUserManager sharedInstance].curUserInfo.nick_name;
    
    if ([MSUserManager sharedInstance].curUserInfo.ulevel != 1) {
        self.vip.hidden = NO;
        self.vip.image = HXGetImage(@"等级");
    }else{
        self.vip.hidden = NO;
        self.vip.image = HXGetImage(@"普通");
    }
    
    self.shareCode.text = [NSString stringWithFormat:@"邀请码：%@",[MSUserManager sharedInstance].curUserInfo.share_code];
    
    self.collectCnt.text = [NSString stringWithFormat:@"%zd",[MSUserManager sharedInstance].curUserInfo.collectCnt];
    self.teamCnt.text = [NSString stringWithFormat:@"%zd",[MSUserManager sharedInstance].curUserInfo.teamCnt];
    self.cartCnt.text = [NSString stringWithFormat:@"%zd",[MSUserManager sharedInstance].curUserInfo.cartCnt];
    self.cardCnt.text = [NSString stringWithFormat:@"%zd",[MSUserManager sharedInstance].curUserInfo.cardCnt];

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"#,###.##"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[MSUserManager sharedInstance].curUserInfo.total_amount]];
    //若用于整数改为:[numberFormatter setPositiveFormat:@"###,##0"];
    [self.total_amount setFontAttributedText:[NSString stringWithFormat:@"￥%@",formattedNumberString] andChangeStr:@[@"￥"] andFont:@[[UIFont fontWithName:@"PingFangSC-Semibold" size: 16]]];
    
    NSString *today_amount = [NSString stringWithFormat:@"￥%@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:[MSUserManager sharedInstance].curUserInfo.today_amount]]];
    [self.today_amount setFontAttributedText:today_amount andChangeStr:@[@"￥"] andFont:@[[UIFont fontWithName:@"PingFangSC-Medium" size: 11]]];
    
    NSString *cur_month_amount = [NSString stringWithFormat:@"￥%@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:[MSUserManager sharedInstance].curUserInfo.cur_month_amount]]];
    [self.cur_month_amount setFontAttributedText:cur_month_amount andChangeStr:@[@"￥"] andFont:@[[UIFont fontWithName:@"PingFangSC-Medium" size: 11]]];
    
    NSString *last_month_amount = [NSString stringWithFormat:@"￥%@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:[MSUserManager sharedInstance].curUserInfo.last_month_amount]]];
    [self.last_month_amount setFontAttributedText:last_month_amount andChangeStr:@[@"￥"] andFont:@[[UIFont fontWithName:@"PingFangSC-Medium" size: 11]]];

    self.noPayItem.badgeBgColor = HXControlBg;
    [self.noPayItem showBadgeWithStyle:WBadgeStyleNumber value:[MSUserManager sharedInstance].curUserInfo.noPayCnt animationType:WBadgeAnimTypeNone];
    self.noDeItem.badgeBgColor = HXControlBg;
    [self.noDeItem showBadgeWithStyle:WBadgeStyleNumber value:[MSUserManager sharedInstance].curUserInfo.noDeCnt animationType:WBadgeAnimTypeNone];
    self.noTakeItem.badgeBgColor = HXControlBg;
    [self.noTakeItem showBadgeWithStyle:WBadgeStyleNumber value:[MSUserManager sharedInstance].curUserInfo.noTakeCnt animationType:WBadgeAnimTypeNone];
    self.completedItem.badgeBgColor = HXControlBg;
    [self.completedItem showBadgeWithStyle:WBadgeStyleNumber value:[MSUserManager sharedInstance].curUserInfo.completeCnt animationType:WBadgeAnimTypeNone];
    self.refundItem.badgeBgColor = HXControlBg;
    [self.refundItem showBadgeWithStyle:WBadgeStyleNumber value:[MSUserManager sharedInstance].curUserInfo.trfundCnt animationType:WBadgeAnimTypeNone];
}
@end
