//
//  DSVipHeader.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSVipHeader.h"

@implementation DSVipHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)headerClicked:(UIButton *)sender {
    if (self.vipHeaderBtnClickedCall) {
        self.vipHeaderBtnClickedCall(sender.tag);
    }
}

@end
