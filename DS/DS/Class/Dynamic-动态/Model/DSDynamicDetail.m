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

@end
