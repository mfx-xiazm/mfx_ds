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

@property (nonatomic, assign) NSInteger cartCnt;
@property (nonatomic, assign) NSInteger collectCnt;
@property (nonatomic, assign) NSInteger teamCnt;
@property (nonatomic, assign) NSInteger cardCnt;

@property (nonatomic, strong) NSArray * orderCnt;

@property (nonatomic, assign) NSInteger noPayCnt;
@property (nonatomic, assign) NSInteger noDeCnt;
@property (nonatomic, assign) NSInteger noTakeCnt;
@property (nonatomic, assign) NSInteger completeCnt;
@property (nonatomic, assign) NSInteger trfundCnt;

//yg_amount
@property(nonatomic,assign) CGFloat total_amount;
@property(nonatomic,assign) CGFloat today_amount;
@property(nonatomic,assign) CGFloat last_month_amount;
@property(nonatomic,assign) CGFloat cur_month_amount;

@end

