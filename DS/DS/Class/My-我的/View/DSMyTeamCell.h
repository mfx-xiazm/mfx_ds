//
//  DSMyTeamCell.h
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSMyTeam;
@interface DSMyTeamCell : UITableViewCell
/* 团队 */
@property(nonatomic,strong) DSMyTeam *team;
@end

NS_ASSUME_NONNULL_END
