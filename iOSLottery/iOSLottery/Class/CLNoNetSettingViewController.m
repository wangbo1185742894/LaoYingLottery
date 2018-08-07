//
//  CLNoNetSettingViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/16.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLNoNetSettingViewController.h"
#import "Masonry.h"
@interface CLNoNetSettingViewController ()

@property (nonatomic, strong) UILabel *titlelable1;
@property (nonatomic, strong) UILabel *firstWay;
@property (nonatomic, strong) UILabel *secondWay;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *titleLabel2;
@property (nonatomic, strong) UILabel *thirdWay;

@property (nonatomic, assign) BOOL isGotoSetting;
@end

@implementation CLNoNetSettingViewController

- (void)ViewContorlBecomeActive:(NSNotification *)notification{
    
    [super ViewContorlBecomeActive:notification];
    if (self.isGotoSetting) {
        [self.navigationController popViewControllerAnimated:YES];
        self.isGotoSetting = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleText = @"无网络连接";
    [self.view addSubview:self.titlelable1];
    [self.view addSubview:self.firstWay];
    [self.view addSubview:self.secondWay];
    [self.view addSubview:self.leftButton];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.titleLabel2];
    [self.view addSubview:self.thirdWay];
    [self addConstraint];
    // Do any additional setup after loading the view.
}
- (void)addConstraint{
    [self.titlelable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10.f + 0);
        make.left.equalTo(self.view).offset(10.f);
        make.right.mas_equalTo(self.view).offset(-10.f);
        make.height.mas_equalTo(30.f);
    }];
    
    [self.firstWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titlelable1);
        make.top.mas_equalTo(self.titlelable1.mas_bottom).offset(10.f);
    }];
    [self.secondWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titlelable1);
        make.top.mas_equalTo(self.firstWay.mas_bottom).offset(10.f);
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.secondWay.mas_bottom).offset(30.f);
        make.width.mas_equalTo(__SCALE(95));
        make.height.mas_equalTo(__SCALE(30));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.leftButton.mas_bottom).offset(15.f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.lineView).offset(10.f);
        make.right.mas_equalTo(self.view).offset(-10.f);
        make.height.mas_equalTo(30.f);
    }];
    
    [self.thirdWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel2);
        make.top.mas_equalTo(self.titleLabel2.mas_bottom).offset(10.f);
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UserInterface

- (void)leftBtnSelected:(id)sender{

    self.isGotoSetting = YES;
    [self openWithUrl:@"prefs:root=Setting"];
}

- (void)openWithUrl:(NSString *)url{
    if (IOS_VERSION>=10.0) {
        
        if( [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]] ) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{}completionHandler:^(BOOL success) {
            }];
        }
    }else{
        if( [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:url]] ) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
        }
    }
}
#pragma mark - Getmethod

- (UILabel *)titlelable1{
    if (!_titlelable1) {
        _titlelable1 = [UILabel new];
        _titlelable1.textColor = [UIColor darkGrayColor];
        _titlelable1.text = @"可以参照以下方法检查网络设置:";
        _titlelable1.font = [UIFont systemFontOfSize:__SCALE(13)];
    }
    return _titlelable1;
}
- (UILabel *)titleLabel2{
    if (!_titleLabel2) {
        _titleLabel2 = [UILabel new];
        _titleLabel2.textColor = [UIColor darkGrayColor];
        _titleLabel2.text = @"如果您已接入wifi网络:";
        _titleLabel2.font = [UIFont systemFontOfSize:__SCALE(13)];
    }
    return _titleLabel2;
}

- (UILabel *)firstWay{
    if (!_firstWay) {
        _firstWay = [UILabel new];
        _firstWay.textColor = [UIColor lightGrayColor];
        _firstWay.text = @"-在设备的\"设置\"-\"网络\"设置面板中选择一个可用的wifi网络接入。";
        _firstWay.font = [UIFont systemFontOfSize:__SCALE(12)];
        _firstWay.preferredMaxLayoutWidth = self.view.frame.size.width - 20.f;
        [_firstWay setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _firstWay.numberOfLines = 0;
    }
    return _firstWay;
}
- (UILabel *)secondWay{
    if (!_secondWay) {
        _secondWay = [UILabel new];
        _secondWay.textColor = [UIColor lightGrayColor];
        _secondWay.text = @"-在设备的\"设置\"-\"通用\"-\"网络\"设置面板中启用蜂窝数据（启用后运营商可能会收取数据通信费用）";
        _secondWay.font = [UIFont systemFontOfSize:__SCALE(12)];
        _secondWay.preferredMaxLayoutWidth = self.view.frame.size.width - 20.f;
        [_secondWay setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _secondWay.numberOfLines = 0;
    }
    return _secondWay;
}
- (UILabel *)thirdWay{
    if (!_thirdWay) {
        _thirdWay = [UILabel new];
        _thirdWay.textColor = [UIColor lightGrayColor];
        _thirdWay.text = @"请检查您所连接的wifi网络是否接入互联网，或该网络是否允许您的而被访问互联网。";
        _thirdWay.font = [UIFont systemFontOfSize:__SCALE(12)];
        _thirdWay.preferredMaxLayoutWidth = self.view.frame.size.width - 20.f;
        [_thirdWay setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _thirdWay.numberOfLines = 0;
    }
    return _thirdWay;
}

- (UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton addTarget:self action:@selector(leftBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setTitle:@"去设置网络" forState:UIControlStateNormal];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:__SCALE(13)];
        [_leftButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        _leftButton.layer.borderColor = UIColorFromRGB(0xbbbbbb).CGColor;
        _leftButton.layer.borderWidth = .5f;
        _leftButton.backgroundColor = [UIColor whiteColor];
        _leftButton.layer.masksToBounds = YES;
        _leftButton.layer.cornerRadius = 2.0f;
    }
    return _leftButton;
}


- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _lineView;
}


@end
