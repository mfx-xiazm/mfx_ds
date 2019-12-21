//
//  DSHomeData.h
//  DS
//
//  Created by 夏增明 on 2019/12/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DSHomeCate,DSHomeBanner,DSHomeRecommend;
@interface DSHomeData : NSObject
/* 分类 */
@property(nonatomic,strong) NSArray<DSHomeCate *> *cate;
/* benner */
@property(nonatomic,strong) NSArray<DSHomeBanner *> *adv;
/* 推荐商品 */
@property(nonatomic,strong) NSArray<DSHomeRecommend *> *recommend_goods;
/* 未读消息数 */
@property(nonatomic,copy) NSString *unread_msg_num;
@end

@interface DSHomeCate : NSObject
/**1袋鼠自营商品分类；2京东自营商品分类；3京东联盟商品分类；4淘宝商品分类*/
@property(nonatomic,copy) NSString *cate_mode;
@property(nonatomic,copy) NSString *cate_name;
@property(nonatomic,copy) NSString *cate_id;
@property(nonatomic,copy) NSString *cate_img;
@end

@interface DSHomeBanner : NSObject
@property(nonatomic,copy) NSString *adv_content;
/**1仅图片；2链接；3html内容；4商品详情，类型未html时不返回adv_content，通过详情接口获取*/
@property(nonatomic,copy) NSString *adv_type;
@property(nonatomic,copy) NSString *adv_id;
@property(nonatomic,copy) NSString *adv_img;
@property(nonatomic,copy) NSString *adv_name;

@end

@interface DSHomeRecommend : NSObject
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *discount_price;
@property(nonatomic,copy) NSString *cmm_price;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *cover_img;

@end
NS_ASSUME_NONNULL_END
