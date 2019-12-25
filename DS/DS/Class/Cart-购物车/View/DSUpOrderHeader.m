//
//  DSUpOrderHeader.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSUpOrderHeader.h"
#import "DSMyAddress.h"

@interface DSUpOrderHeader ()
@property (weak, nonatomic) IBOutlet UILabel *receiver;
@property (weak, nonatomic) IBOutlet UILabel *receiver_phone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *is_default;
@end
@implementation DSUpOrderHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setDefaultAddress:(DSMyAddress *)defaultAddress
{
    _defaultAddress = defaultAddress;
    self.receiver.text = _defaultAddress.receiver;
    self.receiver_phone.text = _defaultAddress.receiver_phone;
    self.address.text = [NSString stringWithFormat:@"%@%@",_defaultAddress.area_name,_defaultAddress.address_detail];
    self.is_default.hidden = _defaultAddress.is_default?NO:YES;
}
- (IBAction)addressClicked:(UIButton *)sender {
    if (self.addressClickedCall) {
        self.addressClickedCall();
    }
}

@end
