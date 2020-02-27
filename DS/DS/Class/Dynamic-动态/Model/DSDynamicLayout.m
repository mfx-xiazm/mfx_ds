//
//  DSDynamicLayout.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSDynamicLayout.h"
#import "SDWeiXinPhotoContainerView.h"

@implementation DSDynamicLayout
- (instancetype)initWithModel:(DSDynamic *)model
{
    self = [super init];
    if (self) {
        _dynamic = model;
        [self resetLayout];
    }
    return self;
}
- (void)resetLayout
{
    _height = 0;
    
    _height += kMomentTopPadding;
    _height += kMomentPortraitWidthAndHeight;
    _height += kMomentMarginPadding;
    
    // 计算文本布局
    [self layoutText];
    _height += _textLayout.textBoundingSize.height;
    
    // 计算图片布局
    if (_dynamic.photos.count != 0) {
        [self layoutPicture];
        _height += kMomentMarginPadding;
        _height += _photoContainerSize.height;
    }
    
    _height += kMomentMarginPadding;
    _height += kMomentHandleButtonHeight;
    _height += kMomentMarginPadding;
}
// 计算文本详情
- (void)layoutText
{
    _textLayout = nil;
    
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithString:_dynamic.dsp];
    text.yy_font = [UIFont systemFontOfSize:14];
    text.yy_color = UIColorFromRGB(0x666666);
    text.yy_lineSpacing = kMomentLineSpacing;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(HX_SCREEN_WIDTH - kMomentMarginPadding*3-kMomentPortraitWidthAndHeight, CGFLOAT_MAX) insets:UIEdgeInsetsMake(5, 0, 5, 0)];
    // 阶段的类型，超出部分按尾部截段
    container.truncationType = YYTextTruncationTypeEnd;
    
    _textLayout = [YYTextLayout layoutWithContainer:container text:text];
}
// 计算图片
- (void)layoutPicture
{
    self.photoContainerSize = CGSizeZero;
    self.photoContainerSize = [SDWeiXinPhotoContainerView getContainerSizeWithPicPathStringsArray:_dynamic.photos];
}
@end
