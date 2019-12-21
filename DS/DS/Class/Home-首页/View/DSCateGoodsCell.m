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
    self.goodName.text = _goods.goods_name;
    self.price.text = [NSString stringWithFormat:@"￥%@",_goods.price];
    self.marketPrice.text = [NSString stringWithFormat:@"￥%@",_goods.discount_price];
    self.bankPrice.text = [NSString stringWithFormat:@"返佣金额：%@",_goods.cmm_price];
}
@end
