//
//  DSCateGoodsCell.m
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSCateGoodsCell.h"
#import "DSShopGoods.h"

@interface DSCateGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *marketPrice;
@property (weak, nonatomic) IBOutlet UILabel *bankPrice;
@property (weak, nonatomic) IBOutlet UILabel *coupon_amount;
@property (weak, nonatomic) IBOutlet UIImageView *coupon_img;

@end
@implementation DSCateGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setGoods:(DSShopGoods *)goods
{
    _goods = goods;
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:_goods.cover_img]];
    [self.goodName addFlagLabelWithName:_goods.cate_flag lineSpace:3.f titleString:_goods.goods_name withFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15]];
    [self.price setFontAttributedText:[NSString stringWithFormat:@"¥%@",[_goods.discount_price reviseString]] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:12]]];
    [self.marketPrice setLabelUnderline:[NSString stringWithFormat:@"¥%@",[_goods.price reviseString]]];
    [self.bankPrice setFontAttributedText:[NSString stringWithFormat:@"  现金补贴¥%@  ",[_goods.cmm_price reviseString]] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:8]]];
    if ([_goods.coupon_amount floatValue] == 0) {
        self.coupon_img.hidden = YES;
        self.coupon_amount.hidden = YES;
    }else{
        self.coupon_img.hidden = NO;
        self.coupon_amount.hidden = NO;
        self.coupon_amount.text = [NSString stringWithFormat:@"  %@元券  ",_goods.coupon_amount];
    }

}
- (IBAction)collectClicked:(UIButton *)sender {
    if (self.collectActionCall) {
        self.collectActionCall();
    }
}

@end
