//
//  DSChooseClassView.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSChooseClassView.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "DSChooseClassCell.h"
#import "DSChooseClassHeader.h"
#import "DSChooseClassFooter.h"

static NSString *const ChooseClassCell = @"ChooseClassCell";
static NSString *const ChooseClassHeader = @"ChooseClassHeader";
static NSString *const ChooseClassFooter = @"ChooseClassFooter";

@interface DSChooseClassView ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *market_price;
@property (weak, nonatomic) IBOutlet UILabel *stock_num;

@end
@implementation DSChooseClassView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DSChooseClassCell class]) bundle:nil] forCellWithReuseIdentifier:ChooseClassCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DSChooseClassHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ChooseClassHeader];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DSChooseClassFooter class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ChooseClassFooter];
}
- (IBAction)goodHandleClicked:(UIButton *)sender {
   
//    if (sender.tag) {
//        BOOL isChooseed = YES;
//        if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
//            for (GYGoodSpec *spec in self.goodsDetail.spec) {
//                if (!spec.selectSpec) {
//                    isChooseed = NO;
//                    break;
//                }
//            }
//        }
//        if (!isChooseed) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择商品规则"];
//            return;
//        }
//        if (self.goodsHandleCall) {
//            self.goodsHandleCall(sender.tag);
//        }
//    }else{
//        if (self.goodsHandleCall) {
//            self.goodsHandleCall(sender.tag);
//        }
//    }
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return LabelLayout;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DSChooseClassCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ChooseClassCell forIndexPath:indexPath];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(HX_SCREEN_WIDTH,40.f);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (section == 1)?CGSizeMake(HX_SCREEN_WIDTH,40.f):CGSizeZero;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        DSChooseClassHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ChooseClassHeader forIndexPath:indexPath];
        return header;
    }else{
        DSChooseClassFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ChooseClassFooter forIndexPath:indexPath];
//        footer.stock_num = [self.goodsDetail.stock_num integerValue];
//        footer.buy_num.text = [NSString stringWithFormat:@"%zd",self.goodsDetail.buyNum];
//        hx_weakify(self);
//        footer.buyNumCall = ^(NSInteger num) {
//            hx_strongify(weakSelf);
//            strongSelf.goodsDetail.buyNum = num;
//        };
        return (indexPath.section == 1)?footer:nil;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([@"1箱/6瓶" boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.width + 20, 30);

}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(10, 10, 10, 10);
}

@end
