//
//  DSRefundDetailFooter.h
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSMyOrderDetail;
@interface DSRefundDetailFooter : UIView
/* 订单详情 */
@property(nonatomic,strong) DSMyOrderDetail *orderDetail;
@end

NS_ASSUME_NONNULL_END
