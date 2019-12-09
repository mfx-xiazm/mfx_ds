//
//  DSEditAddressVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSEditAddressVC.h"
#import "HXPlaceholderTextView.h"

@interface DSEditAddressVC ()
@property (weak, nonatomic) IBOutlet UIView *addressDetailView;
/* 详细地址 */
@property(nonatomic,strong) HXPlaceholderTextView *address;
@end

@implementation DSEditAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:@"新增编辑"];
    [self.addressDetailView addSubview:self.address];
}
-(HXPlaceholderTextView *)address
{
    if (_address == nil) {
        _address = [[HXPlaceholderTextView alloc] initWithFrame:self.addressDetailView.bounds];
        _address.placeholder = @"请输入详细地址";
    }
    return _address;
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.address.frame = self.addressDetailView.bounds;
}
#pragma mark -- 点击事件
- (IBAction)addressClicked:(UIButton *)sender {
    
}

@end
