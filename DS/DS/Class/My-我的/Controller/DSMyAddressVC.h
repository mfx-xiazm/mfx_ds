//
//  DSMyAddressVC.h
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class DSMyAddress;
typedef void(^getAddressCall)(DSMyAddress *address);
@interface DSMyAddressVC : HXBaseViewController
/* 选择 */
@property(nonatomic,copy) getAddressCall getAddressCall;
@end

NS_ASSUME_NONNULL_END
