//
//  DSRefundDetailFooter.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSRefundDetailFooter.h"
#import "DSMyOrderDetail.h"

@interface DSRefundDetailFooter ()
@property (weak, nonatomic) IBOutlet UILabel *refund_name;
@property (weak, nonatomic) IBOutlet UILabel *refund_address;
@end
@implementation DSRefundDetailFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setOrderDetail:(DSMyOrderDetail *)orderDetail
{
    _orderDetail = orderDetail;
    
    self.refund_name.text = [NSString stringWithFormat:@"%@  %@",_orderDetail.refund_address.receiver,_orderDetail.refund_address.receiver_phone];
    self.refund_address.text = [NSString stringWithFormat:@"%@%@",_orderDetail.refund_address.area_name,_orderDetail.refund_address.address_detail];
}
@end
