//
//  DSUpCashView.m
//  DS
//
//  Created by huaxin-01 on 2020/5/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSUpCashView.h"

@implementation DSUpCashView

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)upCashClicked:(UIButton *)sender {
    if (self.upCashCall) {
        self.upCashCall(sender.tag);
    }
}

@end
