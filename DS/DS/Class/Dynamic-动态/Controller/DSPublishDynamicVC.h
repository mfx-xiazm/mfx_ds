//
//  DSPublishDynamicVC.h
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^publishActionCall)(void);
@interface DSPublishDynamicVC : HXBaseViewController
/* 点击 */
@property(nonatomic,copy) publishActionCall publishActionCall;
@end

NS_ASSUME_NONNULL_END
