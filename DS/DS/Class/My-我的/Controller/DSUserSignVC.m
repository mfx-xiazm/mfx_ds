//
//  DSUserSignVC.m
//  DS
//
//  Created by huaxin-01 on 2020/5/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSUserSignVC.h"
#import <WebKit/WebKit.h>

@interface DSUserSignVC ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) WKWebView     *webView;
@property (weak, nonatomic) IBOutlet UIView *web_content_view;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
/* 网页加载进度视图 */
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation DSUserSignVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    
    self.signBtn.alpha = 0.4;
    [self.signBtn.layer addSublayer:[UIColor setGradualChangingColor:self.signBtn fromColor:@"F9AD28" toColor:@"F95628"]];

    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    hx_weakify(self);
    [self.signBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (!strongSelf.agreeBtn.isSelected) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请勾选服务协议"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf userSignSetRequest:button];
    }];
    
    [self.web_content_view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
    
    [self loadAuthLicenseRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.webView.frame = self.web_content_view.bounds;
}
- (UIProgressView *)progressView
{
    if (!_progressView){
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 1, HX_SCREEN_WIDTH, 2)];
        _progressView.tintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}
- (WKWebView *)webView{
    if (_webView == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        //        preference.minimumFontSize = 16;
        //        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        //        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preference;
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.scrollView.scrollEnabled = YES;
        // UI代理
        //_webView.UIDelegate = self;
        // 导航代理
        _webView.navigationDelegate = self;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _webView.allowsBackForwardNavigationGestures = YES;
    }
    
    return _webView;
}
#pragma mark -- 视图
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"用户电子签约服务协议"];
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_barTintColor = [UIColor whiteColor];
    self.hbd_tintColor = [UIColor blackColor];
    self.hbd_barShadowHidden = NO;
    self.hbd_titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName: [UIColor.blackColor colorWithAlphaComponent:1.0]};
}
#pragma mark -- 接口
-(void)loadAuthLicenseRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"set_type"] = @"user_sign_license";
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"license_config_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:15px 15px;}</style></head><body>%@</body></html>",responseObject[@"result"][@"config_data"]];
            [strongSelf.webView loadHTMLString:h5 baseURL:nil];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)userSignSetRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"realname"] = self.realName;
    parameters[@"centNo"] = self.centNo;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"xinbao_user_sign_set" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"确认签约" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (strongSelf.signSuccessCall) {
                strongSelf.signSuccessCall(YES,@"");
            }
        }else{
            if (strongSelf.signSuccessCall) {
                strongSelf.signSuccessCall(NO,[responseObject objectForKey:@"message"]);
            }
        }
        [strongSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [btn stopLoading:@"确认签约" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 点击事件
- (IBAction)agreeClicked:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        self.signBtn.alpha = 1.0;
    }else{
        self.signBtn.alpha = 0.4;
    }
}
#pragma mark -- KVO的监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //网页title
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]) {
        if (object == self.webView) {
            self.progressView.progress = _webView.estimatedProgress;
            if (_webView.estimatedProgress >= 1.0f) {
                hx_weakify(self);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    weakSelf.progressView.progress = 0;
                });
            }
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end
