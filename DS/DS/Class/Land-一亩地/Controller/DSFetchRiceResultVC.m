//
//  DSFetchRiceResultVC.m
//  DS
//
//  Created by huaxin-01 on 2020/7/29.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSFetchRiceResultVC.h"
#import "DSMyOrderVC.h"

@interface DSFetchRiceResultVC ()

@end

@implementation DSFetchRiceResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
}
-(void)setUpNavBar
{
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_barTintColor = HXGlobalBg;
    self.hbd_tintColor = [UIColor blackColor];
    self.hbd_barShadowHidden = YES;
    self.hbd_titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName: [UIColor.blackColor colorWithAlphaComponent:1.0]};
    [self.navigationItem setTitle:@"提粮"];
}
- (IBAction)lookOrderClicked:(UIButton *)sender 
{
    // 直接跳转到订单列表
    DSMyOrderVC *ovc = [DSMyOrderVC new];
    [self.navigationController pushViewController:ovc animated:YES];
}
@end
