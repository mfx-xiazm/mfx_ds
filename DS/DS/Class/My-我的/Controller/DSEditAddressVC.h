//
//  DSEditAddressVC.h
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class DSMyAddress;
typedef void(^editSuccessCall)(void);
@interface DSEditAddressVC : HXBaseViewController
/* 地址 */
@property(nonatomic,strong) DSMyAddress *address;
/* 点击 */
@property(nonatomic,copy) editSuccessCall editSuccessCall;
@end

NS_ASSUME_NONNULL_END
