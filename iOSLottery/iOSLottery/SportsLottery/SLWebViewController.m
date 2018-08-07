//
//  SLWebViewController.m
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/27.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLWebViewController.h"
#import "UIViewController+SLBaseViewController.h"
@interface SLWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView* activityWebView;
@property (nonatomic, strong) UIActivityIndicatorView* indicatorView;

@end

@implementation SLWebViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    
    [self.view addSubview:self.activityWebView];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //正式
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_activityUrlString]];
    [self.activityWebView loadRequest:request];
    // Do any additional setup after loading the view.
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
        (html_title.length > 0)) {
        [self setNavTitle:html_title];
    }
    //清除缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [self.indicatorView stopAnimating];
    
}

- (UIWebView *)activityWebView
{
    if (!_activityWebView) {
        
        _activityWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
        
        _activityWebView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
        
        _activityWebView.delegate = self;
    }
    return _activityWebView;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.center = self.view.center;
        _indicatorView.color = [UIColor redColor];
        _indicatorView.hidesWhenStopped = YES;
        [self.view addSubview:_indicatorView];
    }
    return _indicatorView;
    
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
