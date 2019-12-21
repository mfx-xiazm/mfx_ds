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

@end
