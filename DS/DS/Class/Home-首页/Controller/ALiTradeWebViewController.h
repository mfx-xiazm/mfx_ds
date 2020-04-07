//
//  ALiTradeWantViewController.h
//  ALiSDKAPIDemo
//
//  Created by com.alibaba on 16/6/1.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#ifndef ALiTradeWantViewController_h
#define ALiTradeWantViewController_h

#import <UIKit/UIKit.h>

typedef void(^authSuccessCall)(NSString * url);
@interface ALiTradeWebViewController : UIViewController<UIWebViewDelegate>
@property (nonatomic, copy) NSString *openUrl;
@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic, copy) authSuccessCall authSuccessCall;


-(UIWebView *)getWebView;

@end

#endif /* ALiTradeWantViewController_h */
