//
//  DSPuslishDynamicData.h
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, DSPuslishDynamicUIStyle) {
    DSPuslishDynamicWord,      // 默认,文字
    DSPuslishDynamicPicture,   // 图片
};
@interface DSPuslishDynamicData : NSObject
/** 图片 */
@property (nonatomic,strong) UIImage *picture;
/** 内容 */
@property (nonatomic,copy) NSString *word;
/** 宽 */
@property (nonatomic,copy) NSString *width;
/** 高 */
@property (nonatomic,copy) NSString *height;
/** UI类型 */
@property (nonatomic,assign) DSPuslishDynamicUIStyle uiStyle;
@end

NS_ASSUME_NONNULL_END
