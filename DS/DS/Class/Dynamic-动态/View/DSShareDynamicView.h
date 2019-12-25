//
//  DSShareDynamicView.h
//  DS
//
//  Created by 夏增明 on 2019/12/25.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^shareTypeActionCall)(NSInteger index);
@interface DSShareDynamicView : UIView
/* 点击 */
@property(nonatomic,copy) shareTypeActionCall shareTypeActionCall;
@end

NS_ASSUME_NONNULL_END
