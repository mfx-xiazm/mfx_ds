//
//  DSBannerCell.m
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSBannerCell.h"
#import "DSHomeData.h"
#import "DSGoodsDetail.h"
#import "DSLand.h"
#import "DSLandDetail.h"

@interface DSBannerCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bannerImg;

@end
@implementation DSBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setBanner:(DSHomeBanner *)banner
{
    _banner = banner;
//    self.bannerImg.layer.cornerRadius = 5.f;
//    self.bannerImg.layer.masksToBounds = YES;
    [self.bannerImg sd_setImageWithURL:[NSURL URLWithString:_banner.adv_img]];
}
-(void)setAdv:(DSGoodsAdv *)adv
{
    _adv = adv;
    self.bannerImg.layer.cornerRadius = 0.f;
    self.bannerImg.layer.masksToBounds = YES;
    [self.bannerImg sd_setImageWithURL:[NSURL URLWithString:_adv.adv_img]];
}
-(void)setLandAdv:(DSLandAdv *)landAdv
{
    _landAdv = landAdv;
    self.bannerImg.layer.cornerRadius = 0.f;
    self.bannerImg.layer.masksToBounds = YES;
    [self.bannerImg sd_setImageWithURL:[NSURL URLWithString:_landAdv.adv_img]];
}

-(void)setLandGoodsAdv:(DSLandGoodsAdv *)landGoodsAdv
{
    _landGoodsAdv = landGoodsAdv;
    self.bannerImg.layer.cornerRadius = 0.f;
    self.bannerImg.layer.masksToBounds = YES;
    [self.bannerImg sd_setImageWithURL:[NSURL URLWithString:_landGoodsAdv.adv_img]];
}
@end
