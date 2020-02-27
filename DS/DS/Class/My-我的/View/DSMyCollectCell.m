//
//  DSMyCollectCell.m
//  DS
//
//  Created by 夏增明 on 2020/2/17.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSMyCollectCell.h"
#import "DSShopGoods.h"

@interface DSMyCollectCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *marketPrice;
@end
@implementation DSMyCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setGoods:(DSShopGoods *)goods
{
    _goods = goods;
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:_goods.cover_img]];
    [self.goodName setTextWithLineSpace:3.f withString:_goods.goods_name withFont:[UIFont systemFontOfSize:13]];
    [self.price setFontAttributedText:[NSString stringWithFormat:@"￥%.2f",[_goods.discount_price floatValue]] andChangeStr:@"￥" andFont:[UIFont systemFontOfSize:12]];
    [self.marketPrice setLabelUnderline:[NSString stringWithFormat:@"￥%.2f",[_goods.price floatValue]]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
