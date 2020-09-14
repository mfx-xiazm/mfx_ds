//
//  DSTeamRecordVC.m
//  DS
//
//  Created by huaxin-01 on 2020/9/9.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSTeamRecordVC.h"
#import "DSTeamRecord.h"
#import "DSMyTeam.h"

@interface DSTeamRecordVC ()
@property (nonatomic, strong) DSTeamRecord *teamRecord;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *ymd_leader_level;
@property (weak, nonatomic) IBOutlet UILabel *lj_ymd_amount;
@property (weak, nonatomic) IBOutlet UILabel *xz_ymd_amount;
@end

@implementation DSTeamRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self startShimmer];
    [self getRecordDetail];
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"业绩详情"];
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_barTintColor = HXGlobalBg;
    self.hbd_tintColor = [UIColor blackColor];
    self.hbd_barShadowHidden = YES;
    self.hbd_titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName: [UIColor.blackColor colorWithAlphaComponent:1.0]};
}
-(void)getRecordDetail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = self.parent_uid;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"myteam_ymd_lj_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.teamRecord = [DSTeamRecord yy_modelWithDictionary:responseObject[@"result"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleDetailData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)handleDetailData
{
    self.name.text = self.teamRecord.ymd_parent.nick_name;
    self.time.text = self.teamRecord.ymd_parent.create_time;
    self.ymd_leader_level.hidden = self.teamRecord.ymd_parent.ymd_leader_level.length?NO:YES;
    self.ymd_leader_level.text = [NSString stringWithFormat:@"  %@  ",self.teamRecord.ymd_parent.ymd_leader_level];
    self.lj_ymd_amount.text = [NSString stringWithFormat:@"¥%@",self.teamRecord.lj_ymd_amount];
    self.xz_ymd_amount.text = [NSString stringWithFormat:@"¥%@",self.teamRecord.xz_ymd_amount];
}
@end
