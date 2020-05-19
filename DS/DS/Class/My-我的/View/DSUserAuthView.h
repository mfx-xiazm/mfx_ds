//
//  DSUserAuthView.h
//  DS
//
//  Created by huaxin-01 on 2020/5/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^userAuthCall)(NSInteger index);
@interface DSUserAuthView : UIView
@property (nonatomic, copy) userAuthCall userAuthCall;
@end

NS_ASSUME_NONNULL_END
