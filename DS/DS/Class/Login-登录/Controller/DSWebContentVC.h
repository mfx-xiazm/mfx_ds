//
//  DSWebContentVC.h
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSWebContentVC : HXBaseViewController
/** url */
@property (nonatomic,copy) NSString *url;
/** 富文本 */
@property (nonatomic,copy) NSString *htmlContent;
/** 标题 */
@property(nonatomic,copy) NSString *navTitle;
/** 是否需要请求 */
@property(nonatomic,assign) BOOL isNeedRequest;
/** 1banner详情 2消息详情 3会员权益说明 4会员自购省钱说明 5用户注册协议 6用户隐私协议 7京东商品获取链接*/
@property(nonatomic,assign) NSInteger requestType;
/** banner_id */
@property(nonatomic,copy) NSString *adv_id;
/** 消息id */
@property(nonatomic,copy) NSString *msg_id;

@end

NS_ASSUME_NONNULL_END
