//
//  DSVipCardDetailCell.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSVipCardDetailCell.h"
#import "DSVipCardDetail.h"

@interface DSVipCardDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *priceText;

@end
@implementation DSVipCardDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setPrice:(DSVipCardPrice *)price
{
    _price = price;
    self.priceText.text = [NSString stringWithFormat:@"%@元",[_price.face_value reviseString]];
    if (_price.isSelected) {
        self.priceText.backgroundColor = UIColorFromRGB(0xFFBC66);
        self.priceText.layer.borderColor = [UIColor clearColor].CGColor;
    }else{
        self.priceText.backgroundColor = [UIColor whiteColor];
        self.priceText.layer.borderColor = UIColorFromRGB(0xFFBC66).CGColor;
    }
}
@end
