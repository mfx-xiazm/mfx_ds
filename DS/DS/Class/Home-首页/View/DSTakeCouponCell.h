//
//  DSTakeCouponCell.h
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^getCouponCall)(void);
@interface DSTakeCouponCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bg_img;
@property (weak, nonatomic) IBOutlet UILabel *discount;
@property (weak, nonatomic) IBOutlet UILabel *discoutName;
@property (weak, nonatomic) IBOutlet UILabel *validDay;
@property (weak, nonatomic) IBOutlet UIButton *takeBtn;

/* 点击 */
@property(nonatomic,copy) getCouponCall getCouponCall;
@end

NS_ASSUME_NONNULL_END
