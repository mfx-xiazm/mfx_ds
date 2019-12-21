//
//  DSUpOrderHeader.h
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSMyAddress;
typedef void(^addressClickedCall)(void);
@interface DSUpOrderHeader : UIView
@property (weak, nonatomic) IBOutlet UIView *noAddressView;
@property (weak, nonatomic) IBOutlet UIView *addressView;
/* 地址 */
@property(nonatomic,strong) DSMyAddress *defaultAddress;
/* 点击 */
@property(nonatomic,copy) addressClickedCall addressClickedCall;
@end

NS_ASSUME_NONNULL_END
