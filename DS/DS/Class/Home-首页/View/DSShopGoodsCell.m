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
    [self.goodName addFlagLabelWithName:_recommend.cate_flag lineSpace:5.f titleString:_recommend.goods_name withFont:[UIFont systemFontOfSize:14]];
    [self.price setFontAttributedText:[NSString stringWithFormat:@"￥%.2f",[_recommend.discount_price floatValue]] andChangeStr:@"￥" andFont:[UIFont systemFontOfSize:12]];
    [self.marketPrice setLabelUnderline:[NSString stringWithFormat:@"￥%.2f",[_recommend.price floatValue]]];
    [self.bankPrice setFontAttributedText:[NSString stringWithFormat:@"现金补贴￥%.2f",[_recommend.cmm_price floatValue]] andChangeStr:@"￥" andFont:[UIFont systemFontOfSize:8]];
}
@end
