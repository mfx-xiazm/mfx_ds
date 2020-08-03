//
//  DSLandDetail.m
//  DS
//
//  Created by huaxin-01 on 2020/8/3.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSLandDetail.h"

@implementation DSLandDetail
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goods_adv":[DSLandGoodsAdv class],
             @"goods_sku":[DSLandGoodsSku class],
             @"list_specs":[DSLandGoodsSpecs class]
             };
}
@end

@implementation DSLandGoodsAdv

@end

@implementation DSLandGoodsSku

@end

@implementation DSLandGoodsSpecs
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
            @"list_attrs":[DSLandGoodsAttrs class]
             };
}
@end


@implementation DSLandGoodsAttrs

@end
