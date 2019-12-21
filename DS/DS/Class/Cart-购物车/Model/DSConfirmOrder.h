//
//  DSConfirmOrder.h
//  DS
//
//  Created by 夏增明 on 2019/12/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DSMyAddress,DSConfirmGoods;
@interface DSConfirmOrder : NSObject
@property(nonatomic,copy) NSString *cmm_amount;
@property(nonatomic,copy) NSString *pay_amount;
@property(nonatomic,copy) NSString *price_amount;
@property(nonatomic,copy) NSString *goods_num;
/* 默认地址 */
@property(nonatomic,strong) DSMyAddress *address;
/* 下单商品 */
@property(nonatomic,strong) NSArray<DSConfirmGoods *> *list;
/* 下单备注 */
@property(nonatomic,copy) NSString *remark;

@end

@interface DSConfirmGoods : NSObject
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *specs_attrs;
@property(nonatomic,copy) NSString *shelf_status;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *discount_price;
@property(nonatomic,copy) NSString *cmm_price;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *goods_num;
@property(nonatomic,copy) NSString *sku_id;
@property(nonatomic,copy) NSString *stock;
@property(nonatomic,copy) NSString *cover_img;

@end

NS_ASSUME_NONNULL_END
