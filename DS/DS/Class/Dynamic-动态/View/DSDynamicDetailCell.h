//
//  DSDynamicDetailCell.h
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSDynamicDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *content_img;
@property (weak, nonatomic) IBOutlet UILabel *content_text;

@end

NS_ASSUME_NONNULL_END
