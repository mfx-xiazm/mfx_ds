//
//  DSVipCell.h
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSVipGoods;
typedef void(^buyClickCall)(void);
@interface DSVipCell : UITableViewCell
/* 商品 */
@property(nonatomic,strong) DSVipGoods *goods;
/* 点击 */
@property(nonatomic,copy) buyClickCall buyClickCall;
@end

NS_ASSUME_NONNULL_END
