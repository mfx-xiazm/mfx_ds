//
//  DSFetchRiceVC.h
//  DS
//
//  Created by huaxin-01 on 2020/7/29.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class DSGranary;
typedef void(^fetchRiceCall)(void);
@interface DSFetchRiceVC : HXBaseViewController
@property (nonatomic, strong) DSGranary *granary;
@property (nonatomic, copy) fetchRiceCall fetchRiceCall;
@end

NS_ASSUME_NONNULL_END
