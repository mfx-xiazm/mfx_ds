//
//  DSGoodsPosterView.m
//  DS
//
//  Created by 夏增明 on 2019/11/20.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSGoodsPosterView.h"
#import "TYSnapshotScroll.h"
#import "DSGoodsDetail.h"
#import "SGQRCode.h"
#import "DSPosterContentView.h"

@interface DSGoodsPosterView ()
@property (weak, nonatomic) IBOutlet UIView *contentBgView;
/* 内容视图 */
@property(nonatomic,strong) DSPosterContentView *contentView;
@end
@implementation DSGoodsPosterView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.contentBgView insertSubview:self.contentView atIndex:0];
}
-(DSPosterContentView *)contentView
{
    if (_contentView == nil) {
        _contentView = [DSPosterContentView loadXibView];
        _contentView.frame = self.contentBgView.bounds;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.showsVerticalScrollIndicator = NO;
    }
    return _contentView;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.contentBgView.bounds;
}
-(void)setGoodsDetail:(DSGoodsDetail *)goodsDetail
{
    _goodsDetail = goodsDetail;
    self.contentView.goodsDetail = _goodsDetail;
}
- (IBAction)posterTypeClicked:(UIButton *)sender {
    if (sender.tag) {
        UIImage* image = nil;
        UIGraphicsBeginImageContext(_contentView.contentSize);

        CGPoint savedContentOffset = _contentView.contentOffset;
        CGRect savedFrame = _contentView.frame;

        _contentView.contentOffset = CGPointZero;
        _contentView.frame = CGRectMake(0, 0, _contentView.contentSize.width, _contentView.contentSize.height);

        [_contentView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();

        _contentView.contentOffset = savedContentOffset;
        _contentView.frame = savedFrame;

        UIGraphicsEndImageContext();

        if (image != nil) {
            if (self.posterTypeCall) {
                self.posterTypeCall(sender.tag, image);
            }
        }
    }else{
        if (self.posterTypeCall) {
            self.posterTypeCall(sender.tag, nil);
        }
    }
}

@end
