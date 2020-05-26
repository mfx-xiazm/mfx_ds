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
@property (weak, nonatomic) IBOutlet UILabel *payInfo;
@property (weak, nonatomic) IBOutlet UILabel *payInfo2;

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
    
//    if ([_orderDetail.order_type isEqualToString:@"1"]) {// 常规
//        self.normalView.hidden = NO;
//        self.normalViewHeight.constant = 80.f;
//    }else{//vip
//        self.normalView.hidden = YES;
//        self.normalViewHeight.constant = 0.f;
//    }
    // 参考上面注释代码，根据是否付款来设置高度
    if ([_orderDetail.status isEqualToString:@"待付款"] || [_orderDetail.status isEqualToString:@"已取消"]) {
        [self.payInfo setTextWithLineSpace:8.f withString:@"配送" withFont:[UIFont systemFontOfSize:12]];
        [self.payInfo2 setTextWithLineSpace:8.f withString:@"包邮" withFont:[UIFont systemFontOfSize:12]];
    }else{
        [self.payInfo setTextWithLineSpace:8.f withString:@"配送\n支付方式" withFont:[UIFont systemFontOfSize:12]];
        [self.payInfo2 setTextWithLineSpace:8.f withString:[NSString stringWithFormat:@"包邮\n%@",[_orderDetail.pay_type isEqualToString:@"1"]?@"支付宝支付":@"微信支付"] withFont:[UIFont systemFontOfSize:12]];
    }
    self.payInfo.textAlignment = NSTextAlignmentLeft;
    self.payInfo2.textAlignment = NSTextAlignmentRight;
    
    self.remarkViewHeight.constant = _orderDetail.remarkTextHeight;
    
    self.pay_amount.text = [NSString stringWithFormat:@"¥%@",[_orderDetail.pay_amount reviseString]];
    self.order_self_commission.text = [NSString stringWithFormat:@"¥%@",[_orderDetail.order_self_commission reviseString]];
    [self.remarks setTextWithLineSpace:5.f withString:_orderDetail.remarks withFont:[UIFont systemFontOfSize:12]];
    
    [self.order_no setTextWithLineSpace:8.f withString:[NSString stringWithFormat:@"订单编号：%@\n数量：x%zd\n邮费：0\n下单时间：%@",_orderDetail.order_no,_orderDetail.list_goods.count,_orderDetail.create_time] withFont:[UIFont systemFontOfSize:12]];
}
- (IBAction)orderNoCopy:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _orderDetail.order_no;
    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"复制成功"];
}
@end
