//
//  DSPosterContentView.h
//  DS
//
//  Created by 夏增明 on 2019/12/23.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSGoodsDetail;
@interface DSPosterContentView : UIScrollView
/** 商品详情 */
@property(nonatomic,strong) DSGoodsDetail *goodsDetail;
@end

NS_ASSUME_NONNULL_END
