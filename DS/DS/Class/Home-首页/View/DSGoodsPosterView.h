//
//  DSGoodsPosterView.h
//  DS
//
//  Created by 夏增明 on 2019/11/20.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSGoodsDetail;
typedef void(^posterTypeCall)(NSInteger index,UIImage * _Nullable snapShotImage);
@interface DSGoodsPosterView : UIView
/* 点击 */
@property(nonatomic,copy) posterTypeCall posterTypeCall;
/** 商品详情 */
@property(nonatomic,strong) DSGoodsDetail *goodsDetail;
@end

NS_ASSUME_NONNULL_END
