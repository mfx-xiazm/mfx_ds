//
//  DSMyTeamHeader.m
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMyTeamHeader.h"

@interface DSMyTeamHeader ()
@property (weak, nonatomic) IBOutlet UIView *topTitleView;

@end
@implementation DSMyTeamHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = UIColorFromRGB(0xF9F9F9);
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.topTitleView bezierPathByRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8.f, 8.f)];
}
@end
