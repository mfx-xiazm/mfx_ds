//
//  DSFetchRiceHeader.h
//  DS
//
//  Created by huaxin-01 on 2020/7/29.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSGranary;
typedef void(^addressClickedCall)(void);
@interface DSFetchRiceHeader : UIView
@property (weak, nonatomic) IBOutlet UIView *noAddressView;
@property (weak, nonatomic) IBOutlet UIView *addressView;
/* 余量 */
@property (nonatomic, strong) DSGranary *granary;
/* 点击 */
@property(nonatomic,copy) addressClickedCall addressClickedCall;
@end
NS_ASSUME_NONNULL_END
