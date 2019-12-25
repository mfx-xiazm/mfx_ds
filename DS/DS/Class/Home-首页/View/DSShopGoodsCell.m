//
//  DSShopGoodsCell.m
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSShopGoodsCell.h"
#import "DSHomeData.h"

@interface DSShopGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *marketPrice;
@property (weak, nonatomic) IBOutlet UILabel *bankPrice;

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
    self.goodName.text = _recommend.goods_name;
    self.price.text = [NSString stringWithFormat:@"￥%.2f",[_recommend.discount_price floatValue]];
    [self.marketPrice setLabelUnderline:[NSString stringWithFormat:@"￥%.2f",[_recommend.price floatValue]]];
    self.bankPrice.text = [NSString stringWithFormat:@"返佣金额：%.2f",[_recommend.cmm_price floatValue]];
}
@end
