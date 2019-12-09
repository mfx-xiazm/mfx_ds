//
//  DSUpOrderFooter.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSUpOrderFooter.h"
#import "HXPlaceholderTextView.h"

@interface DSUpOrderFooter ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *remark_view;
@property (strong, nonatomic) HXPlaceholderTextView *remark;
@end
@implementation DSUpOrderFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.remark = [[HXPlaceholderTextView alloc] initWithFrame:CGRectMake(10, 10, HX_SCREEN_WIDTH-20, self.remark_view.hxn_height-20)];
    self.remark.layer.cornerRadius = 5.f;
    self.remark.layer.masksToBounds = YES;
    self.remark.placeholder = @"备注：";
    self.remark.delegate = self;
    self.remark.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.remark_view addSubview:self.remark];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.remark.frame = CGRectMake(10, 10, HX_SCREEN_WIDTH-20, self.remark_view.hxn_height-20);
}
@end
