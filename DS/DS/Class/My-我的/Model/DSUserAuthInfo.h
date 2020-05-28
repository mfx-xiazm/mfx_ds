//
//  DSUserAuthInfo.h
//  DS
//
//  Created by huaxin-01 on 2020/5/28.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSUserAuthInfo : NSObject
@property (nonatomic, copy) NSString *idcard_front_img;
@property (nonatomic, copy) NSString *idcard_back_img;
@property (nonatomic, copy) NSString *idcard;
@property (nonatomic, copy) NSString *is_auth;
@property (nonatomic, copy) NSString *is_sign;
@property (nonatomic, copy) NSString *realname;
@end

NS_ASSUME_NONNULL_END
