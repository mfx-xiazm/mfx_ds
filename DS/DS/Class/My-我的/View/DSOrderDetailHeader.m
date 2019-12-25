//
//  DSOrderDetailHeader.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSOrderDetailHeader.h"
#import "DSMyOrderDetail.h"

@interface DSOrderDetailHeader ()
@property (weak, nonatomic) IBOutlet UILabel *order_status;
@property (weak, nonatomic) IBOutlet UILabel *order_desc;
@property (weak, nonatomic) IBOutlet UILabel *order_tip;
@property (weak, nonatomic) IBOutlet UILabel *logistics_name;
@property (weak, nonatomic) IBOutlet UILabel *logistics_no;
@property (weak, nonatomic) IBOutlet UILabel *receiver;
@property (weak, nonatomic) IBOutlet UILabel *receive_address;
@end
@implementation DSOrderDetailHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setOrderDetail:(DSMyOrderDetail *)orderDetail
{
    _orderDetail = orderDetail;
    if (!self.isAfterSale) {// 正常订单
        self.order_status.text = _orderDetail.status;
        if ([_orderDetail.status isEqualToString:@"已取消"]) {
            self.order_desc.text = @"您的订单已取消";
            self.order_tip.hidden = NO;
            self.order_tip.text = @"   订单已取消   ";
        }else if ([_orderDetail.status isEqualToString:@"待付款"]) {
            self.order_desc.text = @"您的订单待付款";
            self.order_tip.hidden = NO;
            self.order_tip.text = @"   订单待付款，请尽快付款   ";
        }else if ([_orderDetail.status isEqualToString:@"待发货"]) {
            self.order_desc.text = @"您的订单待发货";
            self.order_tip.hidden = NO;
            self.order_tip.text = @"   订单待发货，请耐心等待   ";
        }else if ([_orderDetail.status isEqualToString:@"待收货"]) {
            self.order_desc.text = @"您的订单已发货，请耐心等待";
            self.order_tip.hidden = YES;
            self.logistics_name.text = [NSString stringWithFormat:@"物流公司：%@",_orderDetail.logistics_com_name];
            self.logistics_no.text = [NSString stringWithFormat:@"物流单号：%@",_orderDetail.logistics_no];
        }else{
            self.order_desc.text = @"您的订单已完成，棒棒哒";
            self.order_tip.hidden = YES;
            self.logistics_name.text = [NSString stringWithFormat:@"物流公司：%@",_orderDetail.logistics_com_name];
            self.logistics_no.text = [NSString stringWithFormat:@"物流单号：%@",_orderDetail.logistics_no];
        }
    }else{//退款订单
        /**1申请中；2退货中(未发货没有此状态)；3退款完成；4退款失败*/
        if ([_orderDetail.refund_status isEqualToString:@"1"]) {
            self.order_status.text = @"申请中";
            self.order_desc.hidden = NO;
            self.order_desc.text = @"您的订单退款申请中";
            self.order_tip.hidden = NO;
            self.order_tip.text = @"   退款申请中，请耐心等待   ";
        }else if ([_orderDetail.refund_status isEqualToString:@"2"]){
            self.order_status.text = @"退款中";
            self.order_desc.hidden = NO;
            self.order_desc.text = @"您的订单正在退款中";
            self.order_tip.hidden = NO;
            self.order_tip.text = @"   申请已通过，订单退款中   ";
        }else if ([_orderDetail.refund_status isEqualToString:@"3"]){
            self.order_status.text = @"退款完成";
            self.order_desc.hidden = NO;
            self.order_desc.text = @"您的订单退款完成";
            self.order_tip.hidden = NO;
            self.order_tip.text = @"   您的订单退款完成   ";
        }else{
            self.order_status.text = @"退款失败";
            self.order_desc.hidden = NO;
            self.order_desc.text = @"您的订单退款失败";
            self.order_tip.hidden = NO;
            self.order_tip.text = @"   您的订单退款失败   ";
        }
    }
    
    self.receiver.text = [NSString stringWithFormat:@"%@  %@",_orderDetail.receiver,_orderDetail.receiver_phone];
    self.receive_address.text = [NSString stringWithFormat:@"%@%@",_orderDetail.area_name,_orderDetail.address_detail];
}
- (IBAction)lookLogisClicked:(UIButton *)sender {
    if (self.isAfterSale) {
        return;
    }
    if (_orderDetail.logistics_no && _orderDetail.logistics_no.length) {
        if (self.lookLogisCall) {
            self.lookLogisCall();
        }
    }
}
@end
