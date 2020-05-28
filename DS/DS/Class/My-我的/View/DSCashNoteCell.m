//
//  DSCashNoteCell.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSCashNoteCell.h"
#import "DSCashNote.h"

@interface DSCashNoteCell ()
@property (weak, nonatomic) IBOutlet UILabel *apply_no;
@property (weak, nonatomic) IBOutlet UILabel *apply_status;
@property (weak, nonatomic) IBOutlet UILabel *apply_desc;
@property (weak, nonatomic) IBOutlet UILabel *card_no;
@property (weak, nonatomic) IBOutlet UILabel *apply_amount;
@property (weak, nonatomic) IBOutlet UILabel *create_time;
@property (weak, nonatomic) IBOutlet UILabel *reject_reason;

@end
@implementation DSCashNoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setNote:(DSCashNote *)note
{
    _note = note;
    self.apply_no.text = NSStringFormat(@"提现编码：%@",_note.apply_no);
    if ([_note.apply_status isEqualToString:@"1"]) {
        self.apply_status.text = @"提现中";
        self.apply_status.textColor = HXControlBg;
        self.apply_amount.text = NSStringFormat(@"%@",[_note.apply_amount reviseString]);
        self.apply_amount.textColor = HXControlBg;
        self.reject_reason.textAlignment = NSTextAlignmentRight;
        self.reject_reason.text = @"到账延迟请耐心等待";
    }else if ([_note.apply_status isEqualToString:@"2"]){
        self.apply_status.text = @"已提现";
        self.apply_status.textColor = HXControlBg;
        self.apply_amount.text = NSStringFormat(@"+%@",[_note.apply_amount reviseString]);
        self.apply_amount.textColor = HXControlBg;
        self.reject_reason.textAlignment = NSTextAlignmentRight;
        self.reject_reason.text = @"";
    }else{
        self.apply_status.text = @"提现失败";
        self.apply_status.textColor = UIColorFromRGB(0x333333);
        self.apply_amount.text = NSStringFormat(@"+%@",[_note.apply_amount reviseString]);
        self.apply_amount.textColor = UIColorFromRGB(0x333333);
        self.reject_reason.textAlignment = NSTextAlignmentLeft;
        self.reject_reason.text = [NSString stringWithFormat:@"失败原因：%@",_note.reject_reason];
    }
    self.apply_desc.text = [_note.acct_type isEqualToString:@"1"]?[NSString stringWithFormat:@"%@-银行卡",_note.apply_desc]:[NSString stringWithFormat:@"%@-支付宝",_note.apply_desc];
    self.card_no.text = _note.card_no;
    self.create_time.text = _note.create_time;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
