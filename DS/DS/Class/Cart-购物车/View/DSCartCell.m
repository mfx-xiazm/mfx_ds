//
//  DSCartCell.m
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSCartCell.h"
#import "DSCartData.h"

@interface DSCartCell ()
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *back_price;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *market_price;
@property (weak, nonatomic) IBOutlet UILabel *spec_value;
@property (weak, nonatomic) IBOutlet UILabel *cart_num;
@end
@implementation DSCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCart:(DSCartData *)cart
{
    _cart = cart;
    
    self.checkBtn.selected = _cart.is_checked;
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_cart.cover_img]];
    [self.goods_name setTextWithLineSpace:5.f withString:_cart.goods_name withFont:[UIFont systemFontOfSize:14]];
    
    [self.market_price setLabelUnderline:[NSString stringWithFormat:@"￥%.2f",[_cart.price floatValue]]];
    [self.price setFontAttributedText:[NSString stringWithFormat:@"￥%.2f",[_cart.discount_price floatValue]] andChangeStr:@"￥" andFont:[UIFont systemFontOfSize:12]];

    [self.back_price setFontAttributedText:[NSString stringWithFormat:@"返佣金额：￥%.2f",[_cart.cmm_price floatValue]] andChangeStr:@"￥" andFont:[UIFont systemFontOfSize:10]];

    if (_cart.specs_attrs && _cart.specs_attrs.length) {
        self.spec_value.text = [NSString stringWithFormat:@"规格：%@",_cart.specs_attrs];
    }else{
        self.spec_value.text = @"";
    }
    self.cart_num.text = _cart.cart_num;
}
- (IBAction)numChangeClicked:(UIButton *)sender {
    if (sender.tag) {// +
        if ([self.cart_num.text integerValue] + 1 > [_cart.stock integerValue]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"库存不足"];
            return;
        }
        self.cart_num.text = [NSString stringWithFormat:@"%zd",[self.cart_num.text integerValue] + 1];
    }else{// -
        if ([self.cart_num.text integerValue] - 1 < 1) {
            return;
        }
        self.cart_num.text = [NSString stringWithFormat:@"%zd",[self.cart_num.text integerValue] - 1];
    }
    _cart.cart_num = self.cart_num.text;
    if (self.cartHandleCall) {
        self.cartHandleCall(sender.tag);
    }
}
- (IBAction)checkClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    _cart.is_checked = sender.isSelected;
    if (self.cartHandleCall) {
        self.cartHandleCall(sender.tag);
    }
}
- (void)setFrame:(CGRect)frame{
    if (self.frame.size.height != frame.size.height) {
        frame.origin.y += 8;
        frame.size.height -= 16;
    }
    [super setFrame:frame];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
