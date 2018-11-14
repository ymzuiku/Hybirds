//
//  ViewController.m
//  HybirdIOS
//
//  Created by pillar on 2018/10/30.
//  Copyright © 2018 pillar. All rights reserved.
//

#define isPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define USERSCRIPT @"window.isNative=true; window.isHybird=true; window.isIOS=true; window.sendNative = function(str){ window.webkit.messageHandlers.native.postMessage(str)};window.hybird={};"

#define UIColorFromRGBA(RGBValue, alphaValue) [UIColor colorWithRed:((float)((RGBValue & 0xFF0000) >> 16))/255.0 green:((float)((RGBValue & 0x00FF00) >> 8))/255.0 blue:((float)(RGBValue & 0x0000FF))/255.0 alpha:alphaValue]

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
{
    WKWebView *_webView;
    NSString *_url;
    NSUserDefaults *_userDefaults;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lastUrl = [_userDefaults objectForKey:@"hybird-url"];
    if (lastUrl) {
        _url = lastUrl;
    } else {
        _url = @"http://127.0.0.1:3000";
    }
    [self.view addSubview:self.webView];
    [self webViewLoadUrl:_url isSaveLocal:true];
    
    UITapGestureRecognizer *tapGesturRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showChangeUrlAlert)];
    tapGesturRecognizer.numberOfTapsRequired = 6;
    tapGesturRecognizer.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:tapGesturRecognizer];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (WKWebView *)webView {
    if (!_webView) {
        WKUserScript *script = [[WKUserScript alloc] initWithSource:USERSCRIPT injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        [config.userContentController addUserScript:script];
        config.selectionGranularity = WKSelectionGranularityDynamic;
        config.allowsInlineMediaPlayback = YES;
        // 声明WKScriptMessageHandler 协议 用于JS回调
        [config.userContentController addScriptMessageHandler:self name:@"native"];
        WKPreferences *preferences = [WKPreferences new];
        //是否支持JavaScript
        preferences.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preferences;
        CGRect size = [UIScreen mainScreen].bounds;
        _webView = [[WKWebView alloc] initWithFrame:size configuration:config];
        [self.webView setFrame:CGRectMake(0, isPhoneX ? 30 : 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(isPhoneX ? 30 : 20))];
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_webView.scrollView setBounces:NO];
        [_webView.scrollView setAlwaysBounceVertical:YES];
        [_webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_webView setNavigationDelegate:self];
        [_webView setUIDelegate:self];
        [_webView setMultipleTouchEnabled:YES];
        [_webView setAutoresizesSubviews:YES];
        // 左滑返回
        [_webView setAllowsBackForwardNavigationGestures:true];
    }
    return _webView;
}

