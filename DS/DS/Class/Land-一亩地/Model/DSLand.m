//
//  DSLand.m
//  DS
//
//  Created by huaxin-01 on 2020/8/3.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSLand.h"

@implementation DSLand
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"adv":[DSLandAdv class],
             @"land_goods":[DSLandGoods class],
             @"jgq":[DSLandAdv class]
             };
}
@end

@implementation DSLandAdv

@end

@implementation DSLandGoods

@end
