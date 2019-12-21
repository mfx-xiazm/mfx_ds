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
@property (weak, nonatomic) IBOutlet UILabel *apply_amount;
@property (weak, nonatomic) IBOutlet UILabel *create_time;
@end
@implementation DSCashNoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setNote:(DSCashNote *)note
{
    _note = note;
    self.apply_no.text = NSStringFormat(@"申请单号：%@",_note.apply_no);
    if ([_note.apply_status isEqualToString:@"1"]) {
        self.apply_status.text = @"待审核";
    }else if ([_note.apply_status isEqualToString:@"2"]){
        self.apply_status.text = @"已通过";
    }else{
        self.apply_status.text = @"已驳回";
    }
    self.apply_desc.text = _note.apply_desc;
    self.create_time.text = _note.create_time;
    self.apply_amount.text = NSStringFormat(@"-￥%@",_note.apply_amount);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
