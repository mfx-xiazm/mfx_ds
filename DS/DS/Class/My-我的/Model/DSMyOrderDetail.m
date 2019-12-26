//
//  DSMyOrderDetail.m
//  DS
//
//  Created by 夏增明 on 2019/12/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMyOrderDetail.h"

@implementation DSMyOrderDetail
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list_goods":[DSMyOrderDetailGoods class],
             @"refund_address":[DSMyOrderRefundAddress class]
             };
}
-(void)setRemarks:(NSString *)remarks
{
    if (remarks && remarks.length) {
        _remarks = [NSString stringWithFormat:@"备注：%@",remarks];
    }else{
        _remarks = @"暂无备注";
    }
    CGFloat remarkTextHeight = [_remarks textHeightSize:CGSizeMake(HX_SCREEN_WIDTH-15.f*2, CGFLOAT_MAX) font:[UIFont systemFontOfSize:13] lineSpacing:5.f];
    _remarkTextHeight = 15.f + remarkTextHeight+5.f + 15.f;
}
@end

@implementation DSMyOrderDetailGoods
-(NSString *)is_discount
{
    if (_discount_price && _price) {
        if ([_discount_price floatValue] == [_price floatValue]) {
            return @"0";
        }else{
            return @"1";
        }
    }else{
        return @"0";
    }
}
@end

@implementation DSMyOrderRefundAddress

@end
