//
//  DSTextField.m
//  DS
//
//  Created by huaxin-01 on 2020/5/26.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSTextField.h"

@implementation DSTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setPlaceholder:self.placeholder];
}
-(void)setPlaceholder:(NSString *)placeholder
{
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0x909090)}];
    self.attributedPlaceholder = placeholderString;
}
@end
