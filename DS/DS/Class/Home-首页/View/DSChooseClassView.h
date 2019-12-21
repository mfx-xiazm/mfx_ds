//
//  DSChooseClassView.h
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSGoodsDetail;
typedef void(^goodsHandleCall)(NSInteger index);
@interface DSChooseClassView : UIView
/** 商品详情 */
@property(nonatomic,strong) DSGoodsDetail *goodsDetail;
/* 操作点击 */
@property(nonatomic,copy) goodsHandleCall goodsHandleCall;
@end

NS_ASSUME_NONNULL_END
