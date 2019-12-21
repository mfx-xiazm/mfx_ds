//
//  DSDynamicCell.h
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class DSDynamicLayout,DSDynamicCell;

@protocol DSDynamicCellDelegate <NSObject>
@optional
/** 点赞 */
- (void)didClickThumbInCell:(DSDynamicCell *)Cell;
/** 分享 */
- (void)didClickShareInCell:(DSDynamicCell *)Cell;
/** 删除 */
- (void)didClickDeleteInCell:(DSDynamicCell *)Cell;
@end

@interface DSDynamicCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, weak) UIViewController *targetVc;
/** 数据源 */
@property (nonatomic, strong) DSDynamicLayout *dynamicLayout;
/** 代理 */
@property (nonatomic, assign) id<DSDynamicCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
