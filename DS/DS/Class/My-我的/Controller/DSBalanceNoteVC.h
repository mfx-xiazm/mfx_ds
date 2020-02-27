//
//  DSBalanceNoteVC.h
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSBalanceNoteVC : HXBaseViewController
/* 奖励类型：晋级1，礼包2，商品3，分享4，队长收益5为晋级1和分享4之和 */
@property(nonatomic,assign) NSInteger reward_type;
@end

NS_ASSUME_NONNULL_END
