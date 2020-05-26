//
//  DSShopGoodsCell.m
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSShopGoodsCell.h"
#import "DSHomeData.h"
#import "DSShopGoods.h"

@interface DSShopGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *marketPrice;
@property (weak, nonatomic) IBOutlet UILabel *bankPrice;
@property (weak, nonatomic) IBOutlet UILabel *coupon_amount;

@end
@implementation DSShopGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setRecommend:(DSHomeRecommend *)recommend
{
    _recommend = recommend;
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:_recommend.cover_img]];
    [self.goodName addFlagLabelWithName:_recommend.cate_flag lineSpace:5.f titleString:_recommend.goods_name withFont:[UIFont systemFontOfSize:14]];
    [self.price setFontAttributedText:[NSString stringWithFormat:@"¥%@",[_recommend.discount_price reviseString]] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:12]]];
    [self.marketPrice setLabelUnderline:[NSString stringWithFormat:@"¥%@",[_recommend.price reviseString]]];
    [self.bankPrice setFontAttributedText:[NSString stringWithFormat:@"  现金补贴¥%@  ",[_recommend.cmm_price reviseString]] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:10]]];
}
-(void)setGoods:(DSShopGoods *)goods
{
    _goods = goods;
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:_goods.cover_img]];
    [self.goodName addFlagLabelWithName:_goods.cate_flag lineSpace:3.f titleString:_goods.goods_name withFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15]];
    [self.price setFontAttributedText:[NSString stringWithFormat:@"¥%@",[_goods.discount_price reviseString]] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:12]]];
    [self.marketPrice setLabelUnderline:[NSString stringWithFormat:@"¥%@",[_goods.price reviseString]]];
    [self.bankPrice setFontAttributedText:[NSString stringWithFormat:@"  现金补贴¥%@  ",[_goods.cmm_price reviseString]] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:10]]];
    self.coupon_amount.text = [NSString stringWithFormat:@"  %@元券  ",_goods.coupon_amount];
}
@end
