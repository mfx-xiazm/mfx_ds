//
//  DSOrderDetailVC.h
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^orderHandleCall)(NSInteger type);
@interface DSOrderDetailVC : HXBaseViewController
/* 是否是售后 */
@property(nonatomic,assign) BOOL isAfterSale;
/* 订单id */
@property(nonatomic,copy) NSString *oid;
/* 订单操作  0 取消订单 1支付订单 2申请退款 3确认收货*/
@property(nonatomic,copy) orderHandleCall orderHandleCall;
@end

NS_ASSUME_NONNULL_END
