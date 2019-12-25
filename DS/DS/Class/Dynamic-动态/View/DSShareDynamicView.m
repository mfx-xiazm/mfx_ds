//
//  DSShareDynamicView.m
//  DS
//
//  Created by 夏增明 on 2019/12/25.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSShareDynamicView.h"

@implementation DSShareDynamicView

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)shareClicked:(UIButton *)sender {
    if (self.shareTypeActionCall) {
        self.shareTypeActionCall(sender.tag);
    }
}


@end
