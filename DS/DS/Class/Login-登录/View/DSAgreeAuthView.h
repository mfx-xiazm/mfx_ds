//
//  DSAgreeAuthView.h
//  DS
//
//  Created by huaxin-01 on 2020/5/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^authClickedCall)(NSInteger type);
@interface DSAgreeAuthView : UIView
@property (nonatomic, copy) authClickedCall authClickedCall;
@end

NS_ASSUME_NONNULL_END
