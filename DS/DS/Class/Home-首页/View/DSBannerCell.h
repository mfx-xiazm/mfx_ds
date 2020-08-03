//
//  DSBannerCell.h
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSHomeBanner,DSGoodsAdv,DSLandAdv,DSLandGoodsAdv;
@interface DSBannerCell : UICollectionViewCell
/* banner */
@property(nonatomic,strong) DSHomeBanner *banner;
/* 商品图 */
@property(nonatomic,strong) DSGoodsAdv *adv;
/* 一亩地 */
@property(nonatomic,strong) DSLandAdv *landAdv;
/* 一亩地详情 */
@property (nonatomic, strong) DSLandGoodsAdv *landGoodsAdv;
@end

NS_ASSUME_NONNULL_END
