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
#import "DSGoodsDetail.h"

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
-(void)setGoodsDetail:(DSGoodsDetail *)goodsDetail
{
    _goodsDetail = goodsDetail;
    
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_goodsDetail.cover_img]];
    if (_goodsDetail.selectSku) {
        self.price.text = [NSString stringWithFormat:@"折扣价%.2f",[_goodsDetail.selectSku.discount_price floatValue]];
        self.market_price.text = [NSString stringWithFormat:@"原价：%.2f",[_goodsDetail.selectSku.price floatValue]];
        self.stock_num.text = [NSString stringWithFormat:@"库存：%@",_goodsDetail.selectSku.stock];
    }else{
        self.price.text = [NSString stringWithFormat:@"折扣价%.2f",[_goodsDetail.discount_price floatValue]];
        self.market_price.text = [NSString stringWithFormat:@"原价：￥%.2f",[_goodsDetail.price floatValue]];
        self.stock_num.text = [NSString stringWithFormat:@"库存：%@",_goodsDetail.stock];
    }

    [self.collectionView reloadData];
}
- (IBAction)goodHandleClicked:(UIButton *)sender {
    if (sender.tag) {
        BOOL isChooseed = YES;
        if (self.goodsDetail.list_specs && self.goodsDetail.list_specs.count) {
            for (DSGoodsSpecs *spec in self.goodsDetail.list_specs) {
                if (!spec.selectAttrs) {
                    isChooseed = NO;
                    break;
                }
            }
        }
        if (!isChooseed) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择商品规格"];
            return;
        }
        
        if (_goodsDetail.selectSku) {
            if (self.goodsDetail.buyNum > [_goodsDetail.selectSku.stock integerValue]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"库存不足"];
                return;
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"库存不足"];
            return;
        }
        
        if (self.goodsHandleCall) {
            self.goodsHandleCall(1);
        }
    }else{
        if (self.goodsHandleCall) {
            self.goodsHandleCall(0);
        }
    }
}
// 根据选中的规格判定库存等
-(void)checkGoodsSpecs
{
    BOOL isChooseed = YES;
    if (self.goodsDetail.list_specs && self.goodsDetail.list_specs.count) {
        for (DSGoodsSpecs *spec in self.goodsDetail.list_specs) {
            if (!spec.selectAttrs) {
                isChooseed = NO;
                break;
            }
        }
    }
    if (!isChooseed) {// 只有全部的规格都选，才往下走
        return;
    }
    
    NSMutableString *attr_id = [NSMutableString string];
    for (DSGoodsSpecs *specs in self.goodsDetail.list_specs) {
        if (attr_id.length) {
            [attr_id appendFormat:@",%@",specs.selectAttrs.attr_id];
        }else{
            [attr_id appendFormat:@"%@",specs.selectAttrs.attr_id];
        }
    }
    _goodsDetail.selectSku = nil;
    for (DSGoodsSku *sku in self.goodsDetail.goods_sku) {
        if ([sku.specs_attr_ids isEqualToString:attr_id]) {
            _goodsDetail.selectSku = sku;
            break;
        }
    }
    
    if (_goodsDetail.selectSku) {
        self.price.text = [NSString stringWithFormat:@"折扣价%.2f",[_goodsDetail.selectSku.discount_price floatValue]];
        self.market_price.text = [NSString stringWithFormat:@"原价：￥%.2f",[_goodsDetail.selectSku.price floatValue]];
        self.stock_num.text = [NSString stringWithFormat:@"库存：%@",_goodsDetail.selectSku.stock];
    }else{
        self.price.text = [NSString stringWithFormat:@"折扣价%.2f",[_goodsDetail.discount_price floatValue]];
        self.market_price.text = [NSString stringWithFormat:@"原价：￥%.2f",[_goodsDetail.price floatValue]];
        self.stock_num.text = [NSString stringWithFormat:@"库存：%@",@"0"];
    }
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.goodsDetail.list_specs && self.goodsDetail.list_specs.count) {
        return self.goodsDetail.list_specs.count;
    }else{
        return 1;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.goodsDetail.list_specs && self.goodsDetail.list_specs.count) {
        DSGoodsSpecs *spec = self.goodsDetail.list_specs[section];
        return spec.list_attrs.count;
    }else{
        return 0;
    }
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return LabelLayout;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DSChooseClassCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ChooseClassCell forIndexPath:indexPath];
    if (self.goodsDetail.list_specs && self.goodsDetail.list_specs.count) {
        DSGoodsSpecs *spec = self.goodsDetail.list_specs[indexPath.section];
        DSGoodsAttrs *attrs = spec.list_attrs[indexPath.item];
        cell.attrs = attrs;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.goodsDetail.list_specs && self.goodsDetail.list_specs.count) {
        DSGoodsSpecs *spec = self.goodsDetail.list_specs[indexPath.section];
        spec.selectAttrs.isSelected = NO;
        
        DSGoodsAttrs *attrs = spec.list_attrs[indexPath.item];
        attrs.isSelected = YES;
        
        spec.selectAttrs = attrs;
        
        [self checkGoodsSpecs];//检查规格
        
        [collectionView reloadData];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.goodsDetail.list_specs && self.goodsDetail.list_specs.count) {
        return CGSizeMake(HX_SCREEN_WIDTH,40.f);
    }else{
        return CGSizeZero;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (self.goodsDetail.list_specs && self.goodsDetail.list_specs.count) {
        return (section == self.goodsDetail.list_specs.count-1)?CGSizeMake(HX_SCREEN_WIDTH,40.f):CGSizeZero;
    }else{
        return CGSizeMake(HX_SCREEN_WIDTH,40.f);
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        DSChooseClassHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ChooseClassHeader forIndexPath:indexPath];
        if (self.goodsDetail.list_specs && self.goodsDetail.list_specs.count) {
            DSGoodsSpecs *spec = self.goodsDetail.list_specs[indexPath.section];
            header.spec_name.text = spec.specs_name;
            return header;
        }else{
            return nil;
        }
        return header;
    }else{
        DSChooseClassFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ChooseClassFooter forIndexPath:indexPath];
        
        footer.stock_num = self.goodsDetail.selectSku?[self.goodsDetail.selectSku.stock integerValue]:[self.goodsDetail.stock integerValue];
        footer.buy_num.text = [NSString stringWithFormat:@"%zd",self.goodsDetail.buyNum];
        hx_weakify(self);
        footer.buyNumCall = ^(NSInteger num) {
            hx_strongify(weakSelf);
            strongSelf.goodsDetail.buyNum = num;
        };
        if (self.goodsDetail.list_specs && self.goodsDetail.list_specs.count) {
            return (indexPath.section == self.goodsDetail.list_specs.count-1)?footer:nil;
        }else{
            return footer;
        }
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   if (self.goodsDetail.list_specs && self.goodsDetail.list_specs.count) {
        DSGoodsSpecs *spec = self.goodsDetail.list_specs[indexPath.section];
        DSGoodsAttrs *attrs = spec.list_attrs[indexPath.item];
        CGFloat jj_rate = HX_SCREEN_WIDTH/375.0;
        UIFont *font = [UIFont systemFontOfSize:14];
        return CGSizeMake([attrs.attr_name boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:(jj_rate ==1)?font:[UIFont fontWithDescriptor:font.fontDescriptor size:font.pointSize*jj_rate]} context:nil].size.width + 20, 30);
    }else{
        return CGSizeZero;
    }
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
