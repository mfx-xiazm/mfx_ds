//
//  DSVipGoodsDetailVC.h
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSVipGoodsDetailVC : HXBaseViewController
/* 商品id */
@property(nonatomic,copy) NSString *goods_id;
/* 是否是淘宝自营 */
@property(nonatomic,assign) BOOL isTaoke;
@end

NS_ASSUME_NONNULL_END
