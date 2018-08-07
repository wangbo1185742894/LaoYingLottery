//
//  CLWebViewActivityViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/4.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLWebViewActivityViewController.h"
#import "CKNativeObject.h"
#import "NSString+MJExtension.h"
#import "NSString+Coding.h"
#import "CLAppContext.h"
#import "CLCaiqrBusinessRequest.h"
#import "CLNativePushService.h"
#import "CLCheckTokenManager.h"
#import "CLUmengShareManager.h"
#import "CKNewPayViewController.h"
#import "CKNewQuickPayViewController.h"
#import "CQNRedParketViewController.h"
#import "CLTools.h"
#import "CLCheckProgessManager.h"
@interface CLWebViewActivityViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView* activityWebView;
@property (nonatomic, strong) UIActivityIndicatorView* indicatorView;
@property (nonatomic, strong) UIButton* shareButton;
@property (nonatomic, strong) UIButton* gobackButton;
@property (nonatomic, strong) UIButton* presentGobackButton;
@property (nonatomic, strong) UIButton* closeButton;

@property (nonatomic, strong) NSArray* pushLeftBarButtonItems;
@property (nonatomic, strong) NSArray* presentLeftBarButtonItems;

@property (nonatomic, strong) CKNativeObject* jsCallNativeObjc;


@property (nonatomic, readwrite) BOOL shareFinishToCallJs;


@property (nonatomic, strong) NSString* shareUrlString;             //固定分享的链接
@property (nonatomic, strong) NSString* shareDesc;                  //固定分享的内容
@property (nonatomic, strong) NSString* shareTitle;                 //固定分享的标题
@property (nonatomic, strong) NSString* shareIcon;
@property (nonatomic, readwrite) BOOL is_login;                     //是否需要登录


@property (nonatomic, strong) NSString* tempShareUrlString;         //临时记录分享的链接
@property (nonatomic, strong) NSString* tempShareDesc;              //临时记录分享内容

@property (nonatomic, strong) CLCheckTokenManager *checkTokenManager;//校验token



@end

@implementation CLWebViewActivityViewController

