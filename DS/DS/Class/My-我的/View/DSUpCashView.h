//
//  DSUpCashView.h
//  DS
//
//  Created by huaxin-01 on 2020/5/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^upCashCall)(NSInteger index);
@interface DSUpCashView : UIView
@property (nonatomic, copy) upCashCall upCashCall;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *account_no;
@property (weak, nonatomic) IBOutlet UILabel *cash_amount;

@end

NS_ASSUME_NONNULL_END
