//
//  DSDynamicLayout.h
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSDynamic.h"

NS_ASSUME_NONNULL_BEGIN
#define kMomentTopPadding 15 // 顶部间隙
#define kMomentMarginPadding 10 // 内容间隙
#define kMomentPortraitWidthAndHeight 45 // 头像高度
#define kMomentLineSpacing 5 // 文本行间距
#define kMomentHandleButtonHeight 30 // 可操作的按钮高度

@interface DSDynamicLayout : NSObject
/** 数据源 */
@property(nonatomic,strong) DSDynamic *dynamic;
/** 文本内容布局 */
@property(nonatomic,strong) YYTextLayout *textLayout;
/** 图片内容布局 */
@property(nonatomic,assign) CGSize photoContainerSize;
/** 计算得出的布局高度 */
@property(nonatomic,assign) CGFloat height;

- (instancetype)initWithModel:(DSDynamic *)model;
/** 重置布局 */
- (void)resetLayout;
@end

NS_ASSUME_NONNULL_END
