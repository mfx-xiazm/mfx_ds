//
//  DSVipCardCell.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSVipCardCell.h"
#import "DSVipCard.h"

@interface DSVipCardCell ()
@property (weak, nonatomic) IBOutlet UILabel *cardName;
@property (weak, nonatomic) IBOutlet UIImageView *card_logo;

@end
@implementation DSVipCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCard:(DSVipCard *)card
{
    _card = card;
    self.cardName.text = _card.type_name;
    [self.card_logo sd_setImageWithURL:[NSURL URLWithString:_card.logo_img]];
}
@end
