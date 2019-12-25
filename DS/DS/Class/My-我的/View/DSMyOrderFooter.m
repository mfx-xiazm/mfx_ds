//
//  DSMyOrderFooter.m
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMyOrderFooter.h"
#import "DSMyOrder.h"

@interface DSMyOrderFooter ()
@property (weak, nonatomic) IBOutlet UILabel *total_price;
@property (weak, nonatomic) IBOutlet UIButton *firstHandleBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondHandleBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdHandleBtn;

@end
@implementation DSMyOrderFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setOrder:(DSMyOrder *)order
{
    /**待付款-取消订单、立即支付  待发货-申请退款(vip订单不可退款) 待收货-申请退款(vip订单不可退款)、查看物流、确认收货*/
    _order = order;
    self.total_price.text = [NSString stringWithFormat:@"￥%.2f",[_order.pay_amount floatValue]];
    if ([_order.status isEqualToString:@"待付款"]) {
        self.firstHandleBtn.hidden = YES;
        
        self.secondHandleBtn.hidden = NO;
        [self.secondHandleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        self.secondHandleBtn.backgroundColor = [UIColor whiteColor];
        self.secondHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
        [self.secondHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.thirdHandleBtn.hidden = NO;
        [self.thirdHandleBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        self.thirdHandleBtn.backgroundColor = UIColorFromRGB(0xFF4D4D);
        self.thirdHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [self.thirdHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if ([_order.status isEqualToString:@"待发货"]) {
        self.firstHandleBtn.hidden = YES;
        
        self.secondHandleBtn.hidden = YES;
        
        if ([_order.order_type isEqualToString:@"1"]) {
            self.thirdHandleBtn.hidden = NO;
            [self.thirdHandleBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            self.thirdHandleBtn.backgroundColor = [UIColor whiteColor];
            self.thirdHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
            [self.thirdHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            self.thirdHandleBtn.hidden = YES;
        }
    }else if ([_order.status isEqualToString:@"待收货"]) {
        if ([_order.order_type isEqualToString:@"1"]) {
            self.firstHandleBtn.hidden = NO;
            [self.firstHandleBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            self.firstHandleBtn.backgroundColor = [UIColor whiteColor];
            self.firstHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
            [self.firstHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            self.firstHandleBtn.hidden = YES;
        }
        
        self.secondHandleBtn.hidden = NO;
        [self.secondHandleBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        self.secondHandleBtn.backgroundColor = [UIColor whiteColor];
        self.secondHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
        [self.secondHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.thirdHandleBtn.hidden = NO;
        [self.thirdHandleBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        self.thirdHandleBtn.backgroundColor = UIColorFromRGB(0xFF4D4D);
        self.thirdHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [self.thirdHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        self.firstHandleBtn.hidden = YES;
        
        self.secondHandleBtn.hidden = YES;
        
        self.thirdHandleBtn.hidden = YES;
    }
}
- (IBAction)orderHandleClicked:(UIButton *)sender {
    if (self.orderHandleCall) {
        self.orderHandleCall(sender.tag);
    }
}
@end
