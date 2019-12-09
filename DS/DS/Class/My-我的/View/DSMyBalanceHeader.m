//
//  DSMyBalanceHeader.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMyBalanceHeader.h"

@implementation DSMyBalanceHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)balanceHeaderClicked:(UIButton *)sender {
    if (self.balanceBtnCall) {
        self.balanceBtnCall(sender.tag);
    }
}

@end
