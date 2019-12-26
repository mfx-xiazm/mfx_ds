//
//  DSDynamicDetail.m
//  DS
//
//  Created by 夏增明 on 2019/12/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSDynamicDetail.h"

@implementation DSDynamicDetail
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"treads":[DSDynamicInfo class],
             @"list_content":[DSDynamicContent class]
             };
}
@end

@implementation DSDynamicInfo

@end

@implementation DSDynamicContent
-(CGFloat)textHeight
{
    if ([_content_type isEqualToString:@"1"]) {
        CGFloat textHeight = [_content textHeightSize:CGSizeMake(HX_SCREEN_WIDTH-10.f*2, CGFLOAT_MAX) font:[UIFont systemFontOfSize:14] lineSpacing:5.f];
        return 5.f+textHeight+5.f;
    }
    return 0.f;
}
@end
