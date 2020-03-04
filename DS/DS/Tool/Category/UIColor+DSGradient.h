//
//  UIColor+DSGradient.h
//  DS
//
//  Created by 夏增明 on 2020/2/27.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 渐变色
@interface UIColor (DSGradient)
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;
@end

NS_ASSUME_NONNULL_END