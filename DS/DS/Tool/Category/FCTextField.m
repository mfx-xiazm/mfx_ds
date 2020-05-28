//
//  FCTextField.m
//  FC
//
//  Created by huaxin-01 on 2020/5/13.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCTextField.h"

#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface FCTextField ()<UITextFieldDelegate>

@end
@implementation FCTextField

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.delegate = self;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.kLimitType == 1) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHA] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }else if (self.kLimitType == 2) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }else{
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
}
@end
