//
//  DSShopGoodsCell.h
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSHomeRecommend,DSShopGoods;
@interface DSShopGoodsCell : UICollectionViewCell
/* 推荐商品 */
@property(nonatomic,strong) DSHomeRecommend *recommend;
/* 分类商品 */
@property (nonatomic, strong) DSShopGoods *goods;
@end

NS_ASSUME_NONNULL_END
