//
//  DSGranaryVC.m
//  DS
//
//  Created by huaxin-01 on 2020/7/29.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSGranaryVC.h"
#import "DSFetchRiceVC.h"
#import "DSGranary.h"

@interface DSGranaryVC ()
@property (nonatomic, strong) DSGranary *granary;
@property (weak, nonatomic) IBOutlet UILabel *millet;
@property (weak, nonatomic) IBOutlet UIButton *fetchBtn;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation DSGranaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F6F7"];
    [self setUpNavBar];
    [self startShimmer];
    [self getLandMilletRequest];
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"鲸宇粮仓"];
    
    self.hbd_barTintColor = [UIColor colorWithHexString:@"#4CB461"];
    self.hbd_barShadowHidden = YES;
}
- (IBAction)fetchRiceClicked:(UIButton *)sender {
    DSFetchRiceVC *rvc = [DSFetchRiceVC new];
    rvc.granary = self.granary;
    hx_weakify(self);
    rvc.fetchRiceCall = ^{
        hx_strongify(weakSelf);
        [strongSelf getLandMilletRequest];
    };
    [self.navigationController pushViewController:rvc animated:YES];
}
-(void)getLandMilletRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"land_millet_get" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"status"] integerValue] == 1) {
            strongSelf.granary = [DSGranary yy_modelWithDictionary:responseObject[@"result"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleGranaryData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)handleGranaryData
{
    self.millet.text = [NSString stringWithFormat:@"%@kg",self.granary.millet];
    if ([self.granary.millet floatValue] == 0) {
        self.fetchBtn.userInteractionEnabled = NO;
        self.fetchBtn.backgroundColor = UIColorFromRGB(0xEDEDED);
        [self.fetchBtn setTitleColor:UIColorFromRGB(0xCCCCCC) forState:UIControlStateNormal];
        self.time.text = @"";
    }else{
        self.fetchBtn.userInteractionEnabled = YES;
        self.fetchBtn.backgroundColor = UIColorFromRGB(0x48B664);
        [self.fetchBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        self.time.text = [NSString stringWithFormat:@"%@~%@可提",self.granary.start_time,self.granary.end_time];
    }
}
@end
