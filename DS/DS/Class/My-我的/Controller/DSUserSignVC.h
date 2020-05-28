//
//  DSUserSignVC.h
//  DS
//
//  Created by huaxin-01 on 2020/5/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^signSuccessCall)(void);
@interface DSUserSignVC : HXBaseViewController
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *centNo;
@property (nonatomic, copy) signSuccessCall signSuccessCall;
@end

NS_ASSUME_NONNULL_END
