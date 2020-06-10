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
@property (weak, nonatomic) IBOutlet UIImageView *msg_img;
@property (weak, nonatomic) IBOutlet UILabel *msg_content;

@end
@implementation DSMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setMsg:(DSMessage *)msg
{
    _msg = msg;
    // 1系统消息(后台发送)；2业务消息(动态)；3邀请好友通知；4提现通知
    if ([_msg.msg_type isEqualToString:@"3"]) {
        self.msg_img.image = HXGetImage(@"邀icon");
    }else if ([_msg.msg_type isEqualToString:@"4"]) {
        self.msg_img.image = HXGetImage(@"提icon");
    }else {
        self.msg_img.image = HXGetImage(@"消icon");
    }
    self.msgState.hidden = [_msg.is_read isEqualToString:@"1"]?YES:NO;
    self.msgTitle.text = _msg.msg_title;
    self.msg_content.text = _msg.msg_content;
    self.msgTime.text = _msg.create_time;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
