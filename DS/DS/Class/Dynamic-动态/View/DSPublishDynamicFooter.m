//
//  DSPublishDynamicFooter.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSPublishDynamicFooter.h"

@implementation DSPublishDynamicFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)footerClicked:(UIButton *)sender {
    if (self.footerHandleCall) {
        self.footerHandleCall(sender.tag);
    }
}


@end
