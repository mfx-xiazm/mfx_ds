//
//  DSCateGoodsChildVC.h
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSCateGoodsChildVC : HXBaseViewController
/* 二级分类id */
@property(nonatomic,copy) NSString *cate_id;
/* 分类方式 */
@property(nonatomic,copy) NSString *cate_mode;
@end

NS_ASSUME_NONNULL_END
