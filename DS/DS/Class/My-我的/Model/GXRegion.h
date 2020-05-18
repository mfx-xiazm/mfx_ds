//
//  GXRegionArea.h
//  GX
//
//  Created by 夏增明 on 2019/10/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GXRegionCity,GXRegionArea,GXRegionDistrict;
@interface GXRegion : NSObject
@property (nonatomic, strong) NSArray<GXRegionCity *> *children;
@property (nonatomic, copy) NSString *area_id;
@property (nonatomic, copy) NSString *area_alias;
@end

@interface GXRegionCity : NSObject
@property (nonatomic, strong) NSArray<GXRegionArea *> *children;
@property (nonatomic, copy) NSString *area_id;
@property (nonatomic, copy) NSString *area_alias;
@end

@interface GXRegionArea : NSObject
@property (nonatomic, strong) NSArray<GXRegionDistrict *> *children;
@property (nonatomic, copy) NSString *area_id;
@property (nonatomic, copy) NSString *area_alias;
@end

@interface GXRegionDistrict : NSObject
@property (nonatomic, copy) NSString *area_id;
@property (nonatomic, copy) NSString *area_alias;
@end

NS_ASSUME_NONNULL_END
