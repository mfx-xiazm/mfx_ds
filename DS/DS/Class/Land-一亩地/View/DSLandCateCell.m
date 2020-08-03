//
//  DSLandCateCell.m
//  DS
//
//  Created by huaxin-01 on 2020/8/3.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSLandCateCell.h"
#import "DSLand.h"

@interface DSLandCateCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cateImg;
@property (weak, nonatomic) IBOutlet UILabel *cateName;

@end
@implementation DSLandCateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCate:(DSLandAdv *)cate
{
    _cate = cate;
    [self.cateImg sd_setImageWithURL:[NSURL URLWithString:_cate.adv_img]];
    self.cateName.text = _cate.adv_name;
}
@end
