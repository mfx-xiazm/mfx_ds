//
//  DSCashNoteCell.h
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSCashNote;
@interface DSCashNoteCell : UITableViewCell
/* 记录 */
@property(nonatomic,strong) DSCashNote *note;
@end

NS_ASSUME_NONNULL_END
