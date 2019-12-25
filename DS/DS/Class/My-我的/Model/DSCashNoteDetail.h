//
//  DSCashNoteDetail.h
//  DS
//
//  Created by 夏增明 on 2019/12/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSCashNoteDetail : NSObject
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *apply_no;
/**1待审核；2已通过；3未通过*/
@property (nonatomic, copy) NSString *apply_status;
@property (nonatomic, copy) NSString *card_no;
@property (nonatomic, copy) NSString *bank_name;
@property (nonatomic, copy) NSString *card_owner;
@property (nonatomic, copy) NSString *apply_amount;
@property (nonatomic, copy) NSString *reject_reason;
@property (nonatomic, copy) NSString *apply_desc;
@end

NS_ASSUME_NONNULL_END
