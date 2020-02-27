//
//  DSVipGoods.h
//  DS
//
//  Created by 夏增明 on 2019/12/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSVipGoods : NSObject
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *is_upgrade_ulevel;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *sale_num;
@property(nonatomic,copy) NSString *stock;
@end

NS_ASSUME_NONNULL_END
