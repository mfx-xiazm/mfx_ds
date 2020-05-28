//
//  DSBindCashMsgVC.h
//  DS
//
//  Created by huaxin-01 on 2020/5/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^bindSuccessCall)(NSString *account_no);
@interface DSBindCashMsgVC : HXBaseViewController
@property (nonatomic, assign) NSInteger dataType;
@property (nonatomic, copy) NSString *realNameTxt;
@property (nonatomic, copy) bindSuccessCall bindSuccessCall;
@end

NS_ASSUME_NONNULL_END
