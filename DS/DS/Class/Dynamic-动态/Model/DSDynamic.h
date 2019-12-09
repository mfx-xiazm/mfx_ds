//
//  DSDynamic.h
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSDynamic : NSObject
/** 内容文本 */
@property(nonatomic,copy)NSString *dsp;
/** 用户昵称 */
@property(nonatomic,copy)NSString *nick;
/** 用户头像 */
@property(nonatomic,copy)NSString *portrait;
/** 时间 */
@property(nonatomic,copy)NSString *creatTime;
/** 分享数量 */
@property(nonatomic,copy)NSString *shareNum;
/** 照片数组 */
@property(nonatomic,strong)NSArray *photos;
@end

NS_ASSUME_NONNULL_END
