//
//  DSLandDetail.h
//  DS
//
//  Created by huaxin-01 on 2020/8/3.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DSLandGoodsAdv,DSLandGoodsSku,DSLandGoodsSpecs,DSLandGoodsAttrs;
@interface DSLandDetail : NSObject
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *cate_flag;
@property (nonatomic, copy) NSString *sale_num;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *cate_id;
@property (nonatomic, copy) NSString *goods_desc;
@property (nonatomic, copy) NSString *cate_mode;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *is_nmj;
@property (nonatomic, copy) NSString *land_user_license;
@property (nonatomic, copy) NSString *stock;
@property (nonatomic, copy) NSString *cover_img;
@property(nonatomic,strong) NSArray<DSLandGoodsAdv *> *goods_adv;
@property(nonatomic,strong) NSArray<DSLandGoodsSku *> *goods_sku;
@property(nonatomic,strong) NSArray<DSLandGoodsSpecs *> *list_specs;
/* 选中的那个规格 */
@property(nonatomic,strong) DSLandGoodsSku *selectSku;
@end

@interface DSLandGoodsAdv : NSObject
@property(nonatomic,copy) NSString *adv_img;
@end

@interface DSLandGoodsSku : NSObject
@property(nonatomic,copy) NSString *millet;
@property(nonatomic,copy) NSString *specs_attrs;
@property(nonatomic,copy) NSString *sale_num;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *is_send_nmj;
@property(nonatomic,copy) NSString *specs_attr_ids;
@property(nonatomic,copy) NSString *sku_id;
@property(nonatomic,copy) NSString *stock;
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;
@end

@interface DSLandGoodsSpecs : NSObject
@property(nonatomic,copy) NSString *specs_id;
@property(nonatomic,copy) NSString *specs_name;
@property(nonatomic,strong) NSArray<DSLandGoodsAttrs *> *list_attrs;
/* 选中的该分区的那个规格 */
@property(nonatomic,strong) DSLandGoodsAttrs *selectAttrs;
@end
@interface DSLandGoodsAttrs : NSObject
@property(nonatomic,copy) NSString *attr_name;
@property(nonatomic,copy) NSString *attr_id;
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;
@end
NS_ASSUME_NONNULL_END
