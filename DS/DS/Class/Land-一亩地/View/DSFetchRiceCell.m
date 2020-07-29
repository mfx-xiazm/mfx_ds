//
//  DSFetchRiceCell.m
//  DS
//
//  Created by huaxin-01 on 2020/7/29.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSFetchRiceCell.h"

@interface DSFetchRiceCell ()
@property (weak, nonatomic) IBOutlet UITextField *oneField;
@property (weak, nonatomic) IBOutlet UITextField *twoField;
@property (weak, nonatomic) IBOutlet UITextField *trdField;

@end
@implementation DSFetchRiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)addClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        self.oneField.text = [NSString stringWithFormat:@"%zd",[self.oneField.text integerValue]+1];
    }else if (sender.tag == 2) {
        self.twoField.text = [NSString stringWithFormat:@"%zd",[self.twoField.text integerValue]+1];
    }else{
        self.trdField.text = [NSString stringWithFormat:@"%zd",[self.trdField.text integerValue]+1];
    }
}
- (IBAction)cutClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        if ([self.oneField.text isEqualToString:@"0"]) {
            return;
        }
        self.oneField.text = [NSString stringWithFormat:@"%zd",[self.oneField.text integerValue]-1];
    }else if (sender.tag == 2) {
        if ([self.twoField.text isEqualToString:@"0"]) {
            return;
        }
        self.twoField.text = [NSString stringWithFormat:@"%zd",[self.twoField.text integerValue]-1];
    }else{
        if ([self.trdField.text isEqualToString:@"0"]) {
            return;
        }
        self.trdField.text = [NSString stringWithFormat:@"%zd",[self.trdField.text integerValue]-1];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
