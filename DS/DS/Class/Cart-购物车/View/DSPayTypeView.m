//
//  DSPayTypeView.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSPayTypeView.h"

@interface DSPayTypeView ()
@property (weak, nonatomic) IBOutlet UIButton *wxPay;
@property (weak, nonatomic) IBOutlet UIButton *aliPay;
@property (weak, nonatomic) IBOutlet UILabel *payPrice;
/* 选中的那个支付方式 */
@property(nonatomic,strong) UIButton *selectPay;
@end
@implementation DSPayTypeView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.selectPay = self.aliPay;
}
-(void)setPay_amount:(NSString *)pay_amount
{
    _pay_amount = pay_amount;
    [self.payPrice setFontAttributedText:[NSString stringWithFormat:@"实付金额：¥%@",[_pay_amount reviseString]] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:10]]];
}
- (IBAction)payTypeClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        self.selectPay = self.aliPay;
        [self.aliPay setImage:HXGetImage(@"付款选中") forState:UIControlStateNormal];
        [self.wxPay setImage:nil forState:UIControlStateNormal];
    }else {
        self.selectPay = self.wxPay;
        [self.aliPay setImage:nil forState:UIControlStateNormal];
        [self.wxPay setImage:HXGetImage(@"付款选中") forState:UIControlStateNormal];
    }
}
- (IBAction)confirmPayClicked:(UIButton *)sender {
    if (sender.tag) {
        if (self.confirmPayCall) {
            self.confirmPayCall(self.selectPay.tag);
        }
    }else{
        if (self.confirmPayCall) {
            self.confirmPayCall(0);
        }
    }
}
@end
