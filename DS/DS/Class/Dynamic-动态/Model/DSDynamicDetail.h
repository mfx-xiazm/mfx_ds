//
//  DSDynamicDetail.h
//  DS
//
//  Created by 夏增明 on 2019/12/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DSDynamicInfo,DSDynamicContent;
@interface DSDynamicDetail : NSObject
@property(nonatomic,strong) DSDynamicInfo *treads;
@property(nonatomic,strong) NSArray<DSDynamicContent *> *list_content;

@end

@interface DSDynamicInfo : NSObject
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *treads_title;
@property(nonatomic,copy) NSString *create_time;
@property(nonatomic,copy) NSString *nick_name;
@property(nonatomic,copy) NSString *praise_num;
@property(nonatomic,copy) NSString *avatar;
@property(nonatomic,copy) NSString *treads_id;
@property(nonatomic,strong)NSString *share_url;
@property(nonatomic,assign) BOOL is_praise;

@end
@interface DSDynamicContent : NSObject
@property(nonatomic,copy) NSString *content_type;
@property(nonatomic,copy) NSString *content;

@end
NS_ASSUME_NONNULL_END
