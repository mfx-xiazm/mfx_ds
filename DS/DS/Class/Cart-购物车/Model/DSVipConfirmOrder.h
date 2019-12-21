//
//  DSVipConfirmOrder.h
//  DS
//
//  Created by 夏增明 on 2019/12/20.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DSMyAddress;
@interface DSVipConfirmOrder : NSObject
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *pay_amount;
@property(nonatomic,copy) NSString *price_amount;
@property(nonatomic,copy) NSString *goods_num;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *stock;
@property(nonatomic,copy) NSString *cover_img;
/* 默认地址 */
@property(nonatomic,strong) DSMyAddress *address;
@end

NS_ASSUME_NONNULL_END
