//
//  DSAfreshHomeHeader.h
//  DS
//
//  Created by huaxin-01 on 2020/5/18.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSHomeData;
typedef void(^headerClickCall)(NSInteger type,NSInteger index);
@interface DSAfreshHomeHeader : UIView
@property (nonatomic, strong) DSHomeData *homeData;
@property (nonatomic, copy) headerClickCall headerClickCall;
@end

NS_ASSUME_NONNULL_END
