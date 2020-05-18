//
//  DSPosterContentView.m
//  DS
//
//  Created by 夏增明 on 2019/12/23.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSPosterContentView.h"
#import "DSGoodsDetail.h"
#import "SGQRCodeObtain.h"

@interface DSPosterContentView ()
@property (weak, nonatomic) IBOutlet UIImageView *advart;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *goods_img;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *discount_price;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *codeImg;
@end
@implementation DSPosterContentView

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setGoodsDetail:(DSGoodsDetail *)goodsDetail
{
    _goodsDetail = goodsDetail;
    
    [self.advart sd_setImageWithURL:[NSURL URLWithString:[MSUserManager sharedInstance].curUserInfo.avatar] placeholderImage:HXGetImage(@"avatar")];
    self.name.text = [MSUserManager sharedInstance].curUserInfo.nick_name;
    
    [self.goods_img sd_setImageWithURL:[NSURL URLWithString:_goodsDetail.cover_img] placeholderImage:HXGetImage(@"avatar")];
    [self.goodsName addFlagLabelWithName:_goodsDetail.cate_flag lineSpace:5.f titleString:_goodsDetail.goods_name withFont:[UIFont systemFontOfSize:12]];
    [self.discount_price setFontAttributedText:[NSString stringWithFormat:@"¥%.2f",[_goodsDetail.discount_price floatValue]] andChangeStr:@"¥" andFont:[UIFont systemFontOfSize:10]];
    [self.price setLabelUnderline:[NSString stringWithFormat:@"¥%.2f",[_goodsDetail.price floatValue]]];
    self.codeImg.image = [SGQRCodeObtain generateQRCodeWithData:_goodsDetail.share_url size:self.codeImg.hxn_width*3];
}
@end
