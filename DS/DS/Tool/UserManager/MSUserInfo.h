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
@property (nonatomic, strong) NSString * nick_name;
@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * avatar;
/** 1买家 2经销商 3技工 */
@property (nonatomic, assign) NSInteger utype;

@end

