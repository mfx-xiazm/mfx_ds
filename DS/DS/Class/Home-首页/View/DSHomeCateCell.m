//
//  DSHomeCateCell.m
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSHomeCateCell.h"
#import "DSHomeData.h"

@interface DSHomeCateCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cateImg;
@property (weak, nonatomic) IBOutlet UILabel *cateName;

@end
@implementation DSHomeCateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCate:(DSHomeCate *)cate
{
    _cate = cate;
    [self.cateImg sd_setImageWithURL:[NSURL URLWithString:_cate.cate_img]];
    self.cateName.text = _cate.cate_name;
}
@end
