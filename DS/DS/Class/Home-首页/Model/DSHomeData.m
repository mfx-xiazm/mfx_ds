//
//  DSHomeData.m
//  DS
//
//  Created by 夏增明 on 2019/12/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSHomeData.h"

@implementation DSHomeData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cate":[DSHomeCate class],
             @"adv":[DSHomeBanner class],
             @"recommend_goods":[DSHomeRecommend class]
             };
}
@end

@implementation DSHomeCate

@end

@implementation DSHomeBanner

@end

@implementation DSHomeRecommend

@end
