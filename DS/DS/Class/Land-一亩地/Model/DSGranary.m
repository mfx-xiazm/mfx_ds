//
//  DSGranary.m
//  DS
//
//  Created by huaxin-01 on 2020/8/4.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSGranary.h"

@implementation DSGranary
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
            @"goods":[DSGranaryGoods class]
             };

}
@end

@implementation DSGranaryGoods
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
            @"sku":[DSGranaryGoodSku class]
             };
}
-(NSInteger)row_num
{
    if (_sku.count) {
        if (_sku.count % 3) {
            return _sku.count/3 + 1;
        }else{
            return _sku.count/3;
        }
    }else{
        return 0;
    }
}
@end

@implementation DSGranaryGoodSku

@end
