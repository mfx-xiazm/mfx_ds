//
//  DSMyHeader.h
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^myHeaderBtnClickedCall)(NSInteger index);
@interface DSMyHeader : UIView
/* 点击 */
@property(nonatomic,copy) myHeaderBtnClickedCall myHeaderBtnClickedCall;
/* readLoad */
@property(nonatomic,assign) BOOL isReload;
@end

NS_ASSUME_NONNULL_END
