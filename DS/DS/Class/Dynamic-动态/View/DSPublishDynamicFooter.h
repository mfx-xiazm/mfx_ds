//
//  DSPublishDynamicFooter.h
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^footerHandleCall)(NSInteger index,UIButton *btn);
@interface DSPublishDynamicFooter : UIView
/* 点击 */
@property(nonatomic,copy) footerHandleCall footerHandleCall;
@end

NS_ASSUME_NONNULL_END
