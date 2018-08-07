//
//  CQBuyRedPacketsViewController.m
//  caiqr
//
//  Created by huangyuchen on 16/6/28.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQBuyRedPacketsViewController.h"
#import "CLAllJumpManager.h"
#import "CKWebView.h"
#import "NSString+CKCoding.h"
#import "CLAppContext.h"
#import "CQNRedParketViewController.h"
#import "CLConfigAPIMessage.h"
#import "CLAppNetAPIClient.h"
#import "CLAppNetAPIClient+CLNetAPIClient.h"
@interface CQBuyRedPacketsViewController ()<CKWebViewDelegate>
@property (nonatomic, strong) UIBarButtonItem *rightMoreBarButtonItem;
//跳转页面传参

@property (nonatomic, strong) CKWebView* ckWebView;
@property (nonatomic, strong) UIActivityIndicatorView * indicatorView;
@end

@implementation CQBuyRedPacketsViewController

+ (instancetype)pushBuyRedPacketsViewController
{
    CQBuyRedPacketsViewController *buyRedVC = [[CQBuyRedPacketsViewController alloc] init];
    buyRedVC.hidesBottomBarWhenPushed = YES;
    return buyRedVC;
}
#pragma mark - ViewController生命周期
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithCommonParam:(id)params
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setRightBarButtonItem:self.rightMoreBarButtonItem];
    self.navTitleText = @"";
    [self.view addSubview:self.ckWebView];
    [self.view addSubview:self.indicatorView];
    
    NSString *weburl = @"";
    if (API_Environment == 0 || API_Environment == 3) {
        weburl = @"https://test.caiqr.cn/jingcai/userCenter/redPurchase.html";
    }else if(API_Environment == 1){
        weburl = @"https://mz.caiqr.com/jingcai/userCenter/redPurchase.html";
    }else if (API_Environment == 2){
        weburl = @"https://mz.caiqr.com/jingcai/userCenter/redPurchase.html";
//        weburl = @"https://mzlottery.caiqr.cn/jingcai/userCenter/redPurchase.html";
    }
    [self.ckWebView ck_loadUrl:weburl];
}

#pragma mark - CKWebViewDelegate

- (void)ck_webViewDidStartLoad:(UIWebView *)webView {
    [self.indicatorView startAnimating];
}

- (void)ck_webViewDidFinishLoad:(UIWebView *)webView {
    [self.indicatorView stopAnimating];
}

- (void)ck_webViewTitle:(NSString *)title
{

    self.navTitleText = title;
}

/* 支付 */
- (void)ck_openLocationPay:(id)info {
    
    NSDictionary* dict = (NSDictionary*)info;
    if (dict && dict.count > 0) {
        NSString* flowid = dict[@"flowid"]?:@"";
//        NSString* payType = dict[@"payType"]?:@"";
//        NSString* orderID = dict[@"orderId"]?:@"";
//        NSString* lotteryType = dict[@"lotteryType"]?:@"";
        
        CQNRedParketViewController *viewc = [[CQNRedParketViewController alloc] init];
        viewc.flowIDString = flowid;
        
        [self.navigationController pushViewController:viewc animated:YES];
    }

}

#pragma mark - getter

- (CKWebView *)ckWebView {
    
    if (!_ckWebView) {
        _ckWebView = [[CKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_HEIGHT)];
        _ckWebView.ck_delegate = self;
        _ckWebView.token = [CLAppContext context].token;
        _ckWebView.client_type = [CLAppContext clientType];
        _ckWebView.channel = [CLAppContext channelId];
        _ckWebView.user_agent = [[CLAppNetAPIClient sharedClient].user_agent ck_nativeUrlEncode];
        _ckWebView.ck_urlEncode = ^NSString*(NSString* str) {
            return [str ck_nativeUrlEncode];
        };
    }
    return _ckWebView;
}


- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.center = self.view.center;
        _indicatorView.color = UIColorFromRGB(0x5cc3ff);
        _indicatorView.hidesWhenStopped = YES;
        [self.view addSubview:_indicatorView];
    }
    return _indicatorView;
    
}

- (void)queryAction
{
    [[CLAllJumpManager shareAllJumpManager] open:@"https://m.caiqr.com/help/introdution_of_red.html"];
}

- (UIBarButtonItem *)rightMoreBarButtonItem
{
    if (!_rightMoreBarButtonItem) {
        UIButton* rightFuncBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [rightFuncBtn setImage:[UIImage imageNamed:@"whiteQuestion.png"] forState:UIControlStateNormal];
        rightFuncBtn.frame = CGRectMake(0, 0, 17, 17);
        [rightFuncBtn addTarget:self action:@selector(queryAction) forControlEvents:UIControlEventTouchUpInside];
        _rightMoreBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightFuncBtn];
        
    }
    return _rightMoreBarButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
