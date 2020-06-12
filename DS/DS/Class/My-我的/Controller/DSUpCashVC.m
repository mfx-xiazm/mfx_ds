//
//  DSUpCashVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSUpCashVC.h"
#import "DSCashNoteVC.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorLineView.h>
#import "DSBindCashMsgVC.h"
#import "DSUpCashView.h"
#import <zhPopupController.h>
#import "DSWebContentVC.h"
#import "DSUserAuthVC.h"

@interface DSUpCashVC ()<JXCategoryViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *cash_bg_img;
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
@property (weak, nonatomic) IBOutlet UILabel *cashAble;

@property (weak, nonatomic) IBOutlet UIView *card_cash_view;
@property (weak, nonatomic) IBOutlet UITextField *card_account_no;
@property (weak, nonatomic) IBOutlet UITextField *card_apply_amount;
@property (weak, nonatomic) IBOutlet UIButton *card_bind_btn;

@property (weak, nonatomic) IBOutlet UIView *ali_cash_view;
@property (weak, nonatomic) IBOutlet UITextField *ali_account_no;
@property (weak, nonatomic) IBOutlet UITextField *ali_apply_amount;
@property (weak, nonatomic) IBOutlet UIButton *ali_bind_btn;

@property (weak, nonatomic) IBOutlet UIButton *cashBtn;

/* 余额 */
@property(nonatomic,copy) NSString *balance;
/* 起提金额 */
@property(nonatomic,copy) NSString *base_amount;
/* 绑定银行卡 */
@property(nonatomic,strong) NSString *bind_bank;
/* 绑定支付宝 */
@property(nonatomic,strong) NSString *bind_zfb;

/** vc控制器 */
@property (nonatomic,strong) NSMutableArray *controllers;

@end

