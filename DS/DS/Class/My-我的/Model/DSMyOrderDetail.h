//
//  DSMyOrderDetail.h
//  DS
//
//  Created by 夏增明 on 2019/12/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DSMyOrderDetailGoods,DSMyOrderRefundAddress;
@interface DSMyOrderDetail : NSObject
@property(nonatomic,copy) NSString *order_no;
@property(nonatomic,copy) NSString *pay_amount;
@property(nonatomic,copy) NSString *oid;
@property(nonatomic,copy) NSString *order_num;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *order_self_commission;
@property(nonatomic,copy) NSString *remarks;
/** 1常规商品  10 一亩地订单 100vip商品 */
@property(nonatomic,copy) NSString *order_type;
/** 一亩地订单是否赠送会员  */
@property(nonatomic,copy) NSString *ymd_send_member;
/** 一亩地订单类型：0非一亩地订单；1土地订单；2购买的碾米机订单；3赠送的碾米机订单；4提米订单  */
@property(nonatomic,copy) NSString *ymd_type;
@property(nonatomic,copy) NSString *pay_type;

@property(nonatomic,copy) NSString *receiver;
@property(nonatomic,copy) NSString *receiver_phone;
@property(nonatomic,copy) NSString *area_name;
@property(nonatomic,copy) NSString *address_detail;

@property(nonatomic,copy) NSString *logistics_no;
@property(nonatomic,copy) NSString *logistics_com_name;
@property(nonatomic,copy) NSString *logistics_url;

@property(nonatomic,copy) NSString *reject_reason;
@property(nonatomic,copy) NSString *refund_time;
@property(nonatomic,copy) NSString *apply_refund_time;
/**1申请中；2退货中(未发货没有此状态)；3退款完成；4退款失败*/
@property(nonatomic,copy) NSString *refund_status;
@property(nonatomic,copy) NSString *create_time;
@property(nonatomic,copy) NSString *refund_reason;
/* 备注文字高度 */
@property(nonatomic,assign) CGFloat remarkTextHeight;
@property(nonatomic,strong) NSArray<DSMyOrderDetailGoods *> *list_goods;
@property(nonatomic,strong) DSMyOrderRefundAddress *refund_address;

@end

@interface DSMyOrderDetailGoods : NSObject
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

@interface DSMyOrderRefundAddress : NSObject
@property(nonatomic,copy) NSString *area_name;
@property(nonatomic,copy) NSString *address_detail;
@property(nonatomic,copy) NSString *receiver;
@property(nonatomic,copy) NSString *receiver_phone;

@end

NS_ASSUME_NONNULL_END
