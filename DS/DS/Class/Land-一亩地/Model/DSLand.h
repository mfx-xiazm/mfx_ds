//
//  DSLand.h
//  DS
//
//  Created by huaxin-01 on 2020/8/3.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DSLandAdv,DSLandGoods;
@interface DSLand : NSObject
@property(nonatomic,strong) NSArray<DSLandAdv *> *adv;
@property(nonatomic,strong) NSArray<DSLandGoods *> *land_goods;
@property(nonatomic,strong) NSArray<DSLandAdv *> *jgq;

@end

@interface DSLandAdv : NSObject
@property(nonatomic,copy) NSString *adv_position;
@property(nonatomic,copy) NSString *adv_content;
@property(nonatomic,copy) NSString *adv_type;
@property(nonatomic,copy) NSString *adv_id;
@property(nonatomic,copy) NSString *adv_img;
@property(nonatomic,copy) NSString *adv_name;
@property(nonatomic,copy) NSString *font_color;

@end

@interface DSLandGoods : NSObject
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *is_nmj;

@end

NS_ASSUME_NONNULL_END
