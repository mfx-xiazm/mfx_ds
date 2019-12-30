//
//  SZUpdateView.m
//  STHZ
//
//  Created by hxrc on 2019/2/25.
//  Copyright © 2019 xzm. All rights reserved.
//

#import "SZUpdateView.h"

@implementation SZUpdateView

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)updateHandleClicked:(UIButton *)sender {
    if (self.updateClickedCall) {
        self.updateClickedCall(sender.tag);
    }
}


@end
