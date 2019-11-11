//
//  SDWeiXinPhotoContainerView.h
//  SDAutoLayout  Demo
//
//  Created by gsd on 15/12/23.
//  Copyright © 2015年 gsd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^imageClickedCallBack)(NSInteger);
@interface SDWeiXinPhotoContainerView : UIView

@property (nonatomic, strong) NSArray *picPathStringsArray;
@property (nonatomic, strong) UIViewController * target;
@property (nonatomic, assign) int customImgWidth;

+ (CGSize)getContainerSizeWithPicPathStringsArray:(NSArray *)picPathStringsArray;

@end
