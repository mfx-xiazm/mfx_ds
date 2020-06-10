//
//  UIImage+HXNExtension.h
//  HX
//
//  Created by hxrc on 16/12/10.
//  Copyright © 2016年 xgt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HXNExtension)

/**
 图片不渲染分类
 
 @param name 图片名称
 @return 没渲染的图片
*/
+(UIImage *)originalImageWithImageName:(NSString *)name;
/**
 *  生成一张高斯模糊的图片
 *
 *  @param image 原图
 *  @param blur  模糊程度 (0~1)
 *
 *  @return 高斯模糊图片
 */
+ (UIImage *)blurImage:(UIImage *)image blur:(CGFloat)blur;

/**
 *  生成圆角的图片
 *
 *  @param originImage 原始图片
 *  @param borderColor 边框原色
 *  @param borderWidth 边框宽度
 *
 *  @return 圆形图片
 */
+ (UIImage *)circleImage:(UIImage *)originImage borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

#pragma mark - fixOrientation

// 修正图片旋转方向，兼容非ios系统，避免上传的本地图片在服务端或其他客户端旋转方向错误
// ios照片，即使倒着拍照，显示的时候也是正的，但上传服务器后显示的是倒立的
- (UIImage *)fixOrientation;

#pragma mark - 翻转

// 垂直翻转
- (UIImage *)flipVertical;

// 水平翻转
- (UIImage *)flipHorizontal;

#pragma mark - 图片剪裁

// 截取部分图像
- (UIImage *)getCroppedImage:(CGRect)rect;

// 截取圆形图片
- (UIImage *)getCircleImage;

#pragma mark - 图片缩放 及 压缩大小

// 等比例缩放
- (UIImage *)scaleWithRate:(CGFloat)rate;

// 把整张图缩放到reSize大小，不一定等比例会变形
- (UIImage *)scaleToSize:(CGSize)reSize;

// 等比例缩小, 最大边长为limt
- (UIImage *)scaleWithMaxLen:(CGFloat)limit;

#pragma mark - 图片压缩大小

- (NSData *)compressImageDataWithMaxBytes:(NSUInteger)bytes;

#pragma mark - 根据颜色、文字等生成image

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)imageSize;

+ (UIImage *)imageWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color;

+ (UIImage *)imageWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)imageWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color size:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode textAlignment:(NSTextAlignment)alignment;

#pragma mark - 在一个image上画上另一个image

- (UIImage *)drawImage:(UIImage *)image
               atPoint:(CGPoint)point
             onBgImage:(UIImage *)bgImage
                bgSize:(CGSize)bgSize;
@end