- (instancetype) init
{
    self = [super init];
    if (self) {
        //        self.pushLeftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.gobackButton],[[UIBarButtonItem alloc] initWithCustomView:self.closeButton]];
        //        self.presentLeftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.presentGobackButton],[[UIBarButtonItem alloc] initWithCustomView:self.closeButton]];
//        self.is_login = NO;
        self.shareFinishToCallJs = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageStatisticsName = @"web页面";
    [self.view addSubview:self.activityWebView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.presentGobackButton];
    
}



#pragma mark - private method

/** 设置右上角分享按钮展示 */
- (void)nativeShareButtonShowState:(BOOL)state
{
    if (state) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}
/** 左导航关闭事件 或 上一步事件 */
- (void)gobackClick:(id)sender
{
    if ([self.activityWebView canGoBack])
    {
        //可以上一步
        [self.activityWebView goBack];
        self.navigationItem.leftBarButtonItems = self.presentLeftBarButtonItems;
    } else {
        [self closeClicked:nil];
    }
}

- (void)closeClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - setting method

- (void)setActivityUrlString:(NSString *)activityUrlString
{
    _activityUrlString = activityUrlString;
//    _activityUrlString = @"http://192.168.30.44/jump/jump.html";
    NSString* url = _activityUrlString;
    //如果h5有登陆状态且当前客户端是登陆状态 拼接token信息
    if ([CLAppContext context].appLoginState)
    {
        NSString* token = [NSString stringWithFormat:@"%@%@",[NSString retbitStringCount:5],[[CLAppContext context] token]];
        NSString* urlParams = [NSString stringWithFormat:@"u=%@",[token urlEncode]];
        
        BOOL containMark = ([url rangeOfString:@"?"].location != NSNotFound);
        
        if (containMark) {
            //包含 ?
            if ([url rangeOfString:@"?"].location < (url.length - 1)) {
                // ?后有内容
                url = [NSString stringWithFormat:@"%@&%@",_activityUrlString,urlParams];
            }else if ([url rangeOfString:@"?"].location == (url.length - 1)){
                // ?后无内容
                url = [NSString stringWithFormat:@"%@%@",_activityUrlString,urlParams];
            }
        } else {
            //不包含 ?
            url = [NSString stringWithFormat:@"%@?%@",_activityUrlString,urlParams];
        }
        
    }
    //正式
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    NSURL *cookieHost = [NSURL URLWithString:url];
    // 設定 token cookie
    [self addCookieWithCookieHost:cookieHost key:@"token" value:[CLAppContext context].token];
    [self addCookieWithCookieHost:cookieHost key:@"client" value:[CLAppContext clientType]];
    [self addCookieWithCookieHost:cookieHost key:@"channel" value:[CLAppContext channelId]];

    [self.activityWebView loadRequest:request];
    
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


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.indicatorView startAnimating];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    /** 网页加载完成后，获取网页title 若当前页面无title 设置html.title */
    NSString* html_title = [self.activityWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([html_title isKindOfClass:[NSString class]] &&
        (html_title.length > 0) &&
        (self.shareTitle.length == 0)) {
        self.navTitleText = html_title;
    }
    
    //注册js
    JSContext *context =  [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    WS(_weakSelf)
    self.jsCallNativeObjc.shareCallBack = ^(id info){
        [_weakSelf shareWindowImage:info];
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
    self.jsCallNativeObjc.JCNativePaymentCallBack = ^(id info) {
        [_weakSelf nativeGotoPayment:info];
    };
    
    context[@"jsCallNativeObjc"] = self.jsCallNativeObjc;
//    NSLog(@"功能已注册。。。");
    
    //清除缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    
    [self.indicatorView stopAnimating];
    
}

#pragma mark - js call oc

/** H5登陆，同步客户端登陆 */
- (void)synH5LoginStatus:(id)info
{
    //H5回传token  执行验证token操作
    NSLog(@"H5登陆Token%@",info);
    [[CLAppContext context] setToken:info];
    self.checkTokenManager = [[CLCheckTokenManager alloc] init];
    WS(_weakSelf)
    self.checkTokenManager.destroyCheckTokenManager =^(){
        
        _weakSelf.checkTokenManager = nil;
    };
    [self.checkTokenManager checkUserToken];
}

/** 跳转客户端内容页面 */
- (void)jumpNativeIntent:(id)info
{
    if ([info isKindOfClass:[NSString class]] && [info length] > 0) {
        /** 主线程修改UI */
        MAIN(^{
            [CLNativePushService pushNativeUrl:info];
        });
    }
//    NSLog(@"-----%@",info);
}

//native share
- (void)shareWindowImage:(id)msg
{
    self.shareFinishToCallJs = YES;
    MAIN(^(){
        [self share:msg];
    });
    
}

//native login
- (void)nativeLogin:(id)msg
{
//        WS(_weakSelf)
//        [self launchLoginSuccessComplete:^(id message) {
//            [_weakSelf loginFinishToJc];
//        }];
}

//native Show Bet
- (void)showBet:(id)msg
{
    //    self.destroysViewControllerWhenPushed = YES;
    //    Class cla = NSClassFromString(@"CQRootBetViewController");
    //    UIViewController* viewController = [[cla alloc] init];
    //    [self.navigationController pushDestroyViewController:viewController animated:YES];
    
}

//native show Lottery Bet
- (void)lotteryBet:(id)msg
{
    //    self.destroysViewControllerWhenPushed = YES;
    //    Class cla = NSClassFromString(@"CQRootSportBetViewController");
    //    UIViewController* viewController = [[cla alloc] init];
    //    [self.navigationController pushDestroyViewController:viewController animated:YES];
}

#pragma mark - oc call js

- (void)loginFinishToJc
{
    NSString* token = [NSString stringWithFormat:@"%@%@",[[CLAppContext context] token],[NSString retbitStringCount:5]];
    NSString* jsString = [NSString stringWithFormat:@"nativeLoginFinish('%@')",token];
    [self.activityWebView stringByEvaluatingJavaScriptFromString:jsString];
}

- (void)shareFinishToJc
{
    
    [self.activityWebView stringByEvaluatingJavaScriptFromString:@"nativeShareFinish('param')"];
//    NSLog(@"--分享完成..回调js");
}


- (void)nativeGotoPayment:(id)info {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!(info && [info isKindOfClass:[NSString class]] && ((NSString *)info).length > 0)) {
            return ;
        }
        
        [[CLCheckProgessManager shareCheckProcessManager] checkIsLoginWithCallBack:^{
            
            NSData *jsonData = [info dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                 
                                                                options:NSJSONReadingMutableContainers
                                 
                                                                  error:nil];
            NSString *flowid = dic[@"flowid"];
            NSString *payType = dic[@"payType"];
            NSString *lotteryType = dic[@"lotteryType"];
            if ([payType longLongValue] == 0) {
                //表示红包支付
                CQNRedParketViewController *redVc = [[CQNRedParketViewController alloc] init];
                redVc.flowIDString = flowid;
                [self.navigationController pushViewController:redVc animated:YES];
            }else{
                //订单支付
                CKNewQuickPayViewController *quick = [[CKNewQuickPayViewController alloc] init];
                quick.preHandleToken = flowid;
                if ([lotteryType longLongValue] == 1) {
                    quick.orderType = CKOrderTypeNormal;
                }else if ([lotteryType longLongValue] == 2){
                    quick.orderType = CKOrderTypeFollow;
                }
                quick.backImage = snapshot(self.view.window);
                [self presentViewController:[[CLBaseNavigationViewController alloc] initWithRootViewController:quick] animated:NO completion:nil];
            }
        }];
    });
}
#pragma mark - Share Action

