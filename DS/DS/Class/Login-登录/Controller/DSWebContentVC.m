//
//  DSWebContentVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSWebContentVC.h"
#import <WebKit/WebKit.h>

@interface DSWebContentVC ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) WKWebView     *webView;

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
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]]];
        }else{
            NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:0 15px;}</style></head><body>%@</body></html>",self.htmlContent];
            [self.webView loadHTMLString:h5 baseURL:nil];
        }
    }
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
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
        _webView.UIDelegate = self;
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
//    if ([self.webView canGoBack]) {
//        [self.webView goBack];
//    }else{
        [self.navigationController popViewControllerAnimated:YES];
//    }
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
    decisionHandler(WKNavigationActionPolicyAllow);
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
#pragma mark KVO的监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //网页title
    if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            [self.navigationItem setTitle:self.webView.title];
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
#pragma mark 移除观察者
- (void)dealloc
{
    if (!self.navTitle) {
        [self.webView removeObserver:self forKeyPath:@"title"];
    }
}

@end
