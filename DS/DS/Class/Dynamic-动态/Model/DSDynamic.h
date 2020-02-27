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
/** 会员i标签 */
@property(nonatomic,copy)NSString *member_flag;
/** 用户昵称 */
@property(nonatomic,copy)NSString *nick;
/** 用户头像 */
@property(nonatomic,copy)NSString *portrait;
/** 时间 */
@property(nonatomic,copy)NSString *creatTime;
/** 照片数组 */
@property(nonatomic,strong)NSArray *photos;
/** 用户id */
@property(nonatomic,copy)NSString *uid;
/** 点赞数量 */
@property(nonatomic,copy)NSString *praise_num;
/** 是否点赞 */
@property(nonatomic,assign) BOOL is_praise;
/** 动态id */
@property(nonatomic,copy)NSString *treads_id;
/** 照片数组 */
@property(nonatomic,strong)NSArray *list_content;
/** 分享链接 */
@property(nonatomic,strong)NSString *share_url;

@end

NS_ASSUME_NONNULL_END
