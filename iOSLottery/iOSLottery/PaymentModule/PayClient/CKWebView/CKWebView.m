//
//  CKWebView.m
//  caiqr
//
//  Created by 彩球 on 17/5/3.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKWebView.h"
#import "CKNativeObject.h"


@interface CKWebView () <UIWebViewDelegate>

@property (nonatomic, strong) NSString* requestUrlString;
@property (nonatomic, strong) CKNativeObject* jsCallNativeObjc;

@end



@implementation CKWebView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)ck_loadUrl:(NSString *)urlString {
    
    _requestUrlString = urlString;
    NSString* url = _requestUrlString;
    //如果h5有登陆状态且当前客户端是登陆状态 拼接token信息
    if ([self.token length])
    {
        NSString* token = [NSString stringWithFormat:@"%@%@",[CKWebView ck_retbitStringCount:5],self.token];
        
        NSString* urlParams = [NSString stringWithFormat:@"u=%@",token];
        if (self.ck_urlEncode) {
            urlParams = [NSString stringWithFormat:@"u=%@",self.ck_urlEncode(token)];
        }
    
        BOOL containMark = ([url rangeOfString:@"?"].location != NSNotFound);
        
        if (containMark) {
            //包含 ?
            if ([url rangeOfString:@"?"].location < (url.length - 1)) {
                // ?后有内容
                url = [NSString stringWithFormat:@"%@&%@",_requestUrlString,urlParams];
            }else if ([url rangeOfString:@"?"].location == (url.length - 1)){
                // ?后无内容
                url = [NSString stringWithFormat:@"%@%@",_requestUrlString,urlParams];
            }
        } else {
            //不包含 ?
            url = [NSString stringWithFormat:@"%@?%@",_requestUrlString,urlParams];
        }
        
    }
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    NSURL *cookieHost = [NSURL URLWithString:url];
    // 設定 token cookie
    [self addCookieWithCookieHost:cookieHost key:@"token" value:self.token];
    [self addCookieWithCookieHost:cookieHost key:@"client" value:self.client_type];
    [self addCookieWithCookieHost:cookieHost key:@"channel" value:self.channel];
    [self addCookieWithCookieHost:cookieHost key:@"user_agent" value:self.user_agent];
    
    [self loadRequest:request];
    
}

- (void)addCookieWithCookieHost:(NSURL *)cookieHost key:(NSString *)key value:(NSString *)value{
    
    if (value && value.length > 0) {
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                 [cookieHost host], NSHTTPCookieDomain,
                                 [cookieHost path], NSHTTPCookiePath,
                                 key,  NSHTTPCookieName,
                                 value, NSHTTPCookieValue,
                                 nil]];
        
        // 設定 cookie 到 storage 中
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    
    
    if ([self.ck_delegate respondsToSelector:@selector(ck_webViewDidStartLoad:)]) {
        [self.ck_delegate ck_webViewDidStartLoad:webView];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString* html_title = [self stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([html_title isKindOfClass:[NSString class]] &&
        (html_title.length > 0)) {
        if ([self.ck_delegate respondsToSelector:@selector(ck_webViewTitle:)]) {
            [self.ck_delegate ck_webViewTitle:html_title];
        }
    }
    //注册js
    JSContext *context =  [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak CKWebView *_weakSelf = self;
    self.jsCallNativeObjc.shareCallBack = ^(id info){
        [_weakSelf performSelectorOnMainThread:@selector(shareWindowImage:) withObject:info waitUntilDone:NO];
    };
    
    self.jsCallNativeObjc.JCLoginCallBack = ^(id info){
        [_weakSelf nativeLogin:info];
    };
    
    self.jsCallNativeObjc.JCShowBetCallBack = ^(id info){
        [_weakSelf showBet:info];
    };
    
    self.jsCallNativeObjc.JCShowLotteryBetCallBack = ^(id info){
        [_weakSelf lotteryBet:info];
    };
    
    self.jsCallNativeObjc.JCJumpNativeIntent = ^(id info){
        [_weakSelf jumpNativeIntent:info];
    };
    
    self.jsCallNativeObjc.JCSynLoginCallBack = ^(id info){
        [_weakSelf synH5LoginStatus:info];
    };
    
    self.jsCallNativeObjc.JCshareToSocial = ^(id info){
        [_weakSelf shareToSocial:info];
    };
    
    self.jsCallNativeObjc.JCNativePaymentCallBack = ^(id info) {
        [_weakSelf nativeGotoPayment:info];
    };
    
    context[@"jsCallNativeObjc"] = self.jsCallNativeObjc;
    NSLog(@"功能已注册。。。");
    
    //清除缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    
    
    if ([self.ck_delegate respondsToSelector:@selector(ck_webViewDidFinishLoad:)]) {
        [self.ck_delegate ck_webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

#pragma mark - JS 调用 OC 回调

- (void)nativeGotoPayment:(id)info {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.ck_delegate respondsToSelector:@selector(ck_openLocationPay:)]) {
            [self.ck_delegate ck_openLocationPay:info];
        }
    });
}

/** H5登陆，同步客户端登陆 */
- (void)synH5LoginStatus:(id)info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.ck_delegate respondsToSelector:@selector(ck_synH5LoginStatus:)]) {
            [self.ck_delegate ck_synH5LoginStatus:info];
        }
    });
    
}
/** 跳转客户端内容页面<统跳> */
- (void)jumpNativeIntent:(id)info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.ck_delegate respondsToSelector:@selector(ck_jumpNativeIntent:)]) {
            [self.ck_delegate ck_jumpNativeIntent:info];
        }
    });
}

