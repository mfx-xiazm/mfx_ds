//
//  DSMessageCell.h
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSMessage;
@interface DSMessageCell : UITableViewCell
/* 消息 */
@property(nonatomic,strong) DSMessage *msg;
@end

NS_ASSUME_NONNULL_END
