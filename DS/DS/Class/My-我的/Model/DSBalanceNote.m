//
//  DSBalanceNote.m
//  DS
//
//  Created by 夏增明 on 2019/12/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSBalanceNote.h"

@implementation DSBalanceNote
-(CGFloat)textHeight
{
    if ([_finance_log_type isEqualToString:@"2"] || [_finance_log_type isEqualToString:@"3"] || [_finance_log_type isEqualToString:@"4"] || [_finance_log_type isEqualToString:@"5"]) {
        NSString *text = nil;
        if (_finance_log_desc && _finance_log_desc.length) {
           text = [NSString stringWithFormat:@"%@-%@",_finance_log_desc,_order_title];
        }else{
           text = _order_title;
        }
        return [text textHeightSize:CGSizeMake(HX_SCREEN_WIDTH-20.f*2, CGFLOAT_MAX) font:[UIFont systemFontOfSize:13] lineSpacing:3.f] + 2.f;
    }
    return 0.f;
}
-(NSString *)create_time
{
    if (_create_time.length > 10) {
        return [_create_time substringToIndex:10];
    }
    return _create_time;
}
@end
