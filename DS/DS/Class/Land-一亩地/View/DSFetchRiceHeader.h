//
//  DSFetchRiceHeader.h
//  DS
//
//  Created by huaxin-01 on 2020/7/29.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSMyAddress;
typedef void(^addressClickedCall)(void);
@interface DSFetchRiceHeader : UIView
@property (weak, nonatomic) IBOutlet UIView *noAddressView;
@property (weak, nonatomic) IBOutlet UIView *addressView;
/* 地址 */
@property(nonatomic,strong) DSMyAddress *defaultAddress;
/* 点击 */
@property(nonatomic,copy) addressClickedCall addressClickedCall;
@end
NS_ASSUME_NONNULL_END
