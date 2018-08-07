//
//  CLHelpFeedbackViewController.m
//  iOSLottery
//
//  Created by 彩球 on 17/1/3.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLHelpFeedbackViewController.h"
#import "CQCustomerEntrancerService.h"
#import "CLLoadingAnimationView.h"

@interface CLHelpFeedbackViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView* fbWebView;
@property (nonatomic, strong) UIButton* button;

@end

@implementation CLHelpFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageStatisticsName = @"帮助与反馈";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.fbWebView];
    [self.view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(40.f);
    }];
    
    [self.fbWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.button.mas_top);
    }];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url_HelpFeedback]];
    [self.fbWebView loadRequest:request];
    
    [[CLLoadingAnimationView shareLoadingAnimationView] showLoadingAnimationInCurrentViewControllerWithType:CLLoadingAnimationTypeNormal];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
    
    /** 网页加载完成后，获取网页title 若当前页面无title 设置html.title */
    NSString* html_title = [self.fbWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([html_title isKindOfClass:[NSString class]] &&
        (html_title.length > 0)) {
        self.navTitleText = html_title;
    }
}

- (void) showMore {
    WS(_ws);
    [CQCustomerEntrancerService pushSessionViewControllerWithInitiator:_ws];
}

- (UIWebView *)fbWebView {
    
    if (!_fbWebView) {
        
        _fbWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _fbWebView.delegate = self;
    }
    return _fbWebView;
}

- (UIButton *)button {
    
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"联系客服" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setBackgroundColor:LINK_COLOR];
        _button.titleLabel.font = FONT_SCALE(14);
        [_button addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
