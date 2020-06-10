//
//  DSBindCashMsgVC.m
//  DS
//
//  Created by huaxin-01 on 2020/5/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSBindCashMsgVC.h"
#import "UITextField+GYExpand.h"

@interface DSBindCashMsgVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *account_type;
@property (weak, nonatomic) IBOutlet UITextField *realName;
@property (weak, nonatomic) IBOutlet UITextField *account_no;

@end

@implementation DSBindCashMsgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    self.realName.text = self.realNameTxt;
    self.account_no.delegate = self;
    self.account_type.text = self.dataType==1?@"代发账号":@"支付宝账号";
    self.account_no.placeholder = self.dataType==1?[NSString stringWithFormat:@"请输入%@的银行卡号",self.realNameTxt]:@"请输入支付宝账号";
    if (self.accountNoTxt && self.accountNoTxt.length) {
        self.account_no.text = self.dataType==1?[self groupedString:self.accountNoTxt]:self.accountNoTxt;
    }
    [self.sureBtn.layer addSublayer:[UIColor setGradualChangingColor:self.sureBtn fromColor:@"F9AD28" toColor:@"F95628"]];
}
#pragma mark -- 视图
-(void)setUpNavBar
{
    [self.navigationItem setTitle:self.dataType==1?@"绑定银行卡":@"绑定支付宝账号"];
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_barTintColor = HXGlobalBg;
    self.hbd_tintColor = [UIColor blackColor];
    self.hbd_barShadowHidden = YES;
    self.hbd_titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName: [UIColor.blackColor colorWithAlphaComponent:1.0]};
}
#pragma mark -- 接口
-(IBAction)bindAccountRequest:(UIButton *)btn
{
    if (self.dataType == 1) {// 银行卡
        if (![self.account_no hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:self.account_no.placeholder];
            return;
        }
    }else{// 支付宝
        if (![self.account_no hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:self.account_no.placeholder];
            return;
        }
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = [MSUserManager sharedInstance].curUserInfo.uid;
    parameters[@"acct_type"] = (self.dataType == 0)?@"2":@"1";// 1银行卡 2支付宝
    parameters[@"realname"] = self.realNameTxt;
    parameters[@"bankNo"] = [self removingSapceString:self.account_no.text];//银行账号或支付宝账号
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"finance_check_bankno_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (strongSelf.bindSuccessCall) {
                strongSelf.bindSuccessCall(strongSelf.account_no.text);
            }
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITextField
static NSInteger const kGroupSize = 4;
//银行卡每4位展示
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.dataType == 1) {// 银行卡
        // 4位分隔银行卡卡号
        NSString *text = textField.text;
        NSString *beingString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *cardNo = [self removingSapceString:beingString];
        //校验卡号只能是数字，且不能超过20位
        if ( (string.length != 0 && ![self isValidNumbers:cardNo]) || cardNo.length > 20) {
            return NO;
        }
        //获取【光标右侧的数字个数】
        NSInteger rightNumberCount = [self removingSapceString:[text substringFromIndex:textField.selectedRange.location + textField.selectedRange.length]].length;
        //输入长度大于4 需要对数字进行分组，每4个一组，用空格隔开
        if (beingString.length > kGroupSize) {
            textField.text = [self groupedString:beingString];
        } else {
            textField.text = beingString;
        }
        text = textField.text;
        /**
         * 计算光标位置(相对末尾)
         * 光标右侧空格数 = 所有的空格数 - 光标左侧的空格数
         * 光标位置 = 【光标右侧的数字个数】+ 光标右侧空格数
         */
        NSInteger rightOffset = [self rightOffsetWithCardNoLength:cardNo.length rightNumberCount:rightNumberCount];
        NSRange currentSelectedRange = NSMakeRange(text.length - rightOffset, 0);
        
        //如果光标左侧是一个空格，则光标回退一格
        if (currentSelectedRange.location > 0 && [[text substringWithRange:NSMakeRange(currentSelectedRange.location - 1, 1)] isEqualToString:@" "]) {
            currentSelectedRange.location -= 1;
        }
        [textField setSelectedRange:currentSelectedRange];
        return NO;
    }
    return YES;
}
#pragma mark - Helper
/**
 *  计算光标相对末尾的位置偏移
 *
 *  @param length           卡号的长度(不包括空格)
 *  @param rightNumberCount 光标右侧的数字个数
 *
 *  @return 光标相对末尾的位置偏移
 */
- (NSInteger)rightOffsetWithCardNoLength:(NSInteger)length rightNumberCount:(NSInteger)rightNumberCount {
    NSInteger totalGroupCount = [self groupCountWithLength:length];
    NSInteger leftGroupCount = [self groupCountWithLength:length - rightNumberCount];
    NSInteger totalWhiteSpace = totalGroupCount -1 > 0? totalGroupCount - 1 : 0;
    NSInteger leftWhiteSpace = leftGroupCount -1 > 0? leftGroupCount - 1 : 0;
    return rightNumberCount + (totalWhiteSpace - leftWhiteSpace);
}

/**
 *  校验给定字符串是否是纯数字
 *
 *  @param numberStr 字符串
 *
 *  @return 字符串是否是纯数字
 */
- (BOOL)isValidNumbers:(NSString *)numberStr {
    NSString* numberRegex = @"^[0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRegex];
    return [numberPre evaluateWithObject:numberStr];
}

/**
 *  去除字符串中包含的空格
 *
 *  @param str 字符串
 *
 *  @return 去除空格后的字符串
 */
- (NSString *)removingSapceString:(NSString *)str {
    return [str stringByReplacingOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];
}

/**
 *  根据长度计算分组的个数
 *
 *  @param length 长度
 *
 *  @return 分组的个数
 */
- (NSInteger)groupCountWithLength:(NSInteger)length {
    return (NSInteger)ceilf((CGFloat)length /kGroupSize);
}

/**
 *  给定字符串根据指定的个数进行分组，每一组用空格分隔
 *
 *  @param string 字符串
 *
 *  @return 分组后的字符串
 */
- (NSString *)groupedString:(NSString *)string {
    NSString *str = [self removingSapceString:string];
    NSInteger groupCount = [self groupCountWithLength:str.length];
    NSMutableArray *components = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < groupCount; i++) {
        if (i*kGroupSize + kGroupSize > str.length) {
            [components addObject:[str substringFromIndex:i*kGroupSize]];
        } else {
            [components addObject:[str substringWithRange:NSMakeRange(i*kGroupSize, kGroupSize)]];
        }
    }
    NSString *groupedString = [components componentsJoinedByString:@" "];
    return groupedString;
}
@end
