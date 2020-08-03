//
//  DSChooseClassCell.h
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSGoodsAttrs,DSLandGoodsSku;
@interface DSChooseClassCell : UICollectionViewCell
/* 规则 */
@property(nonatomic,strong) DSGoodsAttrs *attrs;
/* 一亩地 */
@property (nonatomic, strong) DSLandGoodsSku *landSku;
@end

NS_ASSUME_NONNULL_END
