//
//  DSGoodsDetail.m
//  DS
//
//  Created by 夏增明 on 2019/12/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSGoodsDetail.h"

@implementation DSGoodsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goods_adv":[DSGoodsAdv class],
             @"goods_sku":[DSGoodsSku class],
             @"list_specs":[DSGoodsSpecs class]
             };
}
-(NSInteger)buyNum
{
    if (_buyNum>0) {
        return _buyNum;
    }
    return 1;
}
@end

@implementation DSGoodsAdv

@end

@implementation DSGoodsSku

@end

@implementation DSGoodsSpecs

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list_attrs":[DSGoodsAttrs class]};
}
@end

@implementation DSGoodsAttrs

@end
