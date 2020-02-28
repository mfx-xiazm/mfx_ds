//
//  DSTakeCouponView.h
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^couponClickedCall)(NSInteger index);
@interface DSTakeCouponView : UIView
@property(nonatomic,copy) NSString *valid_days;
@property(nonatomic,copy) NSString *discount;
@property(nonatomic,copy) NSString *is_discount;
/* 点击 */
@property(nonatomic,copy) couponClickedCall couponClickedCall;
@end

NS_ASSUME_NONNULL_END
