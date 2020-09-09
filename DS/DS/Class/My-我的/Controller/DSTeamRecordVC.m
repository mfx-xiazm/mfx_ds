//
//  DSTeamRecordVC.m
//  DS
//
//  Created by huaxin-01 on 2020/9/9.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSTeamRecordVC.h"

@interface DSTeamRecordVC ()

@end

@implementation DSTeamRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
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

@end
