//
//  ALiTradeWantViewController.m
//  ALiSDKAPIDemo
//
//  Created by com.alibaba on 16/6/1.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALiTradeWebViewController.h"
//#import "ALiWebViewService.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "NSURL+Expand.h"

@interface ALiTradeWebViewController()

@end

@implementation ALiTradeWebViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.backgroundColor = HXGlobalBg;
        _webView.scrollView.scrollEnabled = YES;
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hbd_barStyle = UIBarStyleBlack;
    self.hbd_tintColor = [UIColor whiteColor];
    self.view.backgroundColor = HXGlobalBg;
    [self.navigationItem setTitle:@"授权"];
}
-(void)dealloc
{
    TLOG_INFO(@"dealloc  view");
    _webView = nil;
}

-(void)setOpenUrl:(NSString *)openUrl {
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:openUrl]]];
}

-(UIWebView *)getWebView{
    return  _webView;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString containsString:@"jpk_taobao://"]) {
        NSDictionary *info = [request.URL paramerWithURL];
        if (self.authSuccessCall) {
            self.authSuccessCall(info[@"taobao_goods_url"]);
            [self.navigationController popViewControllerAnimated:YES];
        }
        return NO;
    }
    return YES;
}
@end
