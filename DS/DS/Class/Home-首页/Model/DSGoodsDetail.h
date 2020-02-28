//
//  DSGoodsDetail.h
//  DS
//
//  Created by 夏增明 on 2019/12/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DSGoodsAdv,DSGoodsSku,DSGoodsSpecs,DSGoodsAttrs;
@interface DSGoodsDetail : NSObject
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *sale_num;
@property(nonatomic,copy) NSString *discount_price;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *cate_id;
@property(nonatomic,copy) NSString *goods_desc;
@property(nonatomic,copy) NSString *is_discount;
@property(nonatomic,copy) NSString *cart_num;
@property(nonatomic,strong) NSArray<DSGoodsAdv *> *goods_adv;
@property(nonatomic,strong) NSArray<DSGoodsSku *> *goods_sku;
@property(nonatomic,strong) NSArray<DSGoodsSpecs *> *list_specs;
@property(nonatomic,copy) NSString *is_collect;
@property(nonatomic,copy) NSString *provider;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *share_url;
@property(nonatomic,copy) NSString *cmm_price;
@property(nonatomic,copy) NSString *share_make_money;
@property(nonatomic,copy) NSString *valid_days;
@property(nonatomic,copy) NSString *discount;
@property(nonatomic,copy) NSString *stock;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *is_upgrade_ulevel;

@property(nonatomic,copy) NSString *taobao_item_id;
@property(nonatomic,copy) NSString *taobao_pid;

@property(nonatomic,copy) NSString *cate_flag;
@property(nonatomic,copy) NSString *goods_flag;

/** 购买的数量 */
@property(nonatomic,assign) NSInteger buyNum;
/** 选中的综合规格 */
@property(nonatomic,strong) DSGoodsSku * _Nullable selectSku;
@end

@interface DSGoodsAdv : NSObject
@property(nonatomic,copy) NSString *adv_img;
@end

@interface DSGoodsSku : NSObject
@property(nonatomic,copy) NSString *specs_attrs;
@property(nonatomic,copy) NSString *sale_num;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *discount_price;
@property(nonatomic,copy) NSString *specs_attr_ids;
@property(nonatomic,copy) NSString *sku_id;
@property(nonatomic,copy) NSString *stock;
@end

@interface DSGoodsSpecs : NSObject
@property(nonatomic,copy) NSString *specs_id;
@property(nonatomic,copy) NSString *specs_name;
@property(nonatomic,strong) NSArray<DSGoodsAttrs *> *list_attrs;
/* 选中的该分区的那个规格 */
@property(nonatomic,strong) DSGoodsAttrs *selectAttrs;
@end
@interface DSGoodsAttrs : NSObject
@property(nonatomic,copy) NSString *attr_name;
@property(nonatomic,copy) NSString *attr_id;
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;
@end
NS_ASSUME_NONNULL_END
