//
//  DSGranaryVC.m
//  DS
//
//  Created by huaxin-01 on 2020/7/29.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSGranaryVC.h"
#import "DSFetchRiceVC.h"

@interface DSGranaryVC ()

@end

@implementation DSGranaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F6F7"];
    [self setUpNavBar];
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"鲸宇粮仓"];
    
    self.hbd_barTintColor = [UIColor colorWithHexString:@"#4CB461"];
    self.hbd_barShadowHidden = YES;
}
- (IBAction)fetchRiceClicked:(UIButton *)sender {
    DSFetchRiceVC *rvc = [DSFetchRiceVC new];
    [self.navigationController pushViewController:rvc animated:YES];
}

@end