- (void)showAlert:(NSString *)title alertMsg:(NSString *)msg {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAc = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //点击取消要执行的代码
    }];
    [alertVC addAction:cancelAc];
    //    [alertVC addAction:comfirmAc];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)showChangeUrlAlert {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Change URL" message:@"Please input a URL" preferredStyle:UIAlertControllerStyleAlert];
    //定义第一个输入框；
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Please input new URL";
        textField.keyboardType = UIKeyboardTypeURL;
        textField.text = self->_url;
    }];
    //增加取消按钮；
    [alertVC addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    //增加确定按钮；
    [alertVC addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取第1个输入框；
        UITextField *nextUrl = alertVC.textFields.firstObject;
        if (nextUrl != nil && nextUrl.text != nil) {
            self->_url = nextUrl.text;
            [self webViewLoadUrl:self->_url isSaveLocal:true];
        }
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

/* 页面开始加载 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"load start...");
}
/* 开始返回内容 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"loading...");
}
/* 页面加载完成 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"load done!");
    [self sendMessage:@"console.log('Hello from hybird-ios')"];
}
/* 页面加载失败 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
/* 在发送请求之前，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}
/* 在收到响应后，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    //    NSLog(@"%@", navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}

// 发送消息至浏览器
-(void)sendMessage:(NSString *)str {
    [self.webView evaluateJavaScript:str completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@ scriptsStr response: %@",str, response);
        NSLog(@"%@ scriptsStr error: %@",str, error);
    }];
}

-(void)callbackMessage:(NSString *)key message:(NSString *)msg {
    [self sendMessage:[NSString stringWithFormat:@"if(%@){%@(%@)}", key, key, msg]];
}

// WKScriptMessageHandler
// 捕获 window.webkit.messageHandlers.native.postMessage 方法
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    NSDictionary *params = (NSDictionary*)message.body;
    // 是否显示提示用弹框
    NSString *testAlert = [params objectForKey:@"testAlert"];
    if (testAlert) {
        [self testAlert:testAlert params: [NSString stringWithFormat:@"%@", message.body]];
    }
    // 根据fn判断执行函数
    NSString *fn = [params objectForKey:@"fn"];
    if([fn isEqualToString:@"statusBarStyle"]){
        [self statusBarStyle:[params objectForKey:@"style"]];
    } else if([fn isEqualToString:@"statusBarHidden"]) {
        [self statusBarHidden: [[params objectForKey:@"isHidden"] boolValue]];
    } else if([fn isEqualToString:@"webViewMarge"]) {
        [self webViewMarge:[[params objectForKey:@"full"] boolValue] margeTop:[[params objectForKey:@"top"] floatValue] margeRight:[[params objectForKey:@"right"] floatValue] margeBottom:[[params objectForKey:@"bottom"] floatValue] margeLeft:[[params objectForKey:@"left"] floatValue] callback:[params objectForKey:@"callback"]];
    } else if ([fn isEqualToString:@"webViewLoadUrl"]) {
        NSString *url = [params objectForKey:@"url"];
        BOOL isSaveLocal = [[params objectForKey:@"isSaveLocal"] boolValue];
        [self webViewLoadUrl:url isSaveLocal:isSaveLocal];
    } else if ([fn isEqualToString:@"setBackground"]) {
        int hex = [[params objectForKey:@"hex"] intValue];
        CGFloat red = [[params objectForKey:@"red"] floatValue];
        CGFloat green = [[params objectForKey:@"green"] floatValue];
        CGFloat blue = [[params objectForKey:@"blue"] floatValue];
        CGFloat alpha = [[params objectForKey:@"alpha"] floatValue];
        [self setBackground:hex red:red green:green blue:blue alpha:alpha];
    } else if ([fn isEqualToString:@"goBack"]) {
        [self goBack];
    }
}


// ----- Apis
// 显示提示弹框
-(void)testAlert:(NSString *)title params:(NSString *)bodyString {
    [self showAlert:title alertMsg:bodyString];
}

// 修改webview相对于屏幕边框的位置
- (void) webViewMarge:(BOOL)full margeTop:(CGFloat )top margeRight:(CGFloat)right margeBottom:(CGFloat)bottom  margeLeft:(CGFloat)left callback:(NSString*)callback {
    if (full) {
        [self.webView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    } else {
        [self.webView setFrame:CGRectMake(left, top, [UIScreen mainScreen].bounds.size.width-left-right, [UIScreen mainScreen].bounds.size.height-top-bottom)];
    }
    if(callback) {
        [self callbackMessage:callback message:[NSString stringWithFormat:@"'x:%f, y:%f, width:%f, height:%f'", _webView.frame.origin.x, _webView.frame.origin.y, _webView.frame.size.width, _webView.frame.size.height]];
    }
}

// 修改重新读取URL
- (void) webViewLoadUrl:(NSString *)url isSaveLocal:(BOOL)isSaveLocal {
    if(isSaveLocal) {
        [self->_userDefaults setObject:self->_url forKey:@"hybird-url"];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

-(void) setBackground:(int)hex red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    if(hex) {
        self.view.backgroundColor = UIColorFromRGBA(hex, (float)alpha);
    } else {
     self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    }
}

-(void)statusBarStyle:(NSString *)msg {
    if ([msg isEqualToString:@"light"]) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else if ([msg isEqualToString:@"dark"]){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

-(void)statusBarHidden:(BOOL)isHidden {
    [UIApplication sharedApplication].statusBarHidden = isHidden;
}
-(void)goBack{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
}


@end


// 兼容低版本的顶部定位位置
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 11.0 && [[[UIDevice currentDevice] systemVersion] floatValue] > 7.0) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
