//
//  DSCashNote.h
//  DS
//
//  Created by 夏增明 on 2019/12/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSCashNote : NSObject
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *apply_no;
/**1待审核；2已通过；3未通过*/
@property (nonatomic, copy) NSString *apply_status;
@property (nonatomic, copy) NSString *reject_reason;
@property (nonatomic, copy) NSString *apply_amount;
@property (nonatomic, copy) NSString *apply_desc;
@property (nonatomic, copy) NSString *finance_apply_id;

@end

NS_ASSUME_NONNULL_END
