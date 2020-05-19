//
//  DSUserAuthView.m
//  DS
//
//  Created by huaxin-01 on 2020/5/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSUserAuthView.h"

@interface DSUserAuthView ()
@property (weak, nonatomic) IBOutlet UIButton *authBtn;

@end
@implementation DSUserAuthView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.authBtn.layer addSublayer:[UIColor setGradualChangingColor:self.authBtn fromColor:@"F9AD28" toColor:@"F95628"]];
}
- (IBAction)authClicked:(UIButton *)sender {
    if (self.userAuthCall) {
        self.userAuthCall(sender.tag);
    }
}

@end
