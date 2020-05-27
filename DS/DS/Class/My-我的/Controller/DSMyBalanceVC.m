//
//  DSMyBalanceVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMyBalanceVC.h"
#import "DSMyBalanceHeader.h"
#import "DSMyBalanceCell.h"
#import "DSMyBalanceSectionHeader.h"
#import "DSUpCashVC.h"
#import "DSBalanceNoteVC.h"
#import "DSBalanceNote.h"
#import "DSUserAuthVC.h"
#import "DSUserAuthView.h"
#import <zhPopupController.h>

static NSString *const MyBalanceCell = @"MyBalanceCell";
@interface DSMyBalanceVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) DSMyBalanceHeader *header;
/* 最近记录 */
@property(nonatomic,strong) NSArray *notes;
@end

@implementation DSMyBalanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的余额"];
    self.hbd_barShadowHidden = YES;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(upCashClicked) title:@"提现" font:[UIFont systemFontOfSize:15] titleColor:[UIColor whiteColor] highlightedColor:[UIColor whiteColor] titleEdgeInsets:UIEdgeInsetsZero];
    [self setUpTableView];
    [self startShimmer];
    [self getMyBalanceRequest];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 250.f);
}
-(DSMyBalanceHeader *)header
{
    if (_header == nil) {
        _header = [DSMyBalanceHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 250.f);
        hx_weakify(self);
        _header.balanceBtnCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            if (index == 0) {
//                DSUpCashVC *cvc = [DSUpCashVC new];
//                cvc.upCashActionCall = ^{
//                    [strongSelf getMyBalanceRequest];
//                };
//                [strongSelf.navigationController pushViewController:cvc animated:YES];
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"待开放"];
            }else if (index == 1) {
                //奖励类型：晋级1，礼包2，商品3，分享4，队长收益5为晋级1和分享4之和
                DSBalanceNoteVC *nvc = [DSBalanceNoteVC new];
                nvc.reward_type = 3;
                [strongSelf.navigationController pushViewController:nvc animated:YES];
            }else if (index == 2) {
                //奖励类型：晋级1，礼包2，商品3，分享4，队长收益5为晋级1和分享4之和
                DSBalanceNoteVC *nvc = [DSBalanceNoteVC new];
                nvc.reward_type = 2;
                [strongSelf.navigationController pushViewController:nvc animated:YES];
            }else{
                //奖励类型：晋级1，礼包2，商品3，分享4，队长收益5为晋级1和分享4之和
                DSBalanceNoteVC *nvc = [DSBalanceNoteVC new];
                nvc.reward_type = 5;
                [strongSelf.navigationController pushViewController:nvc animated:YES];
            }
        };
    }
    return _header;
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.backgroundColor = HXGlobalBg;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;//预估高度
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 5.f, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSMyBalanceCell class]) bundle:nil] forCellReuseIdentifier:MyBalanceCell];
    
    self.tableView.tableHeaderView = self.header;
}
#pragma mark -- 点击事件
-(void)upCashClicked
{
    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"待开放"];
//    DSUserAuthView *auth = [DSUserAuthView loadXibView];
//    auth.hxn_width = HX_SCREEN_WIDTH - 30*2;
//    auth.hxn_height = 460.f;
//    hx_weakify(self);
//    auth.userAuthCall = ^(NSInteger index) {
//         hx_strongify(weakSelf);
//        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
//        if (index) {
//            DSUserAuthVC *avc = [DSUserAuthVC new];
//            [strongSelf.navigationController pushViewController:avc animated:YES];
//        }
//    };
//    self.zh_popupController = [[zhPopupController alloc] init];
//    self.zh_popupController.dismissOnMaskTouched = NO;
//    [self.zh_popupController presentContentView:auth duration:0.25 springAnimated:NO];
//    DSUpCashVC *cvc = [DSUpCashVC new];
//    hx_weakify(self);
//    cvc.upCashActionCall = ^{
//        hx_strongify(weakSelf);
//        [strongSelf getMyBalanceRequest];
//    };
//    [self.navigationController pushViewController:cvc animated:YES];
}
#pragma mark -- 接口请求
-(void)getMyBalanceRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"mybalance_get" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.notes = [NSArray yy_modelArrayWithClass:[DSBalanceNote class] json:responseObject[@"result"][@"log_list"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setPositiveFormat:@"#,###.##"];

                [strongSelf.header.balance setFontAttributedText:[NSString stringWithFormat:@"￥%@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:[responseObject[@"result"][@"balance"] floatValue]]]] andChangeStr:@[@"￥"] andFont:@[[UIFont systemFontOfSize:16]]];
                [strongSelf.header.goods_reward setFontAttributedText:[NSString stringWithFormat:@"￥%@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:[responseObject[@"result"][@"goods_reward"] floatValue]]]] andChangeStr:@[@"￥"] andFont:@[[UIFont systemFontOfSize:10]]];
                [strongSelf.header.gift_reward setFontAttributedText:[NSString stringWithFormat:@"￥%@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:[responseObject[@"result"][@"gift_reward"] floatValue]]]] andChangeStr:@[@"￥"] andFont:@[[UIFont systemFontOfSize:10]]];
                [strongSelf.header.upgrade_reward setFontAttributedText:[NSString stringWithFormat:@"￥%@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:[responseObject[@"result"][@"upgrade_reward"] floatValue]]]] andChangeStr:@[@"￥"] andFont:@[[UIFont systemFontOfSize:10]]];
                
                strongSelf.header.last_month_amount.text = NSStringFormat(@"上月已结算￥%@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:[responseObject[@"result"][@"js_amount"][@"js_last_month_amount"] floatValue]]]);
                strongSelf.header.cur_month_amount.text = NSStringFormat(@"本月已结算￥%@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:[responseObject[@"result"][@"js_amount"][@"js_cur_month_amount"] floatValue]]]);
                strongSelf.header.dai_month_amount.text = NSStringFormat(@"待结算￥%@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:[responseObject[@"result"][@"js_amount"][@"js_dai_amount"] floatValue]]]);
                
                [strongSelf.tableView reloadData];
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
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notes.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSMyBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:MyBalanceCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DSBalanceNote *note = self.notes[indexPath.row];
    cell.note = note;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DSMyBalanceSectionHeader *header = [DSMyBalanceSectionHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44.f);
    
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DSBalanceNote *note = self.notes[indexPath.row];
    if ([note.finance_log_type isEqualToString:@"2"] || [note.finance_log_type isEqualToString:@"3"] || [note.finance_log_type isEqualToString:@"4"] || [note.finance_log_type isEqualToString:@"5"]) {
        return UITableViewAutomaticDimension;
    }else{
        return 90.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}
@end
