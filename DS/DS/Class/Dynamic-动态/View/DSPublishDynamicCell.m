//
//  DSPublishDynamicCell.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSPublishDynamicCell.h"
#import "DSPuslishDynamicData.h"
#import "HXPlaceholderTextView.h"

@interface DSPublishDynamicCell ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *wordView;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UIView *wordContent;
/* 文字 */
@property(nonatomic,strong) HXPlaceholderTextView *word;
/* 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *picture;

@end
@implementation DSPublishDynamicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.word = [[HXPlaceholderTextView alloc] initWithFrame:self.wordContent.bounds];
    self.word.placeholder = @"请输入内容";
    self.word.delegate = self;
    [self.wordContent addSubview:self.word];
    
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hx_strongify(weakSelf);
        strongSelf.word.frame = strongSelf.wordContent.bounds;
    });
}
-(void)layoutSubviews
{
    [super layoutSubviews];
}
-(void)setPd:(DSPuslishDynamicData *)pd
{
    _pd = pd;
    if (_pd.uiStyle == DSPuslishDynamicWord) {
        self.wordView.hidden = NO;
        self.pictureView.hidden = YES;
        self.word.text = _pd.word;
    }else {
        self.wordView.hidden = YES;
        self.pictureView.hidden = NO;
        self.picture.image = _pd.picture;
    }
}

- (IBAction)delestClicked:(id)sender {
    if (self.deleteCallBack) {
        self.deleteCallBack();
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView hasText]) {
        _pd.word = textView.text;
    }else{
        _pd.word = @"";
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
