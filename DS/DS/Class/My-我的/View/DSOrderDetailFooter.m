//
//  DSOrderDetailFooter.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSOrderDetailFooter.h"
#import "DSMyOrderDetail.h"

@interface DSOrderDetailFooter ()
@property (weak, nonatomic) IBOutlet UILabel *pay_amount;
@property (weak, nonatomic) IBOutlet UILabel *freight_amount;
@property (weak, nonatomic) IBOutlet UILabel *order_self_commission;
@property (weak, nonatomic) IBOutlet UILabel *remarks;
@property (weak, nonatomic) IBOutlet UILabel *order_no;
@property (weak, nonatomic) IBOutlet UIView *normalView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *normalViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkViewHeight;

@end
@implementation DSOrderDetailFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setOrderDetail:(DSMyOrderDetail *)orderDetail
{
    _orderDetail = orderDetail;
    
    if ([_orderDetail.order_type isEqualToString:@"1"]) {// 常规
        self.normalView.hidden = NO;
        self.normalViewHeight.constant = 80.f;
    }else{//vip
        self.normalView.hidden = YES;
        self.normalViewHeight.constant = 0.f;
    }
    self.remarkViewHeight.constant = _orderDetail.remarkTextHeight;
    
    self.pay_amount.text = [NSString stringWithFormat:@"￥%@",_orderDetail.pay_amount];
    self.order_self_commission.text = [NSString stringWithFormat:@"￥%@",_orderDetail.order_self_commission];
    [self.remarks setTextWithLineSpace:5.f withString:_orderDetail.remarks withFont:[UIFont systemFontOfSize:13]];
    [self.order_no setTextWithLineSpace:5.f withString:[NSString stringWithFormat:@"订单编号：%@\n下单时间：%@",_orderDetail.order_no,_orderDetail.create_time] withFont:[UIFont systemFontOfSize:13]];
}
- (IBAction)orderNoCopy:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _orderDetail.order_no;
    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"复制成功"];
}
@end
