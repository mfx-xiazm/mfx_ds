//
//  DSMyOrder.h
//  DS
//
//  Created by 夏增明 on 2019/12/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DSMyOrderGoods;
@interface DSMyOrder : NSObject
@property(nonatomic,copy) NSString *order_no;
@property(nonatomic,copy) NSString *pay_amount;
@property(nonatomic,copy) NSString *oid;
@property(nonatomic,copy) NSString *order_num;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *refund_status;
/** 1常规商品 10一亩地 100vip商品 */
@property(nonatomic,copy) NSString *order_type;
/** 为1是购买一亩地订单赠送会员  */
@property(nonatomic,copy) NSString *ymd_send_member;
/** 一亩地订单类型：0非一亩地订单；1土地订单；2购买的碾米机订单；3赠送的碾米机订单；4提米订单  */
@property(nonatomic,copy) NSString *ymd_type;
@property(nonatomic,copy) NSString *logistics_url;
@property(nonatomic,strong) NSArray<DSMyOrderGoods *> *list_goods;

@end

@interface DSMyOrderGoods : NSObject
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *self_commission;
@property(nonatomic,copy) NSString *specs_attrs;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *discount_amount;
@property(nonatomic,copy) NSString *discount_price;
@property(nonatomic,copy) NSString *goods_num;
@property(nonatomic,copy) NSString *order_goods_id;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *is_discount;
@property(nonatomic,copy) NSString *cmm_price;

@end

NS_ASSUME_NONNULL_END
