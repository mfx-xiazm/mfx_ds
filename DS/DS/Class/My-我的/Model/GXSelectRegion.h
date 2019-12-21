//
//  GXSelectRegion.h
//  GX
//
//  Created by 夏增明 on 2019/10/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GXRegion,GXRegionCity,GXRegionArea,GXRegionTown;
@interface GXSelectRegion : NSObject
/* 所有地区 */
@property(nonatomic,strong) NSArray *regions;
/* 选中的省 */
@property(nonatomic,strong) GXRegion *selectRegion;
/* 选中的市 */
@property(nonatomic,strong) GXRegionCity *selectCity;
/* 选中的区 */
@property(nonatomic,strong) GXRegionArea *selectArea;
@end

NS_ASSUME_NONNULL_END
