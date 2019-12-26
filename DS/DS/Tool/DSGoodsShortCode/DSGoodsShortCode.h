//
//  DSGoodsShortCode.h
//  DS
//
//  Created by 夏增明 on 2019/12/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSGoodsShortCode : NSObject
+ (instancetype)sharedInstance;
/** 检查剪切板有没有本APP的口令 */
-(void)checkShortCodePush;
@end

NS_ASSUME_NONNULL_END
