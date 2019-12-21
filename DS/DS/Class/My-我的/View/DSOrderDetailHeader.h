//
//  DSOrderDetailHeader.h
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSMyOrderDetail;
typedef void(^lookLogisCall)(void);
@interface DSOrderDetailHeader : UIView
/* 订单详情 */
@property(nonatomic,strong) DSMyOrderDetail *orderDetail;
/* 查看物流 */
@property(nonatomic,copy) lookLogisCall lookLogisCall;
@end

NS_ASSUME_NONNULL_END
