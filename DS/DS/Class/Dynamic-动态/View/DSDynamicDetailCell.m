//
//  DSDynamicDetailCell.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSDynamicDetailCell.h"
#import "DSDynamicDetail.h"

@implementation DSDynamicDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setContent:(DSDynamicContent *)content
{
    _content = content;
    if ([_content.content_type isEqualToString:@"2"]) {
        self.content_text.hidden = YES;
        self.content_img.hidden = NO;
        [self.content_img sd_setImageWithURL:[NSURL URLWithString:_content.content]];
    }else{
        self.content_text.hidden = NO;
        self.content_img.hidden = YES;
        [self.content_text setTextWithLineSpace:5.f withString:_content.content withFont:[UIFont systemFontOfSize:14]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
