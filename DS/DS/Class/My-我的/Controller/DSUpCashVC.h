//
//  DSUpCashVC.h
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^upCashActionCall)(void);
@interface DSUpCashVC : HXBaseViewController
@property (nonatomic, copy) NSString *realNameTxt;
/* 点击 */
@property(nonatomic,copy) upCashActionCall upCashActionCall;
@end

NS_ASSUME_NONNULL_END
