//
//  DSWebContentVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSWebContentVC.h"
#import <WebKit/WebKit.h>
#import "DSWebChatPayH5View.h"
#import "NSURL+Expand.h"

#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import <zhPopupController.h>
#import "DSOrderWebVC.h"

@interface DSWebContentVC ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) WKWebView     *webView;
/* 订单支付信息 */
@property(nonatomic,strong) NSDictionary *payInfo;
/* 订单列表页面地址 */
@property(nonatomic,strong) NSString *yqt_order_url;
/* 网页加载进度视图 */
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation DSWebContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
    if (self.navTitle) {
        [self.navigationItem setTitle:self.navTitle];
    }else{
        [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    }
    if (self.isNeedRequest) {
        [self startShimmer];
        [self loadWebDataRequest];
    }else{
        if (self.url && self.url.length) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
            //[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]]];
        }else{
            NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:0 15px;}</style></head><body>%@</body></html>",self.htmlContent];
            [self.webView loadHTMLString:h5 baseURL:nil];
        }
    }
    //注册支付状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doPayPush:) name:HXPayPushNotification object:nil];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
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
-(void)setUpNavBar
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"返回白色"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"返回白色"] forState:UIControlStateHighlighted];
    button.hxn_size = CGSizeMake(44, 44);
    // 让按钮内部的所有内容左对齐
    //        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [button addTarget:self action:@selector(backActionClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
