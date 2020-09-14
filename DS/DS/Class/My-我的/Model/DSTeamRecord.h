//
//  DSTeamRecord.h
//  DS
//
//  Created by huaxin-01 on 2020/9/14.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DSMyTeam;
@interface DSTeamRecord : NSObject
@property (nonatomic, strong) DSMyTeam *ymd_parent;
@property (nonatomic, copy) NSString *lj_ymd_amount;
@property (nonatomic, copy) NSString *xz_ymd_amount;

@end

NS_ASSUME_NONNULL_END
