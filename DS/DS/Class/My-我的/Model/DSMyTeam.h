//
//  DSMyTeam.h
//  DS
//
//  Created by 夏增明 on 2019/12/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSMyTeam : NSObject
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *ymd_leader_level;
@end

NS_ASSUME_NONNULL_END
