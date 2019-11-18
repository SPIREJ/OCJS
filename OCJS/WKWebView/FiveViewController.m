//
//  FiveViewController.m
//  OCJS
//
//  Created by JackMa on 2019/11/18.
//  Copyright © 2019 fire. All rights reserved.
//

#import "FiveViewController.h"
#import <WebKit/WebKit.h>

@interface FiveViewController ()<WKUIDelegate, WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation FiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarBtns];
        
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // js 代码使样式显示正常
    config.userContentController = [self wkwebViewScalPreferences];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"index4.html" ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
    [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
    
    
    NSString *jsStr = @"var arr = [30, 'SPIREJ', 'GGMM']; ";
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
    }];
}

- (void)navBarBtns {
    UIButton *barBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [barBtn1 setTitle:@"跳转" forState:UIControlStateNormal];
    [barBtn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [barBtn1 addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem1 = [[UIBarButtonItem alloc] initWithCustomView:barBtn1];
    
    self.navigationItem.rightBarButtonItems = @[barItem1];
}

- (void)login {
   NSString *jsStr = @"showAlert('messageHandle:OC-->JS')";
   [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
       NSLog(@"%@----%@",result, error);
   }];
}

#pragma mark - 强引用 需要手动移除
//self - webView - configuration - userContentController - self
// 注册messgaeOC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"messgaeOC"];
}

// 移除messgaeOC
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"messgaeOC"];
}

#pragma mark - 大小适应
- (WKUserContentController *)wkwebViewScalPreferences{
   
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    return wkUController;
}


#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
   
    // 根据 message.name判断
    if (message.name) {
        // OC 层面的消息，业务处理等
    }
    NSLog(@"message == %@ --- %@",message.name, message.body);
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - dealloc

- (void)dealloc{
    NSLog(@"dealloc:走了");
}


@end
