//
//  DSUserAuthVC.h
//  DS
//
//  Created by huaxin-01 on 2020/5/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class DSUserAuthInfo;
@interface DSUserAuthVC : HXBaseViewController
/* 用户认证信息 */
@property (nonatomic, strong) DSUserAuthInfo *authInfo;
@end

NS_ASSUME_NONNULL_END
