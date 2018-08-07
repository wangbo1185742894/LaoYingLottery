//
//  CKWebView.h
//  caiqr
//
//  Created by 彩球 on 17/5/3.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CKWebViewDelegate <NSObject>

@optional

- (void)ck_webViewDidStartLoad:(UIWebView *)webView;
- (void)ck_webViewDidFinishLoad:(UIWebView *)webView;


/* H5页面标题 */
- (void)ck_webViewTitle:(NSString*)title;

/* 内容分享 */
- (void)ck_shareWindowImage:(id)msg;

/* 截图分享至圈子  仅彩球 
 * @param info 参数初始状态为JSON字符串 
 */
- (void)ck_shareToSocial:(id)info;

/* 本地登录 */
- (void)ck_nativeLogin:(id)msg;

/* 虚盘投注 仅彩球 */
- (void)ck_showBet:(id)msg;

/* 真票投注  仅彩球 */
- (void)ck_lotteryBet:(id)msg;//真票投注

/* 同步H5登录状态 */
- (void)ck_synH5LoginStatus:(id)info;

/* 统跳支持 */
- (void)ck_jumpNativeIntent:(id)info;

/* 支付 */
- (void)ck_openLocationPay:(id)info;


@end

@interface CKWebView : UIWebView

@property (nonatomic, weak) id ck_delegate;
@property (nonatomic, strong) NSString* token;
@property (nonatomic, assign) BOOL isLoginState;
@property (nonatomic, strong) NSString* client_type;
@property (nonatomic, strong) NSString* channel;
@property (nonatomic, strong) NSString* user_agent;
@property (nonatomic, copy) NSString*(^ck_urlEncode)(NSString* str);





- (void)ck_loadUrl:(NSString*)urlString;

- (void)loginFinishToJc;

- (void)shareFinishToJc;

//客户端退出后清除缓存
- (void)dismisViewControllerToJC;
/**
 3.9.6 添加WebView刷新
 通知JS页面需要刷新
 */
- (void)callJSReload;






@end
