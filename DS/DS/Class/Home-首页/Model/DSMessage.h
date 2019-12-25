//
//  DSMessage.h
//  DS
//
//  Created by 夏增明 on 2019/12/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSMessage : NSObject
@property(nonatomic,copy) NSString *is_read;
@property(nonatomic,copy) NSString *create_time;
@property(nonatomic,copy) NSString *msg_title;
@property(nonatomic,copy) NSString *msg_type;
@property(nonatomic,copy) NSString *msg_id;
@property(nonatomic,copy) NSString *ref_id;

@end

NS_ASSUME_NONNULL_END
