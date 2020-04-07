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
@property (weak, nonatomic) IBOutlet UIView *goodsView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *marketPrice;
@property (weak, nonatomic) IBOutlet UILabel *bankPrice;
@property (weak, nonatomic) IBOutlet UILabel *specs_attrs;
@property (weak, nonatomic) IBOutlet UILabel *goods_num;

@property (weak, nonatomic) IBOutlet UIView *vipGoodsView;
@property (weak, nonatomic) IBOutlet UIImageView *vipCoverImg;
@property (weak, nonatomic) IBOutlet UILabel *vipGoodName;
@property (weak, nonatomic) IBOutlet UILabel *vipPrice;
@property (weak, nonatomic) IBOutlet UILabel *vip_goods_num;

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
    self.goodsView.hidden = YES;
    
//    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:_goods.cover_img]];
//    self.goodName.text = _goods.goods_name;
//    self.price.text = [NSString stringWithFormat:@"折扣价￥%.2f",[_goods.discount_price floatValue]];
//    self.marketPrice.text = [NSString stringWithFormat:@"原价￥%.2f",[_goods.price floatValue]];
//    self.bankPrice.text = [NSString stringWithFormat:@"现金补贴：%.2f",[_goods.cmm_price floatValue]];
//    self.specs_attrs.text = [NSString stringWithFormat:@"规格：%@",_goods.specs_attrs];
//    self.goods_num.text = [NSString stringWithFormat:@"数量：%@",_goods.goods_num];

    [self.vipCoverImg sd_setImageWithURL:[NSURL URLWithString:_goods.cover_img]];
    [self.vipGoodName setTextWithLineSpace:5.f withString:_goods.goods_name withFont:[UIFont systemFontOfSize:14]];
    [self.vipPrice setFontAttributedText:[NSString stringWithFormat:@"￥%.2f",[goods.is_discount isEqualToString:@"1"]?[_goods.discount_price floatValue]:[_goods.price floatValue]] andChangeStr:@"￥" andFont:[UIFont systemFontOfSize:12]];
    [self.vip_goods_num setFontAttributedText:[NSString stringWithFormat:@"x%@",_goods.goods_num] andChangeStr:@"x" andFont:[UIFont systemFontOfSize:12]];
}
-(void)setOrderGoods:(DSMyOrderGoods *)orderGoods
{
    _orderGoods = orderGoods;

//    if ([self.order_type isEqualToString:@"1"]) {
//        self.vipGoodsView.hidden = YES;
//        self.goodsView.hidden = NO;
//
//        [self.coverImg sd_setImageWithURL:[NSURL URLWithString:_orderGoods.cover_img]];
//        self.goodName.text = _orderGoods.goods_name;
//        self.price.text = [NSString stringWithFormat:@"折扣价￥%.2f",[_orderGoods.discount_price floatValue]];
//        self.marketPrice.text = [NSString stringWithFormat:@"原价￥%.2f",[_orderGoods.price floatValue]];
//        self.bankPrice.text = [NSString stringWithFormat:@"现金补贴：%.2f",[_orderGoods.cmm_price floatValue]];
//        self.specs_attrs.text = [NSString stringWithFormat:@"规格：%@",_orderGoods.specs_attrs];
//        self.goods_num.text = [NSString stringWithFormat:@"数量：%@",_orderGoods.goods_num];
//    }else{
        self.vipGoodsView.hidden = NO;
        self.goodsView.hidden = YES;
        
        [self.vipCoverImg sd_setImageWithURL:[NSURL URLWithString:_orderGoods.cover_img]];
        [self.vipGoodName setTextWithLineSpace:5.f withString:_orderGoods.goods_name withFont:[UIFont systemFontOfSize:14]];
        [self.vipPrice setFontAttributedText:[NSString stringWithFormat:@"￥%.2f",[_orderGoods.is_discount isEqualToString:@"1"]?[_orderGoods.discount_price floatValue]:[_orderGoods.price floatValue]] andChangeStr:@"￥" andFont:[UIFont systemFontOfSize:12]];
        [self.vip_goods_num setFontAttributedText:[NSString stringWithFormat:@"x%@",_orderGoods.goods_num] andChangeStr:@"x" andFont:[UIFont systemFontOfSize:12]];
//    }
}
-(void)setDetailGoods:(DSMyOrderDetailGoods *)detailGoods
{
    _detailGoods = detailGoods;
//    if ([self.order_type isEqualToString:@"1"]) {
//        self.vipGoodsView.hidden = YES;
//        self.goodsView.hidden = NO;
//
//        [self.coverImg sd_setImageWithURL:[NSURL URLWithString:_detailGoods.cover_img]];
//        self.goodName.text = _detailGoods.goods_name;
//        self.price.text = [NSString stringWithFormat:@"折扣价￥%.2f",[_detailGoods.discount_price floatValue]];
//        self.marketPrice.text = [NSString stringWithFormat:@"原价￥%.2f",[_detailGoods.price floatValue]];
//        self.bankPrice.text = [NSString stringWithFormat:@"现金补贴：%.2f",[_detailGoods.cmm_price floatValue]];
//        self.specs_attrs.text = [NSString stringWithFormat:@"规格：%@",_detailGoods.specs_attrs];
//        self.goods_num.text = [NSString stringWithFormat:@"数量：%@",_detailGoods.goods_num];
//    }else{
        self.vipGoodsView.hidden = NO;
        self.goodsView.hidden = YES;
        
        [self.vipCoverImg sd_setImageWithURL:[NSURL URLWithString:_detailGoods.cover_img]];
        [self.vipGoodName setTextWithLineSpace:5.f withString:_detailGoods.goods_name withFont:[UIFont systemFontOfSize:14]];
        [self.vipPrice setFontAttributedText:[NSString stringWithFormat:@"￥%.2f",[_detailGoods.is_discount isEqualToString:@"1"]?[_detailGoods.discount_price floatValue]:[_detailGoods.price floatValue]] andChangeStr:@"￥" andFont:[UIFont systemFontOfSize:12]];
        [self.vip_goods_num setFontAttributedText:[NSString stringWithFormat:@"x%@",_detailGoods.goods_num] andChangeStr:@"x" andFont:[UIFont systemFontOfSize:12]];
//    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
