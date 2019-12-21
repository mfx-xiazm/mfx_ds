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
@property (weak, nonatomic) IBOutlet UILabel *phone;

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
    self.phone.text = _team.phone;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
