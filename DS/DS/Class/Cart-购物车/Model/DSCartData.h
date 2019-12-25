//
//  DSCartData.h
//  DS
//
//  Created by 夏增明 on 2019/12/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSCartData : NSObject
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *specs_attrs;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *discount_price;
@property(nonatomic,copy) NSString *cmm_price;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,assign) BOOL is_checked;
@property(nonatomic,copy) NSString *sku_id;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *cart_num;
@property(nonatomic,copy) NSString *stock;
@property(nonatomic,copy) NSString *is_discount;

@end

NS_ASSUME_NONNULL_END
