//
//  DSUpCashVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSUpCashVC.h"
#import "DSCashNoteVC.h"

@interface DSUpCashVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *card_owner;
@property (weak, nonatomic) IBOutlet UITextField *bank_name;
@property (weak, nonatomic) IBOutlet UITextField *card_no;
@property (weak, nonatomic) IBOutlet UITextField *apply_amount;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *ableLabel;


@end

@implementation DSUpCashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    self.apply_amount.delegate = self;
//    self.ableLabel.text = [NSString stringWithFormat:@"可提现金额：%@",self.cashable];
//    hx_weakify(self);
//    [self.sureBtn BindingBtnJudgeBlock:^BOOL{
//        hx_strongify(weakSelf);
//        if (![strongSelf.card_owner hasText]) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入持卡人姓名"];
//            return NO;
//        }
//        if (![strongSelf.bank_name hasText]) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入银行名称"];
//            return NO;
//        }
//        if (![strongSelf.card_no hasText]) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入银行卡号"];
//            return NO;
//        }
//        if (![strongSelf.apply_amount hasText]) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入提现金额"];
//            return NO;
//        }
//        if ([strongSelf.apply_amount.text floatValue] > [self.cashable floatValue]) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"可提现金额不足"];
//            return NO;
//        }
//        return YES;
//    } ActionBlock:^(UIButton * _Nullable button) {
//        hx_strongify(weakSelf);
//        [strongSelf applyCashRequest:button];
//    }];
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"提现"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cashNoteClicked) title:@"提现记录" font:[UIFont systemFontOfSize:14] titleColor:[UIColor whiteColor] highlightedColor:[UIColor whiteColor] titleEdgeInsets:UIEdgeInsetsZero];
}
-(void)cashNoteClicked
{
    DSCashNoteVC *nvc = [DSCashNoteVC new];
    [self.navigationController pushViewController:nvc animated:YES];
}
-(void)applyCashRequest:(UIButton *)btn
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"card_owner"] = self.card_owner.text;
//    parameters[@"bank_name"] = self.bank_name.text;
//    parameters[@"card_no"] = self.card_no.text;
//    parameters[@"apply_amount"] = self.apply_amount.text;
//
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:[[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"2"]?@"index/saveApplyData":@"program/saveApplyData" parameters:parameters success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//            [strongSelf.navigationController popViewControllerAnimated:YES];
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
}

//参数一：range，要被替换的字符串的range，如果是新输入的，就没有字符串被替换，range.length = 0
//参数二：替换的字符串，即键盘即将输入或者即将粘贴到textField的string
//返回值为BOOL类型，YES表示允许替换，NO表示不允许
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    //新输入的
    if (string.length == 0) {
        return YES;
    }

   //第一个参数，被替换字符串的range
   //第二个参数，即将键入或者粘贴的string
   //返回的是改变过后的新str，即textfield的新的文本内容
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];

    //正则表达式（只支持两位小数）
    NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
   //判断新的文本内容是否符合要求
    return [self isValid:checkStr withRegex:regex];

}

//检测改变过的文本是否匹配正则表达式，如果匹配表示可以键入，否则不能键入
- (BOOL) isValid:(NSString*)checkStr withRegex:(NSString*)regex
{
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}

@end
