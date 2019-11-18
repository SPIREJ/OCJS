//
//  SecondViewController.m
//  OCJS
//
//  Created by JackMa on 2019/11/18.
//  Copyright © 2019 fire. All rights reserved.
//

#import "SecondViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "ThirdViewController.h"

@interface SecondViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) JSContext *jsContext;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    
    UIButton *barBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [barBtn setTitle:@"跳转" forState:UIControlStateNormal];
    [barBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [barBtn addTarget:self action:@selector(pushNextVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:barBtn];
    self.navigationItem.rightBarButtonItem = barItem;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index2.html" withExtension:nil];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.delegate = self;
    }
    return _webView;
}

#pragma mark - private
- (void)pushNextVC {
    ThirdViewController *vc = [[ThirdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIWebViewDelegate

// 加载所有请求数据,以及控制是否加载
// JS 调用 OC --> shouldStartLoadWithRequest
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"URL = %@", request.URL.absoluteString);
    
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
    
    // JSContext就为其提供着运行环境 H5上下文
    JSContext *jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 保存全局变量
    self.jsContext = jsContext;
    
    // 异常处理
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"context = %@", context);
        NSLog(@"exception = %@", exception);
    };
    
    // 提供全局变量
    [self.jsContext evaluateScript:@"var arr = ['apple', 'orange', 'banna'];"];
    
    // JS 调用 OC
    self.jsContext[@"ios_showMessage"] = ^() {
        NSLog(@"来了");
        NSArray *args = [JSContext currentArguments];
        NSLog(@"args = %@", args);
        
        //OC调用JS 传参
        NSDictionary *dict = @{@"name":@"spirej", @"age":@18};
        [[JSContext currentContext][@"ios_ocCalljs"] callWithArguments:@[dict, @"love"]];
    };
}

// 加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"****************华丽的分界线****************");
    NSLog(@"加载失败咯!!!!，为什么？因为：%@", error);
}

@end
