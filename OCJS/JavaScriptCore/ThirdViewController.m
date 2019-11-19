//
//  ThirdViewController.m
//  OCJS
//
//  Created by JackMa on 2019/11/18.
//  Copyright © 2019 fire. All rights reserved.
//

#import "ThirdViewController.h"
#import "SP_JSObject.h"

@interface ThirdViewController ()<UIWebViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index3.html" withExtension:nil];
    
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
}

#pragma mark - UIWebViewDelegate

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
    self.jsContext[@"showMessage"] = ^() {
        
        JSValue *thisValue = [JSContext currentThis];
        NSLog(@"thisValue = %@",thisValue);
        JSValue *cValue = [JSContext currentCallee];
        NSLog(@"cValue = %@",cValue);
        NSArray *args = [JSContext currentArguments];
        
        NSLog(@"来了");
        NSLog(@"args = %@", args);
        
        //OC调用JS 传参
        NSDictionary *dict = @{@"name":@"spirej", @"age":@18};
        [[JSContext currentContext][@"ocCalljs"] callWithArguments:@[dict]];
    };
    
    self.jsContext[@"showDict"] = ^(JSValue *value) {
        NSArray *args = [JSContext currentArguments];
        JSValue *dictValue = args[0];
        NSDictionary *dict = dictValue.toDictionary;
        NSLog(@"%@",dict);
    };
    
    // JS 操作对象
    SP_JSObject *spObject = [[SP_JSObject alloc] init];
    self.jsContext[@"spObject"] = spObject;
    
    // 打开相册
    __weak typeof(self) weakSelf = self;
    self.jsContext[@"getImage"] = ^() {
        
        weakSelf.imagePicker = [[UIImagePickerController alloc] init];
        weakSelf.imagePicker.delegate = weakSelf;
        weakSelf.imagePicker.allowsEditing = YES;
        weakSelf.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [weakSelf presentViewController:weakSelf.imagePicker animated:YES completion:nil];
    };
}

// 加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"****************华丽的分界线****************");
    NSLog(@"加载失败咯!!!!，为什么？因为：%@", error);
}

#pragma mark -- UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"info---%@",info);
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    NSData *imgData = UIImageJPEGRepresentation(resultImage, 0.01);
    NSString *encodedImageStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [self removeSpaceAndNewline:encodedImageStr];
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *imageString = [self removeSpaceAndNewline:encodedImageStr];
    
    // 拿到图片后，调用JS方法，把图片传给JS显示
    NSString *jsFunctStr = [NSString stringWithFormat:@"showImage('%@')",imageString];
    [self.jsContext evaluateScript:jsFunctStr];
}

- (NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}


@end
