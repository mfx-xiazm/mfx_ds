//
//  MSUserInfo.h
//  KYPX
//
//  Created by hxrc on 2018/2/9.
//  Copyright © 2018年 KY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSUserInfo : NSObject

@property (nonatomic, strong) NSString * uid;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * sex;
@property (nonatomic, strong) NSString * share_code;
@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * nick_name;
@property (nonatomic, strong) NSString * ulevel_name;
@property (nonatomic, assign) NSInteger ulevel;

@end

