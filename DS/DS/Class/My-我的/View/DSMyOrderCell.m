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
    self.vipGoodsView.hidden = YES;
    self.goodsView.hidden = NO;
    
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:_goods.cover_img]];
    self.goodName.text = _goods.goods_name;
    self.price.text = [NSString stringWithFormat:@"折扣价￥%@",_goods.discount_price];
    self.marketPrice.text = [NSString stringWithFormat:@"市场价￥%@",_goods.price];
    self.bankPrice.text = [NSString stringWithFormat:@"返佣金额：%@",_goods.cmm_price];
    self.specs_attrs.text = [NSString stringWithFormat:@"规格：%@",_goods.specs_attrs];
    self.goods_num.text = [NSString stringWithFormat:@"数量：%@",_goods.goods_num];

}
-(void)setOrderGoods:(DSMyOrderGoods *)orderGoods
{
    _orderGoods = orderGoods;

    if ([self.order_type isEqualToString:@"1"]) {
        self.vipGoodsView.hidden = YES;
        self.goodsView.hidden = NO;
        
        [self.coverImg sd_setImageWithURL:[NSURL URLWithString:_orderGoods.cover_img]];
        self.goodName.text = _orderGoods.goods_name;
        self.price.text = [NSString stringWithFormat:@"折扣价￥%@",_orderGoods.discount_amount];
        self.marketPrice.text = [NSString stringWithFormat:@"市场价￥%@",_orderGoods.price];
        self.bankPrice.text = [NSString stringWithFormat:@"返佣金额：%@",_orderGoods.self_commission];
        self.specs_attrs.text = [NSString stringWithFormat:@"规格：%@",_orderGoods.specs_attrs];
        self.goods_num.text = [NSString stringWithFormat:@"数量：%@",_orderGoods.goods_num];
    }else{
        self.vipGoodsView.hidden = NO;
        self.goodsView.hidden = YES;
        
        [self.vipCoverImg sd_setImageWithURL:[NSURL URLWithString:_orderGoods.cover_img]];
        self.vipGoodName.text = _orderGoods.goods_name;
        self.vipPrice.text = [NSString stringWithFormat:@"￥%@",_orderGoods.discount_amount];
        self.vip_goods_num.text = [NSString stringWithFormat:@"数量：%@",_orderGoods.goods_num];
    }
}
-(void)setDetailGoods:(DSMyOrderDetailGoods *)detailGoods
{
    _detailGoods = detailGoods;
    if ([self.order_type isEqualToString:@"1"]) {
        self.vipGoodsView.hidden = YES;
        self.goodsView.hidden = NO;
        
        [self.coverImg sd_setImageWithURL:[NSURL URLWithString:_detailGoods.cover_img]];
        self.goodName.text = _detailGoods.goods_name;
        self.price.text = [NSString stringWithFormat:@"折扣价￥%@",_detailGoods.discount_amount];
        self.marketPrice.text = [NSString stringWithFormat:@"市场价￥%@",_detailGoods.price];
        self.bankPrice.text = [NSString stringWithFormat:@"返佣金额：%@",_detailGoods.self_commission];
        self.specs_attrs.text = [NSString stringWithFormat:@"规格：%@",_detailGoods.specs_attrs];
        self.goods_num.text = [NSString stringWithFormat:@"数量：%@",_detailGoods.goods_num];
    }else{
        self.vipGoodsView.hidden = NO;
        self.goodsView.hidden = YES;
        
        [self.vipCoverImg sd_setImageWithURL:[NSURL URLWithString:_detailGoods.cover_img]];
        self.vipGoodName.text = _detailGoods.goods_name;
        self.vipPrice.text = [NSString stringWithFormat:@"￥%@",_detailGoods.discount_amount];
        self.vip_goods_num.text = [NSString stringWithFormat:@"数量：%@",_detailGoods.goods_num];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
