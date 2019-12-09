//
//  GXSaveImageToPHAsset.h
//  GX
//
//  Created by 夏增明 on 2019/11/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^saveComletedCall)(void);
@interface GXSaveImageToPHAsset : NSObject
/* 控制器 */
@property(nonatomic,weak) UIViewController *targetVC;
/* 保存成功 */
@property(nonatomic,copy) saveComletedCall saveComletedCall;
/**保存图片到自定义相册*/
- (void)saveImages:(NSArray *)imageArrs comletedCall:(saveComletedCall _Nullable)comletedCall;
@end

NS_ASSUME_NONNULL_END
