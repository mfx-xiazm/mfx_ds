//
//  DSFetchRiceHeader.m
//  DS
//
//  Created by huaxin-01 on 2020/7/29.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSFetchRiceHeader.h"
#import "DSGranary.h"
#import "DSMyAddress.h"

@interface DSFetchRiceHeader ()
@property (weak, nonatomic) IBOutlet UILabel *millet;
@property (weak, nonatomic) IBOutlet UILabel *receiver;
@property (weak, nonatomic) IBOutlet UILabel *receiver_phone;
@property (weak, nonatomic) IBOutlet UILabel *address_detail;
@property (weak, nonatomic) IBOutlet UILabel *min_pick_num;

@end
@implementation DSFetchRiceHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setGranary:(DSGranary *)granary
{
    _granary = granary;
    self.millet.text = [NSString stringWithFormat:@"粮票(张): %zd",_granary.millet];
    if (_granary.address) {
        self.noAddressView.hidden = YES;
        self.addressView.hidden = NO;
        self.receiver.text = _granary.address.receiver;
        self.receiver_phone.text = _granary.address.receiver_phone;
        [self.address_detail setTextWithLineSpace:3.f withString:[NSString stringWithFormat:@"%@%@",_granary.address.area_name,_granary.address.address_detail] withFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    }else{
        self.noAddressView.hidden = NO;
        self.addressView.hidden = YES;
    }
//    self.min_pick_num.text = [NSString stringWithFormat:@"（每次提粮总重量不能低于%@kg）",_granary.min_pick_num];
    self.min_pick_num.text = @"";
}
- (IBAction)addressClicked:(UIButton *)sender {
    if (self.addressClickedCall) {
        self.addressClickedCall();
    }
}

@end
