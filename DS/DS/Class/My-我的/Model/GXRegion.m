//
//  GXRegionArea.m
//  GX
//
//  Created by 夏增明 on 2019/10/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXRegion.h"

@implementation GXRegion
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"children":[GXRegionCity class]
             };
}
@end

@implementation GXRegionCity
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"children":[GXRegionArea class]
             };
}
@end

@implementation GXRegionArea
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"children":[GXRegionDistrict class]
             };
}
@end

@implementation GXRegionDistrict

@end
