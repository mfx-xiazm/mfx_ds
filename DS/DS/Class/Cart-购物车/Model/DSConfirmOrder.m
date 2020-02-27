//
//  DSConfirmOrder.m
//  DS
//
//  Created by 夏增明 on 2019/12/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSConfirmOrder.h"
#import "DSMyAddress.h"

@implementation DSConfirmOrder
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"address":[DSMyAddress class],
             @"list":[DSConfirmGoods class]};
}

@end

@implementation DSConfirmGoods
-(CGFloat)totalPrice
{
    CGFloat price = 0;
    if ([self.is_discount isEqualToString:@"1"]) {
        price += ([self.discount_price floatValue])*[self.goods_num integerValue];
    }else{
        price += ([self.price floatValue])*[self.goods_num integerValue];
    }
    return price;
}
@end
