//
//  DSMyOrderCell.h
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSConfirmGoods,DSMyOrderGoods,DSMyOrderDetailGoods;
@interface DSMyOrderCell : UITableViewCell
/* 商品 */
@property(nonatomic,strong) DSConfirmGoods *goods;
/* 商品 */
@property(nonatomic,strong) DSMyOrderGoods *orderGoods;
/* 商品 */
@property(nonatomic,strong) DSMyOrderDetailGoods *detailGoods;
/* 1常规商品 100会员商品*/
@property(nonatomic,copy) NSString *order_type;

@end

NS_ASSUME_NONNULL_END
