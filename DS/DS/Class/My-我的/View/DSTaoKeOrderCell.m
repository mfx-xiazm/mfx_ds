//
//  DSTaoKeOrderCell.m
//  DS
//
//  Created by huaxin-01 on 2020/4/7.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSTaoKeOrderCell.h"
#import "DSTaoKeOrder.h"

@interface DSTaoKeOrderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *order_title;
@property (weak, nonatomic) IBOutlet UILabel *pay_amount;
@property (weak, nonatomic) IBOutlet UILabel *pay_time;
@property (weak, nonatomic) IBOutlet UILabel *order_no;
@property (weak, nonatomic) IBOutlet UILabel *order_num;
@property (weak, nonatomic) IBOutlet UILabel *order_self_commission;
@property (weak, nonatomic) IBOutlet UILabel *commission_tip;
@property (weak, nonatomic) IBOutlet UILabel *tip;
@end
@implementation DSTaoKeOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setOrderGoods:(DSTaoKeOrder *)orderGoods
{
    _orderGoods = orderGoods;
    
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_orderGoods.cover_img]];
    [self.order_title addFlagLabelWithName:_orderGoods.cate_flag lineSpace:3.f titleString:_orderGoods.order_title withFont:[UIFont systemFontOfSize:13]];
    [self.pay_amount setFontAttributedText:[NSString stringWithFormat:@"¥%.2f",[_orderGoods.pay_amount floatValue]] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:10]]];
    [self.order_num setFontAttributedText:[NSString stringWithFormat:@"x%@",_orderGoods.order_num] andChangeStr:@[@"x"] andFont:@[[UIFont systemFontOfSize:8]]];

    self.pay_time.text = [NSString stringWithFormat:@"付款时间：%@",_orderGoods.pay_time];
    self.order_no.text = [NSString stringWithFormat:@"订单编号：%@",_orderGoods.order_no];
    [self.order_self_commission setFontAttributedText:[NSString stringWithFormat:@"¥%.2f",[_orderGoods.order_self_commission floatValue]] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:12]]];
    if ([_orderGoods.tab_status isEqualToString:@"待结算"]) {
        self.commission_tip.textColor = UIColorFromRGB(0x333333);
        self.order_self_commission.textColor = HXControlBg;
        self.tip.text = @"(已付款，确认收货后次月25号可提现)";
    }else if ([_orderGoods.tab_status isEqualToString:@"已结算"]) {
        self.commission_tip.textColor = UIColorFromRGB(0x333333);
        self.order_self_commission.textColor = HXControlBg;
        self.tip.text = @"(已结算，可提现)";
    }else {
        self.commission_tip.textColor = UIColorFromRGB(0x7F7F7F);
        self.order_self_commission.textColor = UIColorFromRGB(0x7F7F7F);
        self.tip.text = @"(订单已失效，无法获得佣金)";
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
