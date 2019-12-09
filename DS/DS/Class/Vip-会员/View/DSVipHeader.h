//
//  DSVipHeader.h
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^vipHeaderBtnClickedCall)(NSInteger index);
@interface DSVipHeader : UIView
/* 点击 */
@property(nonatomic,copy) vipHeaderBtnClickedCall vipHeaderBtnClickedCall;
@end

NS_ASSUME_NONNULL_END
