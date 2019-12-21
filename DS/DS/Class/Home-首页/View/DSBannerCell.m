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
    [self.bannerImg sd_setImageWithURL:[NSURL URLWithString:_banner.adv_img]];
}
-(void)setAdv:(DSGoodsAdv *)adv
{
    _adv = adv;
    [self.bannerImg sd_setImageWithURL:[NSURL URLWithString:_adv.adv_img]];
}
@end
