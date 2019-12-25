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
/** 1常规商品 100vip商品 */
@property(nonatomic,copy) NSString *order_type;
@property(nonatomic,strong) NSArray<DSMyOrderGoods *> *list_goods;

@end

@interface DSMyOrderGoods : NSObject
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *self_commission;
@property(nonatomic,copy) NSString *specs_attrs;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *discount_amount;
@property(nonatomic,copy) NSString *goods_num;
@property(nonatomic,copy) NSString *order_goods_id;
@property(nonatomic,copy) NSString *cover_img;

@end

NS_ASSUME_NONNULL_END
