//
//  DSDynamicDetailVC.h
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^dynamicDetailCall)(NSUInteger type);
@interface DSDynamicDetailVC : HXBaseViewController
/* 动态id */
@property(nonatomic,copy) NSString *treads_id;
/* 1点赞 2删除 */
@property(nonatomic,copy) dynamicDetailCall dynamicDetailCall;
@end

NS_ASSUME_NONNULL_END
