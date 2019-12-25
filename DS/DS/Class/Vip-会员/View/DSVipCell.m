//
//  DSVipCell.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSVipCell.h"
#import "DSVipGoods.h"

@interface DSVipCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
@implementation DSVipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setGoods:(DSVipGoods *)goods
{
    _goods = goods;
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_goods.cover_img]];
    self.goodsName.text = _goods.goods_name;
    self.price.text = [NSString stringWithFormat:@"￥%.2f",[_goods.price floatValue]];
}
- (IBAction)buyClicked:(UIButton *)sender {
    if (self.buyClickCall) {
        self.buyClickCall();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
