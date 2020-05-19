//
//  DSMyBalanceHeader.h
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^balanceBtnCall)(NSInteger index);
@interface DSMyBalanceHeader : UIView
/* 点击 */
@property(nonatomic,copy) balanceBtnCall balanceBtnCall;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *gift_reward;
@property (weak, nonatomic) IBOutlet UILabel *upgrade_reward;
@property (weak, nonatomic) IBOutlet UILabel *goods_reward;

@property (weak, nonatomic) IBOutlet UILabel *last_month_amount;
@property (weak, nonatomic) IBOutlet UILabel *cur_month_amount;
@property (weak, nonatomic) IBOutlet UILabel *dai_month_amount;

@end

NS_ASSUME_NONNULL_END
