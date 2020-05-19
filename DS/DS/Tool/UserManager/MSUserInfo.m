//
//  MSUserInfo.m
//  KYPX
//
//  Created by hxrc on 2018/2/9.
//  Copyright © 2018年 KY. All rights reserved.
//

#import "MSUserInfo.h"

@implementation MSUserInfo
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"total_amount":@"total",
             @"today_amount":@"yg_amount.yg_today_amount",
             @"last_month_amount":@"yg_amount.yg_last_month_amount",
             @"cur_month_amount":@"yg_amount.yg_cur_month_amount"
    };
}
-(void)setOrderCnt:(NSArray *)orderCnt
{
    _orderCnt = orderCnt;
    if (_orderCnt.count) {
        for (NSDictionary *dict in _orderCnt) {
            if ([dict[@"status"] isEqualToString:@"待付款"]) {
                _noPayCnt = [dict[@"cnt"] integerValue];
            }else if ([dict[@"status"] isEqualToString:@"待发货"]) {
                _noDeCnt = [dict[@"cnt"] integerValue];
            }else if ([dict[@"status"] isEqualToString:@"待收货"]) {
                _noTakeCnt = [dict[@"cnt"] integerValue];
            }else if ([dict[@"status"] isEqualToString:@"已完成"]) {
                _completeCnt = [dict[@"cnt"] integerValue];
            }else{
                _trfundCnt = [dict[@"cnt"] integerValue];
            }
        }
    }else{
        _noPayCnt = 0;
        _noDeCnt = 0;
        _noTakeCnt = 0;
        _completeCnt = 0;
        _trfundCnt = 0;
    }
}
@end