-(void)backActionClicked
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        
        //[self.webView goToBackForwardListItem:self.webView.backForwardList.backList.firstObject];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)loadWebDataRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *action = nil;
    if (self.requestType == 1) {
        parameters[@"adv_id"] = self.adv_id;
        action = @"adv_detail_get";
    }else if (self.requestType == 2) {
        parameters[@"msg_id"] = self.msg_id;
        action = @"message_detail_get";
    }else if (self.requestType == 3) {
        parameters[@"set_type"] = @"member_rights_desc";
        action = @"license_config_get";
    }else if (self.requestType == 4) {
        parameters[@"set_type"] = @"member_self_buy";
        action = @"license_config_get";
    }else if (self.requestType == 5) {
        parameters[@"set_type"] = @"user_license";
        action = @"license_config_get";
    }else if (self.requestType == 6) {
        parameters[@"set_type"] = @"private_license";
        action = @"license_config_get";
    }else if (self.requestType == 7) {
        action = @"jd_url_get";
    }else if (self.requestType == 8) {
        parameters[@"set_type"] = @"user_auth_license";
        action = @"license_config_get";
    }else if (self.requestType == 9) {
        parameters[@"set_type"] = @"user_sign_license";
        action = @"license_config_get";
    }else if (self.requestType == 10) {
        parameters[@"set_type"] = @"finance_apply_desc";
        action = @"license_config_get";
    }
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:action parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (strongSelf.requestType == 1) {
                NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:15px 15px;}</style></head><body>%@</body></html>",responseObject[@"result"][@"adv_content"]];
                [strongSelf.webView loadHTMLString:h5 baseURL:nil];
            }else if (strongSelf.requestType == 2) {
                NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:15px 15px;}</style></head><body><div style=\"font-size:15px;font-weight:600;\">%@</div><div style=\"font-size:12px;color:#CCCCCC\">%@</div>%@</body></html>",responseObject[@"result"][@"msg_title"],responseObject[@"result"][@"create_time"],responseObject[@"result"][@"msg_content"]];
                [strongSelf.webView loadHTMLString:h5 baseURL:nil];
            }else if (strongSelf.requestType == 3) {
                NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:15px 15px;}</style></head><body>%@</body></html>",responseObject[@"result"][@"config_data"]];
                [strongSelf.webView loadHTMLString:h5 baseURL:nil];
            }else if (strongSelf.requestType == 4) {
                NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:15px 15px;}</style></head><body>%@</body></html>",responseObject[@"result"][@"config_data"]];
                [strongSelf.webView loadHTMLString:h5 baseURL:nil];
            }else if (strongSelf.requestType == 5) {
                NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:15px 15px;}</style></head><body>%@</body></html>",responseObject[@"result"][@"config_data"]];
                [strongSelf.webView loadHTMLString:h5 baseURL:nil];
            }else if (strongSelf.requestType == 6) {
                NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:15px 15px;}</style></head><body>%@</body></html>",responseObject[@"result"][@"config_data"]];
                [strongSelf.webView loadHTMLString:h5 baseURL:nil];
            }else if (strongSelf.requestType == 7) {
                [strongSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:responseObject[@"result"][@"jd_url"]]]];
            }else if (strongSelf.requestType == 8) {
                NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:15px 15px;}</style></head><body>%@</body></html>",responseObject[@"result"][@"config_data"]];
                [strongSelf.webView loadHTMLString:h5 baseURL:nil];
            }else if (strongSelf.requestType == 9) {
                NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:15px 15px;}</style></head><body>%@</body></html>",responseObject[@"result"][@"config_data"]];
                [strongSelf.webView loadHTMLString:h5 baseURL:nil];
            }else if (self.requestType == 10) {
                NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:15px 15px;}</style></head><body>%@</body></html>",responseObject[@"result"][@"config_data"]];
                [strongSelf.webView loadHTMLString:h5 baseURL:nil];
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *urlStr = navigationAction.request.URL.absoluteString;

    if (self.requestType == 7) {
        if ([urlStr rangeOfString:@"https://wx.tenpay.com"].location != NSNotFound) {
            NSString *redirectUrl = urlStr;
            // 微信支付链接不要拼接redirect_url，如果拼接了还是会返回到浏览器的
            if ([urlStr containsString:@"&redirect_url="]) {
                NSRange redirectRange = [urlStr rangeOfString:@"&redirect_url"];
                redirectUrl = [urlStr stringByReplacingOccurrencesOfString:[urlStr substringFromIndex:redirectRange.location] withString:@""];
            }
            //这里把webView设置成一个像素点，主要是不影响操作和界面，主要的作用是设置referer和调起微信
            DSWebChatPayH5View *h5View = [[DSWebChatPayH5View alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
            //url是没有拼接redirect_url微信h5支付链接
            [h5View loadingURL:redirectUrl withIsWebChatURL:NO];
            [self.view addSubview:h5View];
            decisionHandler(WKNavigationActionPolicyCancel);
        }else{
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }else{
        if ([urlStr hasPrefix:@"yqtjs://"]) {
            self.payInfo = [navigationAction.request.URL paramerWithURL];
            [self H5orderPayRequest];
            decisionHandler(WKNavigationActionPolicyCancel);
        }else{
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [self stopShimmer];
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [self stopShimmer];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self stopShimmer];
}
#pragma mark -- WKWebView UI代理
// 在JS端调用alert函数时(警告弹窗)，会触发此代理方法。
// 通过completionHandler()回调JS
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    if (@available(iOS 13.0, *)) {
        alertController.modalPresentationStyle = UIModalPresentationFullScreen;
        /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
        alertController.modalInPresentation = YES;
        
    }
    [self presentViewController:alertController animated:YES completion:nil];
}
// JS端调用confirm函数时(确认、取消式弹窗)，会触发此方法
// completionHandler(true)返回结果
// JavaScript调用confirm方法后回调的方法 confirm是js中的确定框，需要在block中把用户选择的情况传递进去
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    if (@available(iOS 13.0, *)) {
        alertController.modalPresentationStyle = UIModalPresentationFullScreen;
        /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
        alertController.modalInPresentation = YES;
        
    }
    [self presentViewController:alertController animated:YES completion:nil];
}
// JS调用prompt函数(输入框)时回调，completionHandler回调结果
// JavaScript调用prompt方法后回调的方法 prompt是js中的输入框 需要在block中把用户输入的信息传入
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    if (@available(iOS 13.0, *)) {
        alertController.modalPresentationStyle = UIModalPresentationFullScreen;
        /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
        alertController.modalInPresentation = YES;
        
    }
    [self presentViewController:alertController animated:YES completion:nil];
}
// 页面是弹出窗口 _blank 处理
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    /*
     当用户点击网页上的链接，需要打开新页面时，将先调用这个方法 -(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
     
     这个方法的参数 WKNavigationAction 中有两个属性：sourceFrame和targetFrame，分别代表这个action的出处和目标。类型是 WKFrameInfo 。WKFrameInfo有一个 mainFrame 的属性，正是这个属性标记着这个frame是在主frame里还是新开一个frame。
     
     如果 targetFrame 的 mainFrame 属性为NO，表明这个 WKNavigationAction 将会新开一个页面。此时开发者需要实现本方法，返回一个新的WKWebView，让 WKNavigationAction 在新的webView中打开
     */
    
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
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
    }else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            [self.navigationItem setTitle:self.webView.title];
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
#pragma mark -- 调起网页支付
// 拉取支付信息
-(void)H5orderPayRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"order_no"] = [NSString stringWithFormat:@"%@",self.payInfo[@"order_no"]];//商品订单id
    parameters[@"pay_type"] = [NSString stringWithFormat:@"%@",self.payInfo[@"pay_type"]];//支付方式：1支付宝；2微信
    parameters[@"order_title"] = [NSString stringWithFormat:@"%@",self.payInfo[@"order_title"]];//订单标题
    parameters[@"total_fee"] = [NSString stringWithFormat:@"%@",self.payInfo[@"total_fee"]];//支付金额
    parameters[@"notify_url"] = [NSString stringWithFormat:@"%@",self.payInfo[@"notify_url"]];//支付结果回调地址
    parameters[@"pay_order_sn"] = [NSString stringWithFormat:@"%@",self.payInfo[@"pay_order_sn"]];//商品订单号

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"pay_yqt_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.yqt_order_url = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"yqt_order_url"]];
            //pay_type 支付方式：1支付宝；2微信支付；
            NSString *pay_type = [NSString stringWithFormat:@"%@",strongSelf.payInfo[@"pay_type"]];
            if ([pay_type isEqualToString:@"1"]) {
                [strongSelf doAliPay:responseObject[@"result"]];
            }else {
                [strongSelf doWXPay:responseObject[@"result"]];
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
    
}
// 支付宝支付
-(void)doAliPay:(NSDictionary *)parameters
{
    NSString *appScheme = @"DSAliPay";
    NSString *orderString = parameters[@"alipay_param"];
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        if ([resultDic[@"resultStatus"] intValue] == 9000) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"支付成功"];
        }else if ([resultDic[@"resultStatus"] intValue] == 6001){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"用户中途取消"];
        }else if ([resultDic[@"resultStatus"] intValue] == 6002){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"网络连接出错"];
        }else if ([resultDic[@"resultStatus"] intValue] == 4000){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"订单支付失败"];
        }
    }];
}
// 微信支付
-(void)doWXPay:(NSDictionary *)dict
{
    if([WXApi isWXAppInstalled]) { // 判断 用户是否安装微信
        //需要创建这个支付对象
        PayReq *req   = [[PayReq alloc] init];
        //由用户微信号和AppID组成的唯一标识，用于校验微信用户
        req.openID = dict[@"appid"];
        
        // 商家id，在注册的时候给的
        req.partnerId = dict[@"partnerid"];
        
        // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
        req.prepayId  = dict[@"prepayid"];
        
        // 根据财付通文档填写的数据和签名
        //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
        req.package   = dict[@"package"];
        
        // 随机编码，为了防止重复的，在后台生成
        req.nonceStr  = dict[@"noncestr"];
        
        // 这个是时间戳，也是在后台生成的，为了验证支付的
        req.timeStamp = [dict[@"timestamp"] intValue];
        
        // 这个签名也是后台做的
        req.sign = dict[@"sign"];
        
        //发送请求到微信，等待微信返回onResp
        [WXApi sendReq:req];
    }else{
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"未安装微信"];
    }
}
#pragma mark -- 支付回调处理
-(void)doPayPush:(NSNotification *)note
{
    NSString *payStr = nil;
    if ([note.userInfo[@"result"] isEqualToString:@"1"]) {//支付成功
        //1成功 2取消支付 3支付失败
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"支付成功"];
        // OC调用JS，iOS端调JS changeColor()是JS方法名【如果有参数就changeColor('p1','p2')】，completionHandler是异步回调block
        payStr = [NSString stringWithFormat:@"yqt_pay_order_status_get('100','%@','%@','2')", self.payInfo[@"order_no"],self.payInfo[@"pay_type"]];
        /**
         yqt_pay_order_status_get(pay_status,order_no,pay_type,phone_type)
         pay_status——>支付接口（100：支付成功，101：支付失败，102：支付取消）
         order_no——>订单编号
         pay_type——>支付方式（1表示支付宝支付，2表示微信支付）
         phone_type——>手机端（1:android，2:ios）
         */
    }else if([note.userInfo[@"result"] isEqualToString:@"2"]){
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"取消支付"];
        payStr = [NSString stringWithFormat:@"yqt_pay_order_status_get('102','%@','%@','2')", self.payInfo[@"order_no"],self.payInfo[@"pay_type"]];
    }else{
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"支付失败"];
        payStr = [NSString stringWithFormat:@"yqt_pay_order_status_get('101','%@','%@','2')", self.payInfo[@"order_no"],self.payInfo[@"pay_type"]];
    }
    [_webView evaluateJavaScript:payStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        NSLog(@"结果回调网页端接收成功");
    }];
    
    NSString *pay_source = [NSString stringWithFormat:@"%@",self.payInfo[@"pay_source"]];
    if ([pay_source isEqualToString:@"1"]) {// 1下单页面 2订单列表或者订单详情
        DSOrderWebVC *cvc = [DSOrderWebVC new];
        cvc.url = self.yqt_order_url;
        [self.navigationController pushViewController:cvc animated:YES];
    }
}
#pragma mark -- 移除观察者
- (void)dealloc
{
    if (!self.navTitle) {
        [self.webView removeObserver:self forKeyPath:@"title"];
    }
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
