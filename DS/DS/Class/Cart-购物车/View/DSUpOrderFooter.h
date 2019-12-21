//
//  DSUpOrderFooter.h
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSConfirmOrder;
@interface DSUpOrderFooter : UIView
/* 初始化订单信息 */
@property(nonatomic,strong) DSConfirmOrder *confirmOrder;
@end

NS_ASSUME_NONNULL_END
