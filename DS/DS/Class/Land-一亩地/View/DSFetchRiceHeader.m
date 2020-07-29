//
//  DSFetchRiceHeader.m
//  DS
//
//  Created by huaxin-01 on 2020/7/29.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSFetchRiceHeader.h"

@implementation DSFetchRiceHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)addressClicked:(UIButton *)sender {
    if (self.addressClickedCall) {
        self.addressClickedCall();
    }
}

@end
