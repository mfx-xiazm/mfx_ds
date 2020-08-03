//
//  DSLandCell.m
//  DS
//
//  Created by huaxin-01 on 2020/7/29.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSLandCell.h"
#import "DSLand.h"

@interface DSLandCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
@implementation DSLandCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.price bezierPathByRoundingCorners:UIRectCornerTopRight cornerRadii:CGSizeMake(17, 17)];
    });
}
-(void)setLandGood:(DSLandGoods *)landGood
{
    _landGood = landGood;
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_landGood.cover_img]];
    self.goods_name.text = _landGood.goods_name;
    if ([_landGood.is_nmj isEqualToString:@"1"]) {
        self.price.text = [NSString stringWithFormat:@"  ¥%@  ",_landGood.price];
    }else{
        [self.price setFontAttributedText:[NSString stringWithFormat:@"  ¥%@起  ",_landGood.price] andChangeStr:@[@"起"] andFont:@[[UIFont systemFontOfSize:14 weight:UIFontWeightLight]]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
