//
//  DSShopGoods.h
//  DS
//
//  Created by 夏增明 on 2019/12/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSShopGoods : NSObject
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *discount_price;
@property(nonatomic,copy) NSString *cmm_price;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *cate_mode;
@property(nonatomic,copy) NSString *cate_flag;

@end

NS_ASSUME_NONNULL_END
