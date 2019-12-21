//
//  DSMyCardCell.m
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMyCardCell.h"
#import "DSMyCard.h"

@interface DSMyCardCell ()
@property (nonatomic, weak) IBOutlet UILabel *order_no;
@property (nonatomic, weak) IBOutlet UIImageView *logo_img;
@property (nonatomic, weak) IBOutlet UILabel *card_code;
@property (nonatomic, weak) IBOutlet UILabel *deadline;
@property (nonatomic, weak) IBOutlet UILabel *product_name;
@end
@implementation DSMyCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCard:(DSMyCard *)card
{
    _card = card;
    
    self.product_name.text = _card.product_name;
    [self.logo_img sd_setImageWithURL:[NSURL URLWithString:_card.logo_img]];
    self.card_code.text = [NSString stringWithFormat:@"兑换码：%@",_card.card_code];
    self.deadline.text = [NSString stringWithFormat:@"截止时间：%@",_card.deadline];
    self.order_no.text = [NSString stringWithFormat:@"订单号：%@",_card.order_no];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
