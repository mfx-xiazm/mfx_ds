//
//  GXRegionArea.h
//  GX
//
//  Created by 夏增明 on 2019/10/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GXRegionCity,GXRegionArea;
@interface GXRegion : NSObject
@property (nonatomic, strong) NSArray<GXRegionCity *> *city;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *alias;
@end

@interface GXRegionCity : NSObject
@property (nonatomic, strong) NSArray<GXRegionArea *> *area;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *alias;
@end

@interface GXRegionArea : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *alias;
@end

NS_ASSUME_NONNULL_END