//native share
- (void)shareWindowImage:(id)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.ck_delegate respondsToSelector:@selector(ck_shareWindowImage:)]) {
            [self.ck_delegate ck_shareWindowImage:msg];
        }
    });
}

/**
 3.9.6添加 将活动截屏分享至圈子
 
 @param info 参数初始状态为JSON字符串
 */
- (void)shareToSocial:(id)info{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.ck_delegate respondsToSelector:@selector(ck_shareToSocial:)]) {
            [self.ck_delegate ck_shareToSocial:info];
        }
    });

}

//native login
- (void)nativeLogin:(id)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.ck_delegate respondsToSelector:@selector(ck_nativeLogin:)]) {
            [self.ck_delegate ck_nativeLogin:msg];
        }
    });

}

//native Show Bet
- (void)showBet:(id)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.ck_delegate respondsToSelector:@selector(ck_showBet:)]) {
            [self.ck_delegate ck_showBet:msg];
        }
    });
}

//native show Lottery Bet
- (void)lotteryBet:(id)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.ck_delegate respondsToSelector:@selector(ck_lotteryBet:)]) {
            [self.ck_delegate ck_lotteryBet:msg];
        }
    });
}

#pragma mark - OC 调用 JS方法

- (void)loginFinishToJc
{
    NSString* token = [NSString stringWithFormat:@"%@%@",[CKWebView ck_retbitStringCount:5],self.token];
    NSString* jsString = [NSString stringWithFormat:@"nativeLoginFinish('%@')",token];
    [self stringByEvaluatingJavaScriptFromString:jsString];
//    self.needsReloadWebView = YES;
    //通知js 刷新页面
    [self callJSReload];
}

- (void)shareFinishToJc
{
    
    [self stringByEvaluatingJavaScriptFromString:@"nativeShareFinish('param')"];
    NSLog(@"--分享完成..回调js");
}

//客户端退出后清除缓存
- (void)dismisViewControllerToJC{
    NSString* jsString = [NSString stringWithFormat:@"nativeBack()"];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}

/**
 3.9.6 添加WebView刷新 通知JS页面需要刷新
 */
- (void)callJSReload{
    NSString* jsString = [NSString stringWithFormat:@"refresh()"];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}


#pragma mark - Others

- (CKNativeObject *)jsCallNativeObjc
{
    if (!_jsCallNativeObjc) {
        _jsCallNativeObjc = [[CKNativeObject alloc]init];
    }
    return _jsCallNativeObjc;
}



+ (NSString *)ck_retbitStringCount:(NSInteger)count
{
    char data[count];
    for (int x = 0; x < count; data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:count encoding:NSUTF8StringEncoding];
}

@end
