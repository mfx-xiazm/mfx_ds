//
//  DSMyOrderFooter.h
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSMyOrder;
typedef void(^orderHandleCall)(NSInteger index);
@interface DSMyOrderFooter : UIView
@property (weak, nonatomic) IBOutlet UIView *handleView;
/* 订单 */
@property(nonatomic,strong) DSMyOrder *order;
/* 操作 */
@property(nonatomic,copy) orderHandleCall orderHandleCall;
@end

NS_ASSUME_NONNULL_END
