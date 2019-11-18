//
//  FourViewController.m
//  OCJS
//
//  Created by JackMa on 2019/11/18.
//  Copyright © 2019 fire. All rights reserved.
//

#import "FourViewController.h"
#import <WebKit/WebKit.h>
#import "FiveViewController.h"

@interface FourViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation FourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarBtns];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // js 代码使样式显示正常
    config.userContentController = [self wkwebViewScalPreferences];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"index4.html" ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
    [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
}

- (void)navBarBtns {
    UIButton *barBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [barBtn1 setTitle:@"跳转" forState:UIControlStateNormal];
    [barBtn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [barBtn1 addTarget:self action:@selector(pushNextVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem1 = [[UIBarButtonItem alloc] initWithCustomView:barBtn1];
    
    UIButton *barBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [barBtn2 setTitle:@"登录" forState:UIControlStateNormal];
    [barBtn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [barBtn2 addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem2 = [[UIBarButtonItem alloc] initWithCustomView:barBtn2];

    self.navigationItem.rightBarButtonItems = @[barItem1, barItem2];
}

- (void)login {
    NSString *jsStr = [NSString stringWithFormat:@"showAlert('%@')",@"登陆成功"];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
    }];
}

- (void)pushNextVC {
    FiveViewController *vc = [[FiveViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    NSString *scheme = url.scheme;
    if ([scheme isEqualToString:@"lgedu"]) {
        NSString *host = [url host];
        if ([host isEqualToString:@"jsCallOC"]) {
            NSMutableDictionary *temDict = [self decoderUrl:url];
            NSString *username = [temDict objectForKey:@"username"];
            NSString *password = [temDict objectForKey:@"password"];
            NSLog(@"%@---%@",username,password);
        }else {
            NSLog(@"不明地址");
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.navigationItem.title = webView.title;
    // 传一个全局变量
    NSString *jsStr = @"var arr = [18, 'spirej', 'love'];";
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@ --- %@", result, error);
    }];
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 解析URL地址
- (NSMutableDictionary *)decoderUrl:(NSURL *)URL{
    NSArray *params =[URL.query componentsSeparatedByString:@"&"];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSString *paramStr in params) {
        NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
        if (dicArray.count > 1) {
            NSString *decodeValue = [dicArray[1] stringByRemovingPercentEncoding];
            [tempDic setObject:decodeValue forKey:dicArray[0]];
        }
    }
    return tempDic;
}

#pragma mark - 大小适应
- (WKUserContentController *)wkwebViewScalPreferences{
   
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    return wkUController;
}


//#pragma mark - WKNavigationDelegate
////请求之前，决定是否要跳转:用户点击网页上的链接，需要打开新页面时，将先调用这个方法。
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;
////接收到相应数据后，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler;
////页面开始加载时调用
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation;
//// 主机地址被重定向时调用
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation;
//// 页面加载失败时调用
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;
//// 当内容开始返回时调用
//- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation;
//// 页面加载完毕时调用
//- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation;
////跳转失败时调用
//- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;
//// 如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler;
////9.0才能使用，web内容处理中断时会触发
//- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0);

@end
