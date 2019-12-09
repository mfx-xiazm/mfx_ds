//
//  DSGoodsPosterView.m
//  DS
//
//  Created by 夏增明 on 2019/11/20.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSGoodsPosterView.h"
#import "TYSnapshotScroll.h"

@interface DSGoodsPosterView ()
@property (weak, nonatomic) IBOutlet UIScrollView *contentBgView;
@property (weak, nonatomic) IBOutlet UIImageView *goods_img;
@end
@implementation DSGoodsPosterView

-(void)awakeFromNib
{
    [super awakeFromNib];
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
