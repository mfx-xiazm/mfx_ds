//
//  DSMyOrderHeader.m
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMyOrderHeader.h"
#import "DSMyOrder.h"

@interface DSMyOrderHeader ()
@property (weak, nonatomic) IBOutlet UILabel *order_no;
@property (weak, nonatomic) IBOutlet UILabel *order_state;
@end
@implementation DSMyOrderHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setOrder:(DSMyOrder *)order
{
    _order = order;
    self.order_no.text = [NSString stringWithFormat:@"订单编号：%@",_order.order_no];
    self.order_state.text = _order.status;
}
@end
