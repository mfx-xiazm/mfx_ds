//
//  DSWebContentVC.h
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSWebContentVC : HXBaseViewController
/** url */
@property (nonatomic,copy) NSString *url;
/** 富文本 */
@property (nonatomic,copy) NSString *htmlContent;
/** 标题 */
@property(nonatomic,copy) NSString *navTitle;
/** 是否需要请求 */
@property(nonatomic,assign) BOOL isNeedRequest;
/** 1注册协议 2公告详情 3电子合同 4正式合同*/
@property(nonatomic,assign) NSInteger requestType;
/** 注册协议 1买家 3技工 */
@property(nonatomic,copy) NSString *type;
/** 公告id */
@property(nonatomic,copy) NSString *notice_id;
/** 商品购物车id 多个用逗号隔开 */
@property(nonatomic,copy) NSString *cart_ids;
/** 下单时候的备注说明 多个商品备注之间用"_"隔开有的商品没填备注用空字符串 */
@property(nonatomic,copy) NSString *order_note;
/** 订单id */
@property(nonatomic,copy) NSString *order_id;
@end

NS_ASSUME_NONNULL_END
