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
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 225.f);
}
-(DSMyBalanceHeader *)header
{
    if (_header == nil) {
        _header = [DSMyBalanceHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 225.f);
        hx_weakify(self);
        _header.balanceBtnCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            if (index == 0) {
                DSUpCashVC *cvc = [DSUpCashVC new];
                cvc.upCashActionCall = ^{
                    [strongSelf getMyBalanceRequest];
                };
                [strongSelf.navigationController pushViewController:cvc animated:YES];
            }else if (index == 1) {
                //奖励类型：晋级1，礼包2，商品3，分享4，队长收益5为晋级1和分享4之和
                DSBalanceNoteVC *nvc = [DSBalanceNoteVC new];
                nvc.reward_type = 3;
                [strongSelf.navigationController pushViewController:nvc animated:YES];
            }else if (index == 1) {
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
    self.tableView.estimatedRowHeight = 0;//预估高度
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
    DSUpCashVC *cvc = [DSUpCashVC new];
    hx_weakify(self);
    cvc.upCashActionCall = ^{
        hx_strongify(weakSelf);
        [strongSelf getMyBalanceRequest];
    };
    [self.navigationController pushViewController:cvc animated:YES];
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
                strongSelf.header.balance.text = NSStringFormat(@"%.2f",[responseObject[@"result"][@"balance"] floatValue]);
                strongSelf.header.goods_reward.text = NSStringFormat(@"%.2f",[responseObject[@"result"][@"goods_reward"] floatValue]);
                strongSelf.header.gift_reward.text = NSStringFormat(@"%.2f",[responseObject[@"result"][@"gift_reward"] floatValue]);
                strongSelf.header.upgrade_reward.text = NSStringFormat(@"%.2f",[responseObject[@"result"][@"upgrade_reward"] floatValue]+[responseObject[@"result"][@"share_reward"] floatValue]);

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
        return note.textHeight + 110.f;
    }else{
        return 90.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}
@end
