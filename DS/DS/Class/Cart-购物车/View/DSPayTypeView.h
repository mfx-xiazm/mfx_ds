//
//  DSPayTypeView.h
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^confirmPayCall)(NSInteger type);
@interface DSPayTypeView : UIView
/* 支付金额 */
@property(nonatomic,copy) NSString *pay_amount;
/* 确认支付 */
@property(nonatomic,copy) confirmPayCall confirmPayCall;
@end

NS_ASSUME_NONNULL_END