//js call share
- (void)share:(id)msg
{
    
        if (![CLAppContext suppleShare]) return;
    
        if ([msg isKindOfClass:[NSDictionary class]] && ([msg count] == 4))
        {
            NSDictionary* dic = (NSDictionary*)msg;
            [CLUmengShareManager umemgShareMessageWithTitile:dic[@"title"] contentText:dic[@"desc"] image:dic[@"imgUrl"] placeholderImage:@"" url:dic[@"link"] complete:^(BOOL isSuccess) {
                
            }];
        }
        else
        {
            [self nativeShare:nil];
        }
    
}

//分享
- (void)nativeShare:(id)sender {
    
}

#pragma mark - getting method

- (UIWebView *)activityWebView
{
    if (!_activityWebView) {
        _activityWebView = [[UIWebView alloc] initWithFrame:__Rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_HEIGHT)];
        _activityWebView.delegate = self;
    }
    return _activityWebView;
}

- (CKNativeObject *)jsCallNativeObjc
{
    if (!_jsCallNativeObjc) {
        _jsCallNativeObjc = [[CKNativeObject alloc]init];
    }
    return _jsCallNativeObjc;
}

- (UIButton *)shareButton
{
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.frame = __Rect(0, 0, 30, 30);
        _shareButton.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
        [_shareButton setImage:[UIImage imageNamed:@"shareImage"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(nativeShare:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (UIButton *)gobackButton
{
    if (!_gobackButton) {
        _gobackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _gobackButton.frame = __Rect(0, 0, 40, 44);
        [_gobackButton addTarget:self action:@selector(gobackClick:) forControlEvents:UIControlEventTouchUpInside];
        CALayer* arrowLayer = [CALayer layer];
        arrowLayer.frame = __Rect(-10, 12 , 20, 20);
        arrowLayer.contents = (id)[UIImage imageNamed:@"naviLeftArrow"].CGImage;
        [_gobackButton.layer addSublayer:arrowLayer];
        [_gobackButton setTitle:@"返回" forState:UIControlStateNormal];
        [_gobackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _gobackButton.titleLabel.font = FONT(14);
    }
    return _gobackButton;
}

- (UIButton *)presentGobackButton
{
    if (!_presentGobackButton) {
        _presentGobackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _presentGobackButton.frame = __Rect(0, 0, 25, 44);
        [_presentGobackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_presentGobackButton setImage:[UIImage imageNamed:@"allBack.png"] forState:UIControlStateNormal];
        _presentGobackButton.imageEdgeInsets = UIEdgeInsetsMake(0, - 15, 0, 0);
        _presentGobackButton.titleLabel.font = FONT(14);
        _presentGobackButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_presentGobackButton addTarget:self action:@selector(gobackClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _presentGobackButton;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = __Rect(0, 0, 40, 44);
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        _closeButton.titleEdgeInsets = UIEdgeInsetsMake(0, - 15, 0, 0);
        _closeButton.titleLabel.font = FONT(14);
        _closeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_closeButton addTarget:self action:@selector(closeClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _closeButton;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.center = self.view.center;
        _indicatorView.color = THEME_COLOR;
        _indicatorView.hidesWhenStopped = YES;
        [self.view addSubview:_indicatorView];
    }
    return _indicatorView;
    
}

- (NSArray *)pushLeftBarButtonItems
{
    return @[[[UIBarButtonItem alloc] initWithCustomView:self.gobackButton],[[UIBarButtonItem alloc] initWithCustomView:self.closeButton]];
}

- (NSArray *)presentLeftBarButtonItems
{
    return @[[[UIBarButtonItem alloc] initWithCustomView:self.presentGobackButton],[[UIBarButtonItem alloc] initWithCustomView:self.closeButton]];
}


- (void)ViewContorlBecomeActive:(NSNotificationCenter *)notification
{
    if (self.shareFinishToCallJs) {
        [self shareFinishToJc];
        self.shareFinishToCallJs = NO;
//        NSLog(@"程序唤起........分享成功...");
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
