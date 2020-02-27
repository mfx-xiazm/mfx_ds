//
//  DSTaoGoodsDetailVC.h
//  DS
//
//  Created by 夏增明 on 2020/2/27.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSTaoGoodsDetailVC : HXBaseViewController
/* 商品id */
@property(nonatomic,copy) NSString *goods_id;
/* 分享人uid */
@property(nonatomic,copy) NSString *share_uid;
@end

NS_ASSUME_NONNULL_END
