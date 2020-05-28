//
//  DSUpCashView.m
//  DS
//
//  Created by huaxin-01 on 2020/5/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSUpCashView.h"

@interface DSUpCashView ()

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end
@implementation DSUpCashView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.sureBtn.layer addSublayer:[UIColor setGradualChangingColor:self.sureBtn fromColor:@"F9AD28" toColor:@"F95628"]];
}
- (IBAction)upCashClicked:(UIButton *)sender {
    if (self.upCashCall) {
        self.upCashCall(sender.tag);
    }
}

@end
