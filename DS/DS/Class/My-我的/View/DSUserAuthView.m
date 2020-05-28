//
//  DSUserAuthView.m
//  DS
//
//  Created by huaxin-01 on 2020/5/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSUserAuthView.h"
#import <WebKit/WebKit.h>

@interface DSUserAuthView ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) WKWebView     *webView;
@property (weak, nonatomic) IBOutlet UIButton *authBtn;
@property (weak, nonatomic) IBOutlet UIView *webContentView;

@end
@implementation DSUserAuthView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.webContentView addSubview:self.webView];
    [self.authBtn.layer addSublayer:[UIColor setGradualChangingColor:self.authBtn fromColor:@"F9AD28" toColor:@"F95628"]];
    [self loadAuthLicenseRequest];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.webView.frame = self.webContentView.bounds;
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
        
        _webView = [[WKWebView alloc] initWithFrame:self.webContentView.bounds configuration:configuration];
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
-(void)loadAuthLicenseRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"set_type"] = @"user_auth_license";
    
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
- (IBAction)authClicked:(UIButton *)sender {
    if (self.userAuthCall) {
        self.userAuthCall(sender.tag);
    }
}

@end
