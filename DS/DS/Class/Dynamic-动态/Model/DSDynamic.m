//
//  DSDynamic.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSDynamic.h"

@implementation DSDynamic
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"portrait":@"avatar",
             @"nick":@"nick_name",
             @"dsp":@"treads_title",
             @"creatTime":@"create_time"
    };
}
-(void)setList_content:(NSArray *)list_content
{
    _list_content = list_content;
    if (_list_content.count) {
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dict in _list_content) {
            [temp addObject:dict[@"content"]];
        }
        _photos = [NSArray arrayWithArray:temp];
    }else{
        _photos = @[];
    }
}

@end
