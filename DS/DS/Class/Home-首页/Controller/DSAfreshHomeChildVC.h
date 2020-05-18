//
//  DSAfreshHomeChildVC.h
//  DS
//
//  Created by huaxin-01 on 2020/5/18.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSAfreshHomeChildVC : HXBaseViewController <JXPagerViewListViewDelegate>
/* 二级分类id */
@property(nonatomic,copy) NSString *cate_id;
/* 分类方式 */
@property(nonatomic,copy) NSString *cate_mode;
/* 数据加载 */
-(void)getGoodsListDataRequest:(BOOL)isRefresh contentScrollView:(UIScrollView *)contentScrollView;
@end

NS_ASSUME_NONNULL_END
