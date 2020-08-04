//
//  DSLandOrderDetailVC.h
//  DS
//
//  Created by huaxin-01 on 2020/8/4.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^orderHandleCall)(NSInteger type);
@interface DSLandOrderDetailVC : HXBaseViewController
/* 订单id */
@property(nonatomic,copy) NSString *oid;
/** 一亩地订单是否赠送会员  */
@property(nonatomic,copy) NSString *ymd_send_member;
/** 一亩地订单类型：0非一亩地订单；1土地订单；2购买的碾米机订单；3赠送的碾米机订单；4提米订单  */
@property(nonatomic,copy) NSString *ymd_type;
/* 订单操作  0 取消订单 1支付订单*/
@property(nonatomic,copy) orderHandleCall orderHandleCall;
@end

NS_ASSUME_NONNULL_END
