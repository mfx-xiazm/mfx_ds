//
//  DSMyAddress.h
//  DS
//
//  Created by 夏增明 on 2019/12/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSMyAddress : NSObject
@property (nonatomic, copy) NSString *area_name;
@property (nonatomic, copy) NSString *address_detail;
@property (nonatomic, copy) NSString *receiver;
@property (nonatomic, copy) NSString *address_id;
@property (nonatomic, copy) NSString *district_id;
@property (nonatomic, copy) NSString *street_id;
@property (nonatomic, copy) NSString *receiver_phone;
@property(nonatomic,assign) BOOL is_default;

@end

NS_ASSUME_NONNULL_END
