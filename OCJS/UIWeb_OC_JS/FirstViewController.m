//
//  FirstViewController.m
//  OCJS
//
//  Created by JackMa on 2019/11/18.
//  Copyright © 2019 fire. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    
//    NSURL *url = [NSURL fileURLWithPath:@"index.html"];
//    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.delegate = self;
    }
    return _webView;
}

#pragma mark - private 响应方法

- (void)getSum:(NSString *)str{
    NSLog(@"str = %@", str);
}

#pragma mark - UIWebViewDelegate

// 加载所有请求数据,以及控制是否加载
// JS 调用 OC --> shouldStartLoadWithRequest
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"request = %@", request);
    NSLog(@"URL = %@", request.URL);
    NSLog(@"pathComponents = %@", request.URL.pathComponents);
    NSLog(@"scheme = %@", request.URL.scheme);
    
    NSString *scheme = request.URL.scheme;
    if ([scheme isEqualToString:@"lgedu"]) {
        NSArray *array = request.URL.pathComponents;
        if (array.count > 1) {
            NSString *methodName = array[1];
            if ([methodName isEqualToString:@"getSum"]) {
                [self performSelector:NSSelectorFromString(methodName) withObject:array afterDelay:0];
            }
        }
    }
    
    return YES;
}

// 开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"****************华丽的分界线****************");
    NSLog(@"开始加载咯!!!!");
}

// 加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // OC 调用 JS --> stringByEvaluatingJavaScriptFromString
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = title;
    NSLog(@"****************华丽的分界线****************");
    NSLog(@"加载完成咯!!!!");
}

// 加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"****************华丽的分界线****************");
    NSLog(@"加载失败咯!!!!，为什么？因为：%@", error);
}

@end
