//
//  DSBalanceNote.h
//  DS
//
//  Created by 夏增明 on 2019/12/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSBalanceNote : NSObject
@property (nonatomic, copy) NSString *order_no;
/**收入：1晋级奖励；2商品奖励；3分享奖励；4商品奖励；5礼包奖励；8提现申请驳回；9提现申请手续费驳回；支出：20提现申请提交扣除提现金额；21提现申请扣除手续费。2、3、4、5类型的有订单数据*/
@property (nonatomic, copy) NSString *finance_log_type;
@property (nonatomic, copy) NSString *order_title;
@property (nonatomic, copy) NSString *finance_log_desc;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *receiver;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *finance_log_id;
@property (nonatomic, copy) NSString *pay_amount;
/* 内容高度 */
@property(nonatomic,assign) CGFloat textHeight;
@end

NS_ASSUME_NONNULL_END
