//
//  DSMessageCell.m
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMessageCell.h"
#import "DSMessage.h"

@interface DSMessageCell ()
@property (weak, nonatomic) IBOutlet UIView *msgState;
@property (weak, nonatomic) IBOutlet UILabel *msgTitle;
@property (weak, nonatomic) IBOutlet UILabel *msgTime;

@end
@implementation DSMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setMsg:(DSMessage *)msg
{
    _msg = msg;
    self.msgState.hidden = [_msg.is_read isEqualToString:@"1"]?YES:NO;
    self.msgTitle.text = _msg.msg_title;
    self.msgTime.text = _msg.create_time;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
