//
//  CKSettingGuidanceController.m
//  CKPayClient
//
//  Created by huangyuchen on 2017/5/26.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CKSettingGuidanceController.h"
#import "Masonry.h"
#import "CKDefinition.h"

#define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)

@interface CKSettingGuidanceController ()

@property (nonatomic, strong) UILabel *title1Label;
@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, strong) UILabel *solveLabel;
@property (nonatomic, strong) UIButton *settingButton;

@end

@implementation CKSettingGuidanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    self.title = @"Safari限制访问";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.view addSubview:self.title1Label];
    [self.view addSubview:self.answerLabel];
    [self.view addSubview:self.solveLabel];
    [self.view addSubview:self.settingButton];
    
    //    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.left.equalTo(self.view).offset(__SCALE(10.f));
    //        make.top.equalTo(self.view).offset(__SCALE(164 + 20.f));
    //    }];
    //
    //    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.top.equalTo(self.titleLabel.mas_bottom).offset(__SCALE(20.f));
    //        make.left.equalTo(self.titleLabel);
    //    }];
    //
    //    [self.solveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.left.equalTo(self.answerLabel);
    //        make.right.equalTo(self.view).offset(__SCALE(- 40.f));
    //        make.top.equalTo(self.answerLabel.mas_bottom).offset(__SCALE(20.f));
    //
    //    }];
    //
    //    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.centerX.equalTo(self.view);
    //        make.top.equalTo(self.solveLabel.mas_bottom).offset(__SCALE(20.f));
    //        make.width.mas_equalTo(__SCALE(130.f));
    //        make.height.mas_equalTo(__SCALE(35.f));
    //    }];
    
    // Do any additional setup after loading the view.
}
#pragma mark ------------ event Response ------------
- (void)settingButtonOnClick:(UIButton *)btn{
    
    NSString * urlString = @"App-Prefs:root=SAFARI";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        if (iOS10) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
    }
    NSLog(@"去设置");
}

#pragma mark ------------ getter Mothed ------------
- (UILabel *)title1Label{
    
    if (!_title1Label) {
        _title1Label = [[UILabel alloc] initWithFrame:CGRectMake(__SCALE(10.f), __SCALE(20), SCREEN_WIDTH - __SCALE(20.f), __SCALE(30.f))];
        _title1Label.text = @"为什么我点击“立即支付”没有反应";
        _title1Label.textColor = UIColorFromRGB(0x333333);
        _title1Label.font = FONT_SCALE(17.f);
    }
    return _title1Label;
}
- (UILabel *)answerLabel{
    
    if (!_answerLabel) {
        _answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(__SCALE(10.f), CGRectGetMaxY(self.title1Label.frame) + __SCALE(20), SCREEN_WIDTH - __SCALE(20.f), __SCALE(25.f))];
        _answerLabel.text = @"答：您的Safari浏览器可能被限制访问了";
        _answerLabel.textColor = UIColorFromRGB(0x666666);
        _answerLabel.font = FONT_SCALE(15.f);
    }
    return _answerLabel;
}
- (UILabel *)solveLabel{
    
    if (!_solveLabel) {
        _solveLabel = [[UILabel alloc] initWithFrame:CGRectMake(__SCALE(10.f),CGRectGetMaxY(self.answerLabel.frame) + __SCALE(20), SCREEN_WIDTH - __SCALE(20.f), __SCALE(35.f))];
        _solveLabel.text = @"解决方法：进入“通用”-“访问限制”设置面板中找到Safari，开启Safari访问";
        _solveLabel.numberOfLines = 0;
        _solveLabel.textColor = UIColorFromRGB(0x666666);
        _solveLabel.font = FONT_SCALE(15.f);
    }
    return _solveLabel;
}

- (UIButton *)settingButton{
    
    if (!_settingButton) {
        _settingButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - __SCALE(130)) / 2,CGRectGetMaxY(self.solveLabel.frame) +  __SCALE(20), __SCALE(130.f), __SCALE(34.f))];
        [_settingButton setTitle:@"去设置" forState:UIControlStateNormal];
        [_settingButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        _settingButton.titleLabel.font = FONT_SCALE(15.f);
        [_settingButton addTarget:self action:@selector(settingButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _settingButton.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        _settingButton.layer.borderWidth = 0.5f;
        _settingButton.layer.cornerRadius = 2.f;
    }
    return _settingButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
