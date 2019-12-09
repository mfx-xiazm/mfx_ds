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
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.topTitleView bezierPathByRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5.f, 5.f)];
}
@end
