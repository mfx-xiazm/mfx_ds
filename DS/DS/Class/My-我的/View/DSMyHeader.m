//
//  DSMyHeader.m
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMyHeader.h"

@interface DSMyHeader ()
@property (weak, nonatomic) IBOutlet UIImageView *head_pic;

@end
@implementation DSMyHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClicked)];
    [self.head_pic addGestureRecognizer:tap];
}
-(void)headClicked
{
    if (self.myHeaderBtnClickedCall) {
        self.myHeaderBtnClickedCall(6);
    }
}
- (IBAction)myHeaderBtnClicked:(UIButton *)sender {
    if (self.myHeaderBtnClickedCall) {
        self.myHeaderBtnClickedCall(sender.tag);
    }
}
@end
