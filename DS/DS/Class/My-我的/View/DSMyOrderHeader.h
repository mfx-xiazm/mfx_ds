//
//  DSMyOrderHeader.h
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSMyOrder;
@interface DSMyOrderHeader : UIView
/* 是否是售后 */
@property(nonatomic,assign) BOOL isAfterSale;
/* 订单 */
@property(nonatomic,strong) DSMyOrder *order;
@end

NS_ASSUME_NONNULL_END
