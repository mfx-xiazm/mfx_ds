//
//  DSOrderWebVC.h
//  DS
//
//  Created by 夏增明 on 2020/3/6.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSOrderWebVC : HXBaseViewController
/* 链接 */
@property(nonatomic,copy) NSString *url;
/* 全部订单的跳转 */
@property(nonatomic,assign) BOOL isAllPush;
@end

NS_ASSUME_NONNULL_END
