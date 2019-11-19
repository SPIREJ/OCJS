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
    [self navBarBtns];
    [self.view addSubview:self.webView];
    
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

- (void)navBarBtns {
    UIButton *barBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [barBtn1 setTitle:@"OC调JS" forState:UIControlStateNormal];
    [barBtn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [barBtn1 addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem1 = [[UIBarButtonItem alloc] initWithCustomView:barBtn1];
    
    self.navigationItem.rightBarButtonItems = @[barItem1];
}

- (void)login {
    NSString *result = [self.webView stringByEvaluatingJavaScriptFromString:@"showAlert('HELLO')()"];
    NSLog(@"result == %@",result);
}

#pragma mark - private

- (void)getSum {
    //...
}

#pragma mark - UIWebViewDelegate

/**
这些都是JS响应的样式
UIWebViewNavigationTypeLinkClicked,        点击
UIWebViewNavigationTypeFormSubmitted,      提交
UIWebViewNavigationTypeBackForward,        返回
UIWebViewNavigationTypeReload,             刷新
UIWebViewNavigationTypeFormResubmitted,    重复提交
UIWebViewNavigationTypeOther               其他
*/
// 加载所有请求数据,以及控制是否加载
// JS 调用 OC --> shouldStartLoadWithRequest
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"scheme = %@", request.URL.scheme); // 标示 我们自己的协议
    NSLog(@"host = %@", request.URL.host); // 方法名
    NSLog(@"pathComponents = %@", request.URL.pathComponents); // 参数
    
    // JS 调用OC 的原理就是 拦截URL
    NSString *scheme = request.URL.scheme;
    if ([scheme isEqualToString:@"lgedu"]) {
        NSArray *array = request.URL.pathComponents;
        if (array.count > 1) {
            NSString *methodName = array[1];
            if ([methodName isEqualToString:@"getSum"]) {
                [self performSelector:NSSelectorFromString(methodName) withObject:array afterDelay:0];
                //...
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
