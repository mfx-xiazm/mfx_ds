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
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
/* 网页加载进度视图 */
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation DSUserSignVC

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
    
    [self.web_content_view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]]];
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
    [self.navigationItem setTitle:@"电子签约"];
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_barTintColor = [UIColor whiteColor];
    self.hbd_tintColor = [UIColor blackColor];
    self.hbd_barShadowHidden = NO;
    self.hbd_titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName: [UIColor.blackColor colorWithAlphaComponent:1.0]};
}
#pragma mark -- 点击事件
- (IBAction)agreeClicked:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}
- (IBAction)signClicked:(UIButton *)sender {
    if (self.signSuccessCall) {
        self.signSuccessCall();
    }
    [self.navigationController popViewControllerAnimated:YES];
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
