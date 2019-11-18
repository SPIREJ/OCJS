//
//  SixViewController.m
//  OCJS
//
//  Created by JackMa on 2019/11/18.
//  Copyright © 2019 fire. All rights reserved.
//

#import "SixViewController.h"
#import "WebViewJavascriptBridge.h"

@interface SixViewController ()<WKUIDelegate>
@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;
@end

@implementation SixViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarBtns];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // js 代码使样式显示正常
    config.userContentController = [self wkwebViewScalPreferences];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"index5.html" ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
    [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
    
    // 初始化
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    // 如果你要在VC中实现 UIWebView的代理方法 就实现下面的代码(否则省略)
    // [self.bridge setWebViewDelegate:self];
    
    //注册handle js调用oc
    [self.bridge registerHandler:@"jsCallsOC" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"currentThread == %@",[NSThread currentThread]);
        NSLog(@"data = %@", data);
        NSLog(@"responseCallback = %@", responseCallback);
    }];
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
    [self.bridge callHandler:@"OCCallJSFunction" data:@"oc调用js" responseCallback:^(id responseData) {
        NSLog(@"currentThread == %@",[NSThread currentThread]);
        NSLog(@"OC调用完JS后的回调：%@",responseData);
    }];
}

#pragma mark - 大小适应
- (WKUserContentController *)wkwebViewScalPreferences{
   
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    return wkUController;
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
