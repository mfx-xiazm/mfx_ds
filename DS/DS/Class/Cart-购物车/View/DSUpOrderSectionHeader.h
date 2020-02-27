//
//  DSUpOrderSectionHeader.h
//  DS
//
//  Created by 夏增明 on 2020/2/18.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSMyOrderGoods;
@interface DSUpOrderSectionHeader : UIView
/* 商品 */
@property(nonatomic,strong) DSMyOrderGoods *orderGoods;
@end

NS_ASSUME_NONNULL_END
