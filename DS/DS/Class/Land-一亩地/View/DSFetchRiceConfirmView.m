//
//  DSFetchRiceConfirmView.m
//  DS
//
//  Created by huaxin-01 on 2020/7/29.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSFetchRiceConfirmView.h"

@implementation DSFetchRiceConfirmView

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)confirmBtnClicked:(UIButton *)sender {
    if (self.confirmBtnClickedCall) {
        self.confirmBtnClickedCall(sender.tag);
    }
}

@end
