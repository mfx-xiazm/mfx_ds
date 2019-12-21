//
//  DSVipCardDetail.h
//  DS
//
//  Created by 夏增明 on 2019/12/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DSVipCardInfo,DSVipCardPrice;
@interface DSVipCardDetail : NSObject
@property(nonatomic,strong) DSVipCardInfo *card_type;
@property(nonatomic,strong) NSArray<DSVipCardPrice *> *list;

@end

@interface DSVipCardInfo : NSObject
@property(nonatomic,copy) NSString *card_type_id;
@property(nonatomic,copy) NSString *show_img;
@property(nonatomic,copy) NSString *product_name;
@property(nonatomic,copy) NSString *card_desc;

@end

@interface DSVipCardPrice : NSObject

@property(nonatomic,copy) NSString *original_price;
@property(nonatomic,copy) NSString *member_price;
@property(nonatomic,copy) NSString *face_value;
@property(nonatomic,copy) NSString *card_id;
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
