//
//  DSDynamicDetailHeader.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSDynamicDetailHeader.h"
#import "DSDynamicDetail.h"

@interface DSDynamicDetailHeader ()
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *nick;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *member_flag;

@end
@implementation DSDynamicDetailHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setInfo:(DSDynamicInfo *)info
{
    _info = info;
    
    [self.headPic sd_setImageWithURL:[NSURL URLWithString:_info.avatar] placeholderImage:HXGetImage(@"avatar")];
    self.nick.text = _info.nick_name;
    self.time.text = _info.create_time;
    self.member_flag.text = [NSString stringWithFormat:@" %@ ",_info.member_flag];
}
@end
