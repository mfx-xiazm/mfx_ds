//
//  DSPublishDynamicCell.h
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSPuslishDynamicData;
typedef void(^deleteCallBack)(void);
@interface DSPublishDynamicCell : UITableViewCell
/* 动态 */
@property(nonatomic,strong) DSPuslishDynamicData *pd;
/* 点击 */
@property(nonatomic,copy) deleteCallBack deleteCallBack;
@end

NS_ASSUME_NONNULL_END
