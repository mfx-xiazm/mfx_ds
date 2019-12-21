//
//  DSDynamicDetailFooter.h
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSDynamicInfo;
typedef void(^footerTypeCall)(NSInteger index,UIButton *btn);
@interface DSDynamicDetailFooter : UIView
/* info */
@property(nonatomic,strong) DSDynamicInfo *info;
/* 点击 */
@property(nonatomic,copy) footerTypeCall footerTypeCall;
@end

NS_ASSUME_NONNULL_END
