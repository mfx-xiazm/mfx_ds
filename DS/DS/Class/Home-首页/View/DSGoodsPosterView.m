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

@interface DSGoodsPosterView ()
@property (weak, nonatomic) IBOutlet UIScrollView *contentBgView;
@property (weak, nonatomic) IBOutlet UIImageView *advart;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *goods_img;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *discount_price;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *codeImg;

@end
@implementation DSGoodsPosterView

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setGoodsDetail:(DSGoodsDetail *)goodsDetail
{
    _goodsDetail = goodsDetail;
    
    [self.advart sd_setImageWithURL:[NSURL URLWithString:[MSUserManager sharedInstance].curUserInfo.avatar]];
    self.name.text = [MSUserManager sharedInstance].curUserInfo.nick_name;
    
    [self.goods_img sd_setImageWithURL:[NSURL URLWithString:_goodsDetail.cover_img]];
    [self.goodsName setTextWithLineSpace:5.f withString:_goodsDetail.goods_name withFont:[UIFont systemFontOfSize:14]];
    self.discount_price.text = [NSString stringWithFormat:@"￥%@",_goodsDetail.discount_price];
    [self.price setLabelUnderline:[NSString stringWithFormat:@"￥%@",_goodsDetail.price]];
    self.codeImg.image = [SGQRCodeObtain generateQRCodeWithData:_goodsDetail.share_url size:self.codeImg.hxn_width];
}
- (IBAction)posterTypeClicked:(UIButton *)sender {
    if (sender.tag) {
//        hx_weakify(self);
//        UIImage* image = nil;
//        UIGraphicsBeginImageContext(_contentBgView.contentSize);
//        {
//            CGPoint savedContentOffset = _contentBgView.contentOffset;
//            CGRect savedFrame = _contentBgView.frame;
//
//            _contentBgView.contentOffset = CGPointZero;
//            _contentBgView.frame = CGRectMake(0, 0, _contentBgView.contentSize.width, _contentBgView.contentSize.height);
//
//            [_contentBgView.layer renderInContext: UIGraphicsGetCurrentContext()];
//            image = UIGraphicsGetImageFromCurrentImageContext();
//
//            _contentBgView.contentOffset = savedContentOffset;
//            _contentBgView.frame = savedFrame;
//        }
//        UIGraphicsEndImageContext();
//
//        if (image != nil) {
//            self.goods_img.image = image;
//        }
    
//        if (@available(iOS 13.0, *)) {
//            //因iOS13在使用AutoLayout的情况下，手动修改contentSize失效，并且因AutoLayout的布局情况太多，不能一一判断你，故相关操作以block处理,iOS12之前用老方法效率高，新方法会有递归
//            CGFloat oldTableViewHeight = self.contentLayoutHeight.constant;
//
//            [TYSnapshotScroll screenSnapshotWithMultipleScroll:self.contentBgView modifyLayoutBlock:^(CGFloat extraHeight) {
//                weakSelf.tableViewLayoutHeight.constant +=extraHeight;
//                [weakSelf.view layoutIfNeeded];
//            } finishBlock:^(UIImage *snapShotImage) {
//                weakSelf.tableViewLayoutHeight.constant = oldTableViewHeight;
//            }];
//        } else {
//            [TYSnapshotScroll screenSnapshot:self.contentBgView finishBlock:^(UIImage *snapShotImage) {
//                weakSelf.goods_img.image = snapShotImage;
//            }];
//        }
        
//        hx_strongify(weakSelf);
//        if (strongSelf.posterTypeCall) {
//            strongSelf.posterTypeCall(sender.tag, snapShotImage);
//        }
    }else{
        if (self.posterTypeCall) {
            self.posterTypeCall(sender.tag, nil);
        }
    }
}

@end
