//
//  DSMyCollectCell.h
//  DS
//
//  Created by 夏增明 on 2020/2/17.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSShopGoods;
@interface DSMyCollectCell : UITableViewCell
/* 商品 */
@property(nonatomic,strong) DSShopGoods *goods;
@end

NS_ASSUME_NONNULL_END
