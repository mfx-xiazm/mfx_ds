//
//  DSMyVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/11.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSMyVC.h"
#import "DSMyHeader.h"
#import "DSMyCell.h"
#import "DSMyOrderVC.h"
#import "DSChangeInfoVC.h"
#import "DSMySetVC.h"
#import "DSMyTeamVC.h"
#import "DSMyCardVC.h"
#import "DSMyCollectVC.h"
#import "DSMyAddressVC.h"
#import "DSMyBalanceVC.h"
#import "DSMyDynamicVC.h"
#import "DSMyAfterOrderVC.h"

static NSString *const ProfileCell = @"ProfileCell";
@interface DSMyVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) DSMyHeader *header;
/* titles */
@property(nonatomic,strong) NSArray *titles;

@end

@implementation DSMyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.header) {
        self.header.isReload = YES;
    }
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 320.f);
}
-(DSMyHeader *)header
{
    if (_header == nil) {
        _header = [DSMyHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 320.f);
        hx_weakify(self);
        _header.myHeaderBtnClickedCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            if (index == 6) {
                DSChangeInfoVC *ivc = [DSChangeInfoVC new];
                [strongSelf.navigationController pushViewController:ivc animated:YES];
            }else if (index == 5){
                DSMyAfterOrderVC *dvc = [DSMyAfterOrderVC new];
                [strongSelf.navigationController pushViewController:dvc animated:YES];
            }else{
                DSMyOrderVC *ovc = [DSMyOrderVC new];
                ovc.selectIndex = index;
                [strongSelf.navigationController pushViewController:ovc animated:YES];
            }
        };
    }
    return _header;
}
-(NSArray *)titles
{
    if (_titles == nil) {
        _titles = @[  @{@"title":@"我的团队",@"imagename":@"团队"},
                      @{@"title":@"我的余额",@"imagename":@"余额"},
                      @{@"title":@"我的卡包",@"imagename":@"卡包"},
                      @{@"title":@"我的动态",@"imagename":@"动态_1"},
                      @{@"title":@"我的收藏",@"imagename":@"收藏"},
                      @{@"title":@"我的地址",@"imagename":@"地址"},
                      @{@"title":@"客服消息",@"imagename":@"客服"}
        ];
        
    }
    return _titles;
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"我的"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(setClicked) image:HXGetImage(@"设 置")];
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
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSMyCell class]) bundle:nil] forCellReuseIdentifier:ProfileCell];
    
    self.tableView.tableHeaderView = self.header;
}
#pragma mark -- 点击
-(void)setClicked
{
    DSMySetVC *svc = [DSMySetVC new];
    [self.navigationController pushViewController:svc animated:YES];
}
#pragma mark -- 业务逻辑


#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSMyCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *temp = self.titles[indexPath.row];
    cell.name.text = temp[@"title"];
    cell.img.image = HXGetImage(temp[@"imagename"]);
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            DSMyTeamVC *avc = [DSMyTeamVC new];
            [self.navigationController pushViewController:avc animated:YES];
        }
            break;
        case 1:{
            DSMyBalanceVC *nvc = [DSMyBalanceVC new];
            [self.navigationController pushViewController:nvc animated:YES];
        }
            break;
        case 2:{
            DSMyCardVC *gvc = [DSMyCardVC new];
            [self.navigationController pushViewController:gvc animated:YES];
        }
            break;
        case 3:{
            DSMyDynamicVC *bvc = [DSMyDynamicVC new];
            [self.navigationController pushViewController:bvc animated:YES];
        }
            break;
        case 4:{
            DSMyCollectVC *cvc = [DSMyCollectVC new];
            [self.navigationController pushViewController:cvc animated:YES];
        }
            break;
        case 5:{
            DSMyAddressVC *avc = [DSMyAddressVC new];
            [self.navigationController pushViewController:avc animated:YES];
        }
            break;
            
        case 6:{
            //            GYMyAddressVC *avc = [GYMyAddressVC new];
            //            [self.navigationController pushViewController:avc animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
