//
//  DSMyTeamCell.m
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMyTeamCell.h"
#import "DSMyTeam.h"

@interface DSMyTeamCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end
@implementation DSMyTeamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setTeam:(DSMyTeam *)team
{
    _team = team;
    self.name.text = _team.nick_name;
    self.time.text = _team.create_time;
//    self.ymd_leader_level.text = [NSString stringWithFormat:@"  %@  ",_team.ymd_leader_level];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
//    self.ymd_leader_level.backgroundColor = [UIColor mfx_gradientFromColors:@[UIColorFromRGB(0xC1A289),UIColorFromRGB(0xA47F63)] gradientType:GradientTypeLeftToRight imgSize:self.ymd_leader_level.hxn_size];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
