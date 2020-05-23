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
@property (weak, nonatomic) IBOutlet UILabel *sale_num;
@property (weak, nonatomic) IBOutlet UILabel *buy;
@property (weak, nonatomic) IBOutlet UILabel *stock;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end
@implementation DSVipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.buy.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buyClicked:)];
    [self.buy addGestureRecognizer:tap];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.buy bezierPathByRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(19, 19)];
}
-(void)setGoods:(DSVipGoods *)goods
{
    _goods = goods;
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_goods.cover_img]];
    [self.goodsName setTextWithLineSpace:5.f withString:_goods.goods_name withFont:[UIFont systemFontOfSize:14]];
    [self.price setFontAttributedText:[NSString stringWithFormat:@"¥%.2f",[_goods.price floatValue]] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:12]]];
    self.sale_num.text = [NSString stringWithFormat:@"已售出%@件",_goods.sale_num];
    self.stock.text = [NSString stringWithFormat:@"库存%@件",_goods.stock];
    self.progress.progress = [_goods.stock floatValue]/([_goods.sale_num integerValue] + [_goods.stock integerValue]);//进度=库存/(库存+销量)
}
- (void)buyClicked:(UITapGestureRecognizer *)tap {
    if (self.buyClickCall) {
        self.buyClickCall();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
