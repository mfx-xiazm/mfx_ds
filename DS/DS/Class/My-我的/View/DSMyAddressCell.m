//
//  DSMyAddressCell.m
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMyAddressCell.h"
#import "DSMyAddress.h"

@interface DSMyAddressCell ()
@property (weak, nonatomic) IBOutlet UIView *leftLine;
@property (weak, nonatomic) IBOutlet UILabel *receiver;
@property (weak, nonatomic) IBOutlet UILabel *receiver_phone;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *is_defalt;
@end
@implementation DSMyAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.leftLine bezierPathByRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    });
}
-(void)setAddress:(DSMyAddress *)address
{
    _address = address;
    self.receiver.text = _address.receiver;
    self.receiver_phone.text = _address.receiver_phone;
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@",_address.area_name,_address.address_detail];
    self.is_defalt.hidden = !_address.is_default;
}
- (IBAction)editClicked:(UIButton *)sender {
    if (self.addressClickedCall) {
        self.addressClickedCall(sender.tag);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
