//
//  DSVipCardDetail.m
//  DS
//
//  Created by 夏增明 on 2019/12/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSVipCardDetail.h"

@implementation DSVipCardDetail
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"card_type":[DSVipCardInfo class],
             @"list":[DSVipCardPrice class]
             };
}
@end

@implementation DSVipCardInfo

@end

@implementation DSVipCardPrice

@end
