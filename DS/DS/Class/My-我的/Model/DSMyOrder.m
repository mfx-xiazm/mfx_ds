//
//  DSMyOrder.m
//  DS
//
//  Created by 夏增明 on 2019/12/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMyOrder.h"

@implementation DSMyOrder
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list_goods":[DSMyOrderGoods class]
             };
}
@end

@implementation DSMyOrderGoods
-(NSString *)is_discount
{
    if (_discount_price && _price) {
        if ([_discount_price floatValue] == [_price floatValue]) {
            return @"0";
        }else{
            return @"1";
        }
    }else{
        return @"0";
    }
}
@end
