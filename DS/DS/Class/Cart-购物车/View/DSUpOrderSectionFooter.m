//
//  DSUpOrderSectionFooter.m
//  DS
//
//  Created by 夏增明 on 2020/2/18.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSUpOrderSectionFooter.h"
#import "DSConfirmOrder.h"

@interface DSUpOrderSectionFooter ()
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
@implementation DSUpOrderSectionFooter

-(void)setGoods:(DSConfirmGoods *)goods
{
    _goods = goods;
    [self.price setFontAttributedText:[NSString stringWithFormat:@"￥%.2f",_goods.totalPrice] andChangeStr:@"￥" andFont:[UIFont systemFontOfSize:12]];
}

@end
