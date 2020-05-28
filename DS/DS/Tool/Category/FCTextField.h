//
//  FCTextField.h
//  FC
//
//  Created by huaxin-01 on 2020/5/13.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCTextField : UITextField
//仅仅用于设置ib  非正常属性  0数字 1字母 2数字+字母
@property(nonatomic,assign)IBInspectable NSInteger kLimitType;
@end

NS_ASSUME_NONNULL_END
