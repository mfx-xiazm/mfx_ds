//
//  DSMyBalanceCell.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMyBalanceCell.h"
#import "DSBalanceNote.h"

@interface DSMyBalanceCell ()
@property (weak, nonatomic) IBOutlet UIView *orderView;
@property (nonatomic, weak) IBOutlet UILabel *order_no;
@property (weak, nonatomic) IBOutlet UILabel *create_time;
@property (weak, nonatomic) IBOutlet UILabel *order_title;
@property (weak, nonatomic) IBOutlet UILabel *pay_amount;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *order_cmm;

@property (weak, nonatomic) IBOutlet UIView *otherView;
@property (weak, nonatomic) IBOutlet UILabel *finance_log_desc;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *amount1;

@end
@implementation DSMyBalanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setNote:(DSBalanceNote *)note
{
    _note = note;
  /**收入：1晋级奖励；2商品奖励；3分享奖励；4商品奖励；5礼包奖励；8提现申请驳回；9提现申请手续费驳回；支出：20提现申请提交扣除提现金额；21提现申请扣除手续费。2、3、4、5类型的有订单数据*/
    if ([_note.finance_log_type isEqualToString:@"2"] || [_note.finance_log_type isEqualToString:@"3"] || [_note.finance_log_type isEqualToString:@"4"] || [_note.finance_log_type isEqualToString:@"5"]) {
        self.orderView.hidden = NO;
        self.otherView.hidden = YES;
        
        self.order_no.text = [NSString stringWithFormat:@"订单编号：%@",_note.order_no];
        self.create_time.text = _note.create_time;
        if (_note.finance_log_desc && _note.finance_log_desc.length) {
            [self.order_title setTextWithLineSpace:3.f withString:[NSString stringWithFormat:@"%@-%@",_note.finance_log_desc,_note.order_title] withFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
        }else{
            [self.order_title setTextWithLineSpace:3.f withString:_note.order_title withFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
        }
        [self.pay_amount setFontAttributedText:[NSString stringWithFormat:@"实付：¥%@",[_note.pay_amount reviseString]] andChangeStr:@[@"实付：¥"] andFont:@[[UIFont systemFontOfSize:10]]];

        [self.num setFontAttributedText:[NSString stringWithFormat:@"x%@",_note.order_num] andChangeStr:@[@"x"] andFont:@[[UIFont systemFontOfSize:10]]];
        
        if ([_note.amount floatValue] == 0) {
            self.amount.text = [NSString stringWithFormat:@"%@",[_note.amount reviseString]];
        }else{
            if ([_note.amount containsString:@"-"]) {
                self.amount.text = [NSString stringWithFormat:@"%@",[_note.amount reviseString]];
            }else{
                [self.amount setFontAttributedText:[NSString stringWithFormat:@"¥%@",[_note.amount reviseString]] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:12]]];
            }
        }
        if ([_note.is_valid isEqualToString:@"1"]) {
           self.order_cmm.text = @"预计返佣";
           self.amount.textColor = HXControlBg;
        }else{
            self.order_cmm.text = @"订单失效";
            self.amount.textColor = UIColorFromRGB(0x333333);
        }
    }else{
        self.orderView.hidden = YES;
        self.otherView.hidden = NO;
        [self.finance_log_desc setTextWithLineSpace:3.f withString:_note.finance_log_desc withFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
        self.time.text = _note.create_time;
        if ([_note.amount floatValue] == 0) {
            self.amount1.text = [NSString stringWithFormat:@"%@",[_note.amount reviseString]];
        }else{
            if ([_note.amount containsString:@"-"]) {
                self.amount1.text = [NSString stringWithFormat:@"%@",[_note.amount reviseString]];
            }else{
                [self.amount1 setFontAttributedText:[NSString stringWithFormat:@"¥%@",[_note.amount reviseString]] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:12]]];
            }
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
