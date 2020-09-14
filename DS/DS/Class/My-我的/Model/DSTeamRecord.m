//
//  DSTeamRecord.m
//  DS
//
//  Created by huaxin-01 on 2020/9/14.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSTeamRecord.h"
#import "DSMyTeam.h"

@implementation DSTeamRecord
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
        @"ymd_parent":[DSMyTeam class]
    };
}

@end
