//
//  DSCartCell.h
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSCartData;
typedef void(^cartHandleCall)(NSInteger index);
@interface DSCartCell : UITableViewCell
/* 商品 */
@property(nonatomic,strong) DSCartData *cart;
/* 点击 */
@property(nonatomic,copy) cartHandleCall cartHandleCall;
@end

NS_ASSUME_NONNULL_END
