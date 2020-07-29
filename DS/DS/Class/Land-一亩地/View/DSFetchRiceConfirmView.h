//
//  DSFetchRiceConfirmView.h
//  DS
//
//  Created by huaxin-01 on 2020/7/29.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^confirmBtnClickedCall)(NSInteger index);
@interface DSFetchRiceConfirmView : UIView
@property (nonatomic, copy) confirmBtnClickedCall confirmBtnClickedCall;
@end

NS_ASSUME_NONNULL_END
