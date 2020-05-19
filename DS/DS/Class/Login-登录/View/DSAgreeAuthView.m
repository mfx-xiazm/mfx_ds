//
//  DSAgreeAuthView.m
//  DS
//
//  Created by huaxin-01 on 2020/5/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSAgreeAuthView.h"

@interface DSAgreeAuthView ()
@property (weak, nonatomic) IBOutlet UITextView *agreeTxt;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@end
@implementation DSAgreeAuthView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.agreeBtn.layer addSublayer:[UIColor setGradualChangingColor:self.agreeBtn fromColor:@"F9AD28" toColor:@"F95628"]];

    NSString *agreeStr = @"您注册为鲸品库用户的过程中，需要完成我们的注册流程并且以点击的形式在线签署以下协议， 请您务必仔细阅读、充分理解协议中的条款内容后点击同意（尤其是以粗体并下划线标识的条款，因为这些条款可能会明确您应履行的义务或对您的权利有所限制）：\n《用户协议》\n《隐私协议》\n【请您注意】如果您不同意上述协议或其中任何条款约定， 请您停止注册，您停止注册后无法享受我们的产品或服务。如您按照注册流程填写信息、阅读并同意上述协议并且完成全部注册后， 即表示您已充分阅读、同意并接受协议的全部内容；并表明您同意鲸品库可以依据上述隐私政策内容来处理您的个人信息。";
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5.f; //设置行间距
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:agreeStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size:14],NSForegroundColorAttributeName: UIColorFromRGB(0X666666),NSParagraphStyleAttributeName:paraStyle}];

    NSRange range = [agreeStr rangeOfString:@"请您务必仔细阅读、充分理解协议中的条款内容后点击同意（尤其是以粗体并下划线标识的条款，因为这些条款可能会明确您应履行的义务或对您的权利有所限制）："];
    [string addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSUnderlineStyleAttributeName:@1,NSUnderlineColorAttributeName:[UIColor blackColor]} range:range];
    
    NSRange range1 = [agreeStr rangeOfString:@"如果您不同意上述协议或其中任何条款约定， 请您停止注册，您停止注册后无法享受我们的产品或服务。如您按照注册流程填写信息、阅读并同意上述协议并且完成全部注册后， 即表示您已充分阅读、同意并接受协议的全部内容；并表明您同意鲸品库可以依据上述隐私政策内容来处理您的个人信息。"];
    [string addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSUnderlineStyleAttributeName:@1,NSUnderlineColorAttributeName:[UIColor blackColor]} range:range1];
    
    self.agreeTxt.attributedText = string;
}

- (IBAction)authClicked:(UIButton *)sender {
    if (self.authClickedCall) {
        self.authClickedCall(sender.tag);
    }
}

@end
