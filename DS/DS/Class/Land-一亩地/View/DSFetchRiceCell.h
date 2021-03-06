//
//  DSFetchRiceCell.h
//  DS
//
//  Created by huaxin-01 on 2020/7/29.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSGranaryGoods;
typedef void(^fetchRiceNumCall)(void);
@interface DSFetchRiceCell : UITableViewCell
@property (nonatomic, strong) DSGranaryGoods *goods;
@property (nonatomic, copy) fetchRiceNumCall fetchRiceNumCall;
@end

NS_ASSUME_NONNULL_END
