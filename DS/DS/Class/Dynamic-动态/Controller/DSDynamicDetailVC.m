//
//  DSDynamicDetailVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSDynamicDetailVC.h"
#import "DSDynamicDetailHeader.h"
#import "DSDynamicDetailCell.h"
#import "DSDynamicDetailFooter.h"
#import "DSDynamicDetail.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "DSShareDynamicView.h"
#import <UMShare/UMShare.h>

static NSString *const DynamicDetailCell = @"DynamicDetailCell";
@interface DSDynamicDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
/** tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) DSDynamicDetailHeader *header;
/* 尾视图 */
@property(nonatomic,strong) DSDynamicDetailFooter *footer;
/* 动态详情 */
@property(nonatomic,strong) DSDynamicDetail *detail;
@end

@implementation DSDynamicDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"动态详情"];
    [self setUpTableView];
    [self startShimmer];
    [self getDynamicDetialRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 60.f);
    self.footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 50.f);
}
-(DSDynamicDetailHeader *)header
{
    if (_header == nil) {
        _header = [DSDynamicDetailHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 60.f);
    }
    return _header;
}
-(DSDynamicDetailFooter *)footer
{
    if (_footer == nil) {
        _footer = [DSDynamicDetailFooter loadXibView];
        _footer.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 50.f);
        hx_weakify(self);
        _footer.footerTypeCall = ^(NSInteger index, UIButton * _Nonnull btn) {
            hx_strongify(weakSelf);
            if (index == 1) {
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该条动态吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                    [strongSelf.zh_popupController dismiss];
                }];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"删除" handler:^(zhAlertButton * _Nonnull button) {
                    [strongSelf.zh_popupController dismiss];
                    [strongSelf setDynamicDeleteRequest:strongSelf.detail.treads.treads_id completedCall:^{
                        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"删除成功"];
                        if (weakSelf.dynamicDetailCall) {
                            weakSelf.dynamicDetailCall(2);
                        }
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }];
                }];
                cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
                strongSelf.zh_popupController = [[zhPopupController alloc] init];
                [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }else if (index == 2) {
                if ([MSUserManager sharedInstance].curUserInfo.ulevel == 1) {
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"普通用户无法点赞"];
                    return;
                }
                [strongSelf setDynamicPraiseRequest:strongSelf.detail.treads.treads_id isPraise:strongSelf.detail.treads.is_praise?@"0":@"1" completedCall:^{
                    weakSelf.detail.treads.is_praise = !weakSelf.detail.treads.is_praise;
                    btn.selected = weakSelf.detail.treads.is_praise;
                    if (weakSelf.dynamicDetailCall) {
                        weakSelf.dynamicDetailCall(1);
                    }
                }];
            }else{
                if ([MSUserManager sharedInstance].curUserInfo.ulevel == 1) {
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"普通用户无法分享"];
                    return;
                }
                DSShareDynamicView *shareView = [DSShareDynamicView loadXibView];
                shareView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 135.f);
                shareView.shareTypeActionCall = ^(NSInteger index) {
                    [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
                    if (index == 1) {
                        [strongSelf shareToProgramObject:UMSocialPlatformType_WechatTimeLine desc:strongSelf.detail.treads.treads_title thumImage:HXGetImage(@"Icon-share") webpageUrl:strongSelf.detail.treads.share_url];
                    }else{
                        [strongSelf shareToProgramObject:UMSocialPlatformType_WechatSession desc:strongSelf.detail.treads.treads_title thumImage:HXGetImage(@"Icon-share") webpageUrl:strongSelf.detail.treads.share_url];
                    }
                };
                strongSelf.zh_popupController = [[zhPopupController alloc] init];
                strongSelf.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
                [strongSelf.zh_popupController presentContentView:shareView duration:0.25 springAnimated:NO];
            }
        };
    }
    return _footer;
}
#pragma mark -- 视图相关
/**
 初始化tableView
 */
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
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSDynamicDetailCell class]) bundle:nil] forCellReuseIdentifier:DynamicDetailCell];
    
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
}
#pragma mark -- 分享处理
-(void)shareToProgramObject:(UMSocialPlatformType)platformType desc:(NSString *)desc thumImage:(id)thumImage webpageUrl:(NSString *)webpageUrl
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"鲸品库-好物分享" descr:desc thumImage:thumImage];
    shareObject.webpageUrl = webpageUrl;
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}
#pragma mark -- 接口请求
-(void)getDynamicDetialRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"treads_id"] = self.treads_id;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"treads_detail_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"status"] integerValue] == 1) {
            strongSelf.detail = [DSDynamicDetail yy_modelWithDictionary:responseObject[@"result"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleDynamicDetailData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)handleDynamicDetailData
{
    self.header.info = self.detail.treads;
    self.footer.info = self.detail.treads;
    
    [self.tableView reloadData];
}
-(void)setDynamicPraiseRequest:(NSString *)treads_id isPraise:(NSString *)is_praise completedCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"treads_id"] = treads_id;//动态id
    parameters[@"is_praise"] = is_praise;//是否点赞，1点赞，0取消点赞

    [HXNetworkTool POST:HXRC_M_URL action:@"treads_praise_set" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            if (completedCall) {
                completedCall();
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)setDynamicDeleteRequest:(NSString *)treads_id completedCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"treads_id"] = treads_id;//动态id

    [HXNetworkTool POST:HXRC_M_URL action:@"treads_delete_set" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
            if (completedCall) {
                completedCall();
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detail.list_content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSDynamicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:DynamicDetailCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DSDynamicContent *content = self.detail.list_content[indexPath.row];
    cell.content = content;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    DSDynamicContent *content = self.detail.list_content[indexPath.row];
    if ([content.content_type isEqualToString:@"2"]) {
        return 180.f;
    }else{
        return UITableViewAutomaticDimension;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
