//
//  DSCateGoodsCell.h
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSShopGoods;
typedef void(^collectActionCall)(void);
@interface DSCateGoodsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
/* 商品 */
@property(nonatomic,strong) DSShopGoods *goods;
/* 点击 */
@property(nonatomic,copy) collectActionCall collectActionCall;
@end

NS_ASSUME_NONNULL_END
