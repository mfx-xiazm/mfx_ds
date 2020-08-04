//
//  DSGranary.h
//  DS
//
//  Created by huaxin-01 on 2020/8/4.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DSGranaryGoods,DSGranaryGoodSku,DSMyAddress;
@interface DSGranary : NSObject
@property (nonatomic, copy) NSString *millet;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *min_pick_num;
@property (nonatomic, assign) CGFloat pick_num;// 提米数量
@property (nonatomic, strong) DSMyAddress *address;
@property (nonatomic, strong) NSArray<DSGranaryGoods *> *goods;
@end

@interface DSGranaryGoods : NSObject
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *cate_id;
@property (nonatomic, copy) NSString *stock;
@property (nonatomic, assign) NSInteger row_num;// 一行放三个，可以放几行
@property (nonatomic, strong) NSArray<DSGranaryGoodSku *> *sku;

@end

@interface DSGranaryGoodSku : NSObject
@property (nonatomic, assign) CGFloat millet;
@property (nonatomic, copy) NSString *specs_attrs;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *specs_attr_ids;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *sku_id;
@property (nonatomic, assign) NSInteger stock;
@property (nonatomic, assign) NSInteger fetch_num;
@end

NS_ASSUME_NONNULL_END
