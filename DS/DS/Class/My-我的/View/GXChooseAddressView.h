//
//  GXChooseAddressView.h
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXRegion.h"

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

NS_ASSUME_NONNULL_BEGIN

@class GXSelectRegion;
@interface GXChooseAddressView : UIView
@property (nonatomic, strong) GXSelectRegion *region;

@property (nonatomic, copy) void(^lastComponentClickedBlock)(NSInteger type,GXSelectRegion * _Nullable region);
@end

NS_ASSUME_NONNULL_END
