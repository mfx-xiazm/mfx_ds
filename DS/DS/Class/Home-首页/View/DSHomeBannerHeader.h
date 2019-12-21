//
//  DSHomeBannerHeader.h
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "ZLCollectionReusableView.h"

NS_ASSUME_NONNULL_BEGIN
@class DSHomeBanner;
typedef void(^bannerClickCall)(NSInteger index);
@interface DSHomeBannerHeader : ZLCollectionReusableView
/* benner */
@property(nonatomic,strong) NSArray<DSHomeBanner *> *adv;
/* 点击 */
@property(nonatomic,copy) bannerClickCall bannerClickCall;
@end

NS_ASSUME_NONNULL_END
