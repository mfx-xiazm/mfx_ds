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

@end
@implementation DSDynamicDetailHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setInfo:(DSDynamicInfo *)info
{
    _info = info;
    
    [self.headPic sd_setImageWithURL:[NSURL URLWithString:_info.avatar]];
    self.nick.text = _info.nick_name;
    self.time.text = _info.create_time;
}
@end
