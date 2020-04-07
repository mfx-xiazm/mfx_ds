//
//  DSTaoKeOrder.h
//  DS
//
//  Created by huaxin-01 on 2020/4/7.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSTaoKeOrder : NSObject
@property(nonatomic,copy) NSString *order_no;
@property(nonatomic,copy) NSString *income;
@property(nonatomic,copy) NSString *order_title;
@property(nonatomic,copy) NSString *cate_flag;
@property(nonatomic,copy) NSString *discount_amount;
@property(nonatomic,copy) NSString *pay_amount;
@property(nonatomic,copy) NSString *tab_status;
@property(nonatomic,copy) NSString *order_num;
@property(nonatomic,copy) NSString *order_self_commission;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *pay_time;
@end

NS_ASSUME_NONNULL_END
