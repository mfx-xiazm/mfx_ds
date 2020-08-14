//
//  DSMyOrderCell.m
//  DS
//
//  Created by 夏增明 on 2019/11/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMyOrderCell.h"
#import "DSConfirmOrder.h"
#import "DSMyOrder.h"
#import "DSMyOrderDetail.h"

@interface DSMyOrderCell ()
@property (weak, nonatomic) IBOutlet UIView *vipGoodsView;
@property (weak, nonatomic) IBOutlet UIImageView *vipCoverImg;
@property (weak, nonatomic) IBOutlet UILabel *vipGoodName;
@property (weak, nonatomic) IBOutlet UILabel *vipPrice;
@property (weak, nonatomic) IBOutlet UILabel *vip_goods_num;
@property (weak, nonatomic) IBOutlet UILabel *specs_attrs;
@property (weak, nonatomic) IBOutlet UILabel *vip_flag;

@end
@implementation DSMyOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setGoods:(DSConfirmGoods *)goods
{
    _goods = goods;
    self.vipGoodsView.hidden = NO;

    [self.vipCoverImg sd_setImageWithURL:[NSURL URLWithString:_goods.cover_img]];
    [self.vipGoodName setTextWithLineSpace:5.f withString:_goods.goods_name withFont:[UIFont systemFontOfSize:14]];
    [self.vipPrice setFontAttributedText:[NSString stringWithFormat:@"¥%@",[goods.is_discount isEqualToString:@"1"]?[_goods.discount_price reviseString]:[_goods.price reviseString]] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:12]]];
    [self.vip_goods_num setFontAttributedText:[NSString stringWithFormat:@"x%@",_goods.goods_num] andChangeStr:@[@"x"] andFont:@[[UIFont systemFontOfSize:12]]];
}
-(void)setOrderGoods:(DSMyOrderGoods *)orderGoods
{
    _orderGoods = orderGoods;

    self.vipGoodsView.hidden = NO;
    
    [self.vipCoverImg sd_setImageWithURL:[NSURL URLWithString:_orderGoods.cover_img]];
    if ([_order_type isEqualToString:@"10"]) {
        self.vipGoodName.numberOfLines = [_ymd_send_member isEqualToString:@"1"]?1:2;
        self.specs_attrs.hidden = ([_ymd_type isEqualToString:@"1"] || [_ymd_type isEqualToString:@"4"])?NO:YES;
        self.specs_attrs.text = _orderGoods.specs_attrs;
        self.vip_flag.hidden = [_ymd_send_member isEqualToString:@"1"]?NO:YES;
    }else{
        self.vipGoodName.numberOfLines = 2;
        self.specs_attrs.hidden = YES;
        self.vip_flag.hidden = YES;
    }
    [self.vipGoodName setTextWithLineSpace:5.f withString:_orderGoods.goods_name withFont:[UIFont systemFontOfSize:14]];
    [self.vipPrice setFontAttributedText:[NSString stringWithFormat:@"¥%@",[_orderGoods.is_discount isEqualToString:@"1"]?[_orderGoods.discount_price reviseString]:[_orderGoods.price reviseString]] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:12]]];
    [self.vip_goods_num setFontAttributedText:[NSString stringWithFormat:@"x%@",_orderGoods.goods_num] andChangeStr:@[@"x"] andFont:@[[UIFont systemFontOfSize:12]]];
}
-(void)setDetailGoods:(DSMyOrderDetailGoods *)detailGoods
{
    _detailGoods = detailGoods;

    self.vipGoodsView.hidden = NO;
    
    [self.vipCoverImg sd_setImageWithURL:[NSURL URLWithString:_detailGoods.cover_img]];
    if ([_order_type isEqualToString:@"10"]) {
        self.vipGoodName.numberOfLines = [_ymd_send_member isEqualToString:@"1"]?1:2;
        self.specs_attrs.hidden = ([_ymd_type isEqualToString:@"1"] || [_ymd_type isEqualToString:@"4"])?NO:YES;
        self.specs_attrs.text = _detailGoods.specs_attrs;
        self.vip_flag.hidden = [_ymd_send_member isEqualToString:@"1"]?NO:YES;
    }else{
        self.vipGoodName.numberOfLines = 2;
        self.specs_attrs.hidden = YES;
        self.vip_flag.hidden = YES;
    }
    [self.vipGoodName setTextWithLineSpace:5.f withString:_detailGoods.goods_name withFont:[UIFont systemFontOfSize:14]];
    [self.vipPrice setFontAttributedText:[NSString stringWithFormat:@"¥%@",[_detailGoods.is_discount isEqualToString:@"1"]?[_detailGoods.discount_price reviseString]:[_detailGoods.price reviseString]] andChangeStr:@[@"¥"] andFont:@[[UIFont systemFontOfSize:12]]];
    [self.vip_goods_num setFontAttributedText:[NSString stringWithFormat:@"x%@",_detailGoods.goods_num] andChangeStr:@[@"x"] andFont:@[[UIFont systemFontOfSize:12]]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
