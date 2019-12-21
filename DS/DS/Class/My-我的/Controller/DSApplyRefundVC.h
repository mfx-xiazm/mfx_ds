//
//  DSApplyRefundVC.h
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^applyRefundActionCall)(void);
@interface DSApplyRefundVC : HXBaseViewController
/* 订单id */
@property(nonatomic,copy) NSString *oid;
/* 单击 */
@property(nonatomic,copy) applyRefundActionCall applyRefundActionCall;
@end

NS_ASSUME_NONNULL_END
