//
//  DSUpOrderVC.h
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^upOrderSuccessCall)(void);
@interface DSUpOrderVC : HXBaseViewController
/* 是否是购物车跳转 */
@property(nonatomic,assign) BOOL isCartPush;
/* 商品信息 */
@property(nonatomic,copy) NSString *goods_data;
/* 订单提交成功 */
@property(nonatomic,copy) upOrderSuccessCall upOrderSuccessCall;
@end

NS_ASSUME_NONNULL_END
