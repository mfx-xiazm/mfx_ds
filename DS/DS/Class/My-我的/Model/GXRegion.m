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
    return @{@"city":[GXRegionCity class]
             };
}
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"ID":@"id"};
}

@end
@implementation GXRegionCity
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"area":[GXRegionArea class]
             };
}
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"ID":@"id"};
}
@end
@implementation GXRegionArea
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"ID":@"id"};
}
@end
