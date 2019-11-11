//
//  SDWeiXinPhotoContainerView.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/23.
//  Copyright © 2015年 gsd. All rights reserved.
//

#import "SDWeiXinPhotoContainerView.h"
#import <ZLPhotoActionSheet.h>

#define kTodayNormalPadding 15
#define kTodayPortraitWidthAndHeight 45
#define kTodayPortraitNamePadding 10
#define margin 10
@interface SDWeiXinPhotoContainerView ()

@property (nonatomic, strong) NSArray *imageViewsArray;

@end

@implementation SDWeiXinPhotoContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSMutableArray *temp = [NSMutableArray new];
    
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        imageView.tag = i;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = HXGlobalBg;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [temp addObject:imageView];
    }
    self.imageViewsArray = [temp copy];
}

- (void)setPicPathStringsArray:(NSArray *)picPathStringsArray
{
    _picPathStringsArray = picPathStringsArray;
    
    for (long i = 0; i < _picPathStringsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        if (self.target) {
            imageView.userInteractionEnabled = YES;
        }else{
            imageView.userInteractionEnabled = NO;
        }
    }
    
    for (long i = _picPathStringsArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (_picPathStringsArray.count == 0) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, 0);
        return;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_picPathStringsArray];
    CGFloat itemH = 0;
    if (_picPathStringsArray.count == 1) {
           itemH = itemW;
    } else {
        itemH = itemW;
    }
    long perRowItemCount = [self perRowItemCountForPicPathArray:_picPathStringsArray];
    hx_weakify(self);
    [_picPathStringsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        hx_strongify(weakSelf);
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [strongSelf.imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;

        NSURL * url = [obj hasPrefix:@"http"]?[NSURL URLWithString:strongSelf.picPathStringsArray[idx]]:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HXRC_URL_HEADER,strongSelf.picPathStringsArray[idx]]];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeHolderImg"] options:SDWebImageRetryFailed];
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picPathStringsArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, w, h);
}


#pragma mark - private actions
- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    NSMutableArray * items = [NSMutableArray array];
    for (int i = 0; i < _picPathStringsArray.count; i++) {
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        temp[@"ZLPreviewPhotoObj"] = [_picPathStringsArray[i] hasPrefix:@"http"]?[NSURL URLWithString:_picPathStringsArray[i]]:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HXRC_URL_HEADER,_picPathStringsArray[i]]];
        temp[@"ZLPreviewPhotoTyp"] = @(ZLPreviewPhotoTypeURLImage);
        [items addObject:temp];
    }

    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    /**
     导航条颜色
     */
    actionSheet.configuration.navBarColor = UIColorFromRGB(0xF1C736);
    /**
     底部工具栏按钮 可交互 状态标题颜色
     */
    actionSheet.configuration.bottomBtnsNormalTitleColor = UIColorFromRGB(0xF1C736);
    actionSheet.sender = self.target;
    [actionSheet previewPhotos:items index:tap.view.tag hideToolBar:YES complete:^(NSArray * _Nonnull photos) {

    }];
}

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    if (array.count == 1)
    {
        return 120;
    } else {
        if (_customImgWidth != 0) {
            return _customImgWidth;
        }else{
            CGFloat w = (HX_SCREEN_WIDTH - kTodayNormalPadding - kTodayPortraitWidthAndHeight - kTodayPortraitNamePadding - kTodayNormalPadding - margin*2)/3.0;
            return w;
        }
    }
}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    if (array.count < 4) {
        return array.count;
    } else if (array.count <= 4) {
        return 2;
    } else {
        return 3;
    }
}

+ (CGSize)getContainerSizeWithPicPathStringsArray:(NSArray *)picPathStringsArray
{
    CGFloat itemW = picPathStringsArray.count == 1 ? 120 : (HX_SCREEN_WIDTH - kTodayNormalPadding - kTodayPortraitWidthAndHeight - kTodayPortraitNamePadding - kTodayNormalPadding - margin*2)/3.0;
    CGFloat itemH = 0;
    if (picPathStringsArray.count == 1) {
        itemH = itemW;
    } else {
        itemH = itemW;
    }
    long perRowItemCount;
    if (picPathStringsArray.count < 4) {
        perRowItemCount = picPathStringsArray.count;
    } else if (picPathStringsArray.count == 4) {
        perRowItemCount = 2;
    } else {
        perRowItemCount = 3;
    }
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(picPathStringsArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    
    return CGSizeMake(w, h);
}

@end
