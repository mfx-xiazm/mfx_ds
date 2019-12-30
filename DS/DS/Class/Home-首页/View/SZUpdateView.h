//
//  SZUpdateView.h
//  STHZ
//
//  Created by hxrc on 2019/2/25.
//  Copyright © 2019 xzm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^updateClickedCall)(NSInteger index);
@interface SZUpdateView : UIView
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UITextView *updateText;
@property (weak, nonatomic) IBOutlet UILabel *versionTxt;
/** 点击 */
@property (nonatomic,copy) updateClickedCall updateClickedCall;

@end

NS_ASSUME_NONNULL_END