@implementation DSUpCashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hx_weakify(self);
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[DSUserAuthVC class]]) {
            hx_strongify(weakSelf);
            [strongSelf.controllers removeObjectAtIndex:idx];
            *stop = YES;
        }
    }];
    [self.navigationController setViewControllers:self.controllers];
    
    [self setUpNavBar];
    [self setUpCategoryView];
    [self.cashBtn.layer addSublayer:[UIColor setGradualChangingColor:self.cashBtn fromColor:@"F9AD28" toColor:@"F95628"]];

    self.ali_apply_amount.delegate = self;
    self.card_apply_amount.delegate = self;
    [self startShimmer];
    [self getInitRequest];

    [self.cashBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (strongSelf.categoryView.selectedIndex == 0) {
            if (![strongSelf.ali_account_no hasText]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请绑定支付宝账号"];
                return NO;
            }
            if ([strongSelf.ali_apply_amount.text floatValue] < [strongSelf.base_amount floatValue]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[NSString stringWithFormat:@"起提金额%@元",strongSelf.base_amount]];
                return NO;
            }
            if ([strongSelf.ali_apply_amount.text floatValue] > [strongSelf.balance floatValue]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"余额不足"];
                return NO;
            }
        }
        if (strongSelf.categoryView.selectedIndex == 1) {
            if (![strongSelf.card_account_no hasText]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请绑定银行卡账号"];
                return NO;
            }
            if ([strongSelf.card_apply_amount.text floatValue] < [strongSelf.base_amount floatValue]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[NSString stringWithFormat:@"起提金额%@元",strongSelf.base_amount]];
                return NO;
            }
            if ([strongSelf.card_apply_amount.text floatValue] > [strongSelf.balance floatValue]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"余额不足"];
                return NO;
            }
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf applyCashAlert:button];
    }];
}
- (NSMutableArray *)controllers {
    if (!_controllers) {
        _controllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    }
    return _controllers;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
#pragma mark -- 视图
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"提现"];
    
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_barTintColor = [UIColor whiteColor];
    self.hbd_tintColor = [UIColor blackColor];
    self.hbd_barShadowHidden = YES;
    self.hbd_titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName: [UIColor.blackColor colorWithAlphaComponent:1.0]};
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cashNoteClicked) title:@"提现记录" font:[UIFont systemFontOfSize:14] titleColor:[UIColor blackColor] highlightedColor:[UIColor blackColor] titleEdgeInsets:UIEdgeInsetsZero];
}
-(void)setUpCategoryView
{
    _categoryView.backgroundColor = [UIColor whiteColor];
    _categoryView.titleLabelZoomEnabled = NO;
    _categoryView.titles = @[@"支付宝提现", @"银行卡提现"];
    _categoryView.titleFont = [UIFont systemFontOfSize:16];
    _categoryView.titleColor = UIColorFromRGB(0x666666);
    _categoryView.titleSelectedFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    _categoryView.titleSelectedColor = UIColorFromRGB(0x333333);
    _categoryView.delegate = self;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = HXControlBg;
    lineView.indicatorWidth = 45.f;
    _categoryView.indicators = @[lineView];
}
#pragma mark -- 接口
-(void)getInitRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"finance_apply_init_get" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.balance = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"balance"]];
            strongSelf.base_amount = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"base_amount"]];
            strongSelf.bind_bank = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"bind_bank"]];
            strongSelf.bind_zfb = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"zfbAccount"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 可提现余额
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setPositiveFormat:@"#,###.##"];
                NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[strongSelf.balance floatValue]]];
                //若用于整数改为:[numberFormatter setPositiveFormat:@"###,##0"];
                [strongSelf.cashAble setFontAttributedText:[NSString stringWithFormat:@"￥%@",formattedNumberString] andChangeStr:@[@"￥"] andFont:@[[UIFont fontWithName:@"PingFangSC-Semibold" size: 16]]];
                // 绑定的账号信息
                if (strongSelf.bind_zfb.length) {
                    strongSelf.ali_account_no.text = strongSelf.bind_zfb;
                    strongSelf.ali_bind_btn.alpha = 0.5;// 如果已绑定就0.5，没绑定就1
                    [strongSelf.ali_bind_btn setTitle:@"修改绑定" forState:UIControlStateNormal];
                }
                strongSelf.ali_apply_amount.placeholder = [NSString stringWithFormat:@"最小提现金额%@元",strongSelf.base_amount];
                
                if (strongSelf.bind_bank.length) {
                    strongSelf.card_account_no.text = [strongSelf groupedString:strongSelf.bind_bank];
                    strongSelf.card_bind_btn.alpha = 0.5;// 如果已绑定就0.5，没绑定就1
                    [strongSelf.card_bind_btn setTitle:@"修改绑定" forState:UIControlStateNormal];
                }
                strongSelf.card_apply_amount.placeholder = [NSString stringWithFormat:@"最小提现金额%@元",strongSelf.base_amount];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)applyCashAlert:(UIButton *)btn
{
    DSUpCashView *cash = [DSUpCashView loadXibView];
    cash.hxn_width = HX_SCREEN_WIDTH - 30*2;
    cash.hxn_height = 340.f;
    [cash.name setColorAttributedText:[NSString stringWithFormat:@"姓名：%@",self.realNameTxt] andChangeStr:self.realNameTxt andColor:UIColorFromRGB(0x333333)];
    if (self.categoryView.selectedIndex == 0) {
        [cash.account_no setColorAttributedText:[NSString stringWithFormat:@"支付宝账号：%@",self.ali_account_no.text] andChangeStr:self.ali_account_no.text andColor:UIColorFromRGB(0x333333)];
        [cash.cash_amount setColorAttributedText:[NSString stringWithFormat:@"提现金额：%@",self.ali_apply_amount.text] andChangeStr:self.ali_apply_amount.text andColor:UIColorFromRGB(0x333333)];
    }else{
        [cash.account_no setColorAttributedText:[NSString stringWithFormat:@"银行卡账号：%@",self.card_account_no.text] andChangeStr:self.card_account_no.text andColor:UIColorFromRGB(0x333333)];
        [cash.cash_amount setColorAttributedText:[NSString stringWithFormat:@"提现金额：%@",self.card_apply_amount.text] andChangeStr:self.card_apply_amount.text andColor:UIColorFromRGB(0x333333)];
    }
    hx_weakify(self);
    cash.upCashCall = ^(NSInteger index) {
         hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        if (index) {
            [strongSelf applyCashRequest:btn];
        }else{
            [btn stopLoading:@"提现" image:nil textColor:nil backgroundColor:nil];
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.dismissOnMaskTouched = NO;
    [self.zh_popupController presentContentView:cash duration:0.25 springAnimated:NO];
}
-(void)applyCashRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.categoryView.selectedIndex == 0) {
        parameters[@"card_owner"] = self.realNameTxt;
        parameters[@"acct_type"] = @"2";//账号类型：1银行账号；2支付宝账号
        parameters[@"card_no"] = self.ali_account_no.text;
        parameters[@"apply_amount"] = self.ali_apply_amount.text;
    }else{
        parameters[@"card_owner"] = self.realNameTxt;
        parameters[@"acct_type"] = @"1";//账号类型：1银行账号；2支付宝账号
        parameters[@"card_no"] = [self removingSapceString:self.card_account_no.text];
        parameters[@"apply_amount"] = self.card_apply_amount.text;
    }
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"finance_apply_set" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"提现" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            strongSelf.ali_apply_amount.text = @"";
            strongSelf.card_apply_amount.text = @"";
            if (strongSelf.upCashActionCall) {
                strongSelf.upCashActionCall();
            }
            [strongSelf getInitRequest];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"提现" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 点击事件
-(void)cashNoteClicked
{
    DSCashNoteVC *nvc = [DSCashNoteVC new];
    [self.navigationController pushViewController:nvc animated:YES];
}
- (IBAction)cashNoticeClicked:(UIButton *)sender {
    DSWebContentVC *wvc = [DSWebContentVC new];
    wvc.navTitle = @"提现说明";
    wvc.requestType = 10;
    wvc.isNeedRequest = YES;
    [self.navigationController pushViewController:wvc animated:YES];
}
- (IBAction)bindCashMsgClicked:(UIButton *)sender {
    DSBindCashMsgVC *nvc = [DSBindCashMsgVC new];
    nvc.realNameTxt = self.realNameTxt;
    nvc.dataType = self.categoryView.selectedIndex;
    // 绑定的账号信息
    if (self.categoryView.selectedIndex == 0) {
        if ([self.ali_account_no hasText]) {
            nvc.accountNoTxt = self.ali_account_no.text;
        }
    }else{
        if ([self.card_account_no hasText]) {
            nvc.accountNoTxt = [self removingSapceString:self.card_account_no.text];
        }
    }
    
    hx_weakify(self);
    nvc.bindSuccessCall = ^(NSString * _Nonnull account_no) {
        hx_strongify(weakSelf);
        if (strongSelf.categoryView.selectedIndex == 0) {
            strongSelf.ali_account_no.text = account_no;
            strongSelf.ali_bind_btn.alpha = 0.5;// 如果已绑定就0.5，没绑定就1
            [strongSelf.ali_bind_btn setTitle:@"修改绑定" forState:UIControlStateNormal];
        }else{
            strongSelf.card_account_no.text = account_no;
            strongSelf.card_bind_btn.alpha = 0.5;// 如果已绑定就0.5，没绑定就1
            [strongSelf.card_bind_btn setTitle:@"修改绑定" forState:UIControlStateNormal];
        }
    };
    [self.navigationController pushViewController:nvc animated:YES];
}
#pragma mark - JXCategoryViewDelegate
// 滚动和点击选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
    if (index == 0) {
        self.ali_cash_view.hidden = NO;
        self.card_cash_view.hidden = YES;
    }else{
        self.ali_cash_view.hidden = YES;
        self.card_cash_view.hidden = NO;
    }
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

static NSInteger const kGroupSize = 4;

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
