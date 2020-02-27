//
//  DSUpOrderFooter.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSUpOrderFooter.h"
#import "HXPlaceholderTextView.h"
#import "DSConfirmOrder.h"

@interface DSUpOrderFooter ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *remark_view;
@property (weak, nonatomic) IBOutlet UILabel *cmm_amount;
@property (weak, nonatomic) IBOutlet UILabel *price_amount;
@property (weak, nonatomic) IBOutlet UILabel *freight_amount;
@property (strong, nonatomic) HXPlaceholderTextView *remark;
@end
@implementation DSUpOrderFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.remark = [[HXPlaceholderTextView alloc] initWithFrame:CGRectMake(10, 10, HX_SCREEN_WIDTH-20, self.remark_view.hxn_height-20)];
    self.remark.layer.cornerRadius = 5.f;
    self.remark.layer.masksToBounds = YES;
    self.remark.placeholder = @"备注请留言";
    self.remark.delegate = self;
    self.remark.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.remark_view addSubview:self.remark];
}
-(void)setConfirmOrder:(DSConfirmOrder *)confirmOrder
{
    _confirmOrder = confirmOrder;
    self.price_amount.text = [NSString stringWithFormat:@"￥%.2f",[_confirmOrder.price_amount floatValue]];
    self.cmm_amount.text = [NSString stringWithFormat:@"￥%.2f",[_confirmOrder.cmm_amount floatValue]];
    if (_confirmOrder.remark && _confirmOrder.remark.length) {
        self.remark.text = _confirmOrder.remark;
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView hasText]) {
        _confirmOrder.remark = textView.text;
    }else{
        _confirmOrder.remark = @"";
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.remark.frame = CGRectMake(10, 10, HX_SCREEN_WIDTH-20, self.remark_view.hxn_height-20);
}
@end
