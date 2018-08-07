//
//  CLUserCertifySuccessViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/24.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLUserCertifySuccessViewController.h"
#import "CLAllJumpManager.h"
#import "CLAlertController.h"
@interface CLUserCertifySuccessViewController ()<CLAlertControllerDelegate>

@property (nonatomic, strong) UIImageView *headImageView;//顶部图片
@property (nonatomic, strong) UILabel *verifyLabel;//提交审核
@property (nonatomic, strong) UILabel *descLabel;//描述信息
@property (nonatomic, strong) UIButton *serviceButton;//客服电话
@property (nonatomic, strong) UIButton *commitButton;//完成按钮
@property (nonatomic, strong) CLAlertController *actionSheet;//客服电话actionSheet
@property (nonatomic, strong) UIButton *leftBackButton;//导航左侧返回按钮

@end

@implementation CLUserCertifySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navTitleText = @"实名成功";
    [self.view addSubview:self.headImageView];
    [self.view addSubview:self.verifyLabel];
    [self.view addSubview:self.descLabel];
    [self.view addSubview:self.serviceButton];
    [self.view addSubview:self.commitButton];
    [self addSubContraint];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.leftBackButton]];
    // Do any additional setup after loading the view.
}


#pragma mark - actionSheetDelegate
- (void)alertController:(CLAlertController *)alertController SelectIndex:(NSInteger)index{
    
    if (index == 1) {
        
        NSString *phoneNum = @"4006892227";// 电话号码
        NSURL *url = [NSURL URLWithString:phoneNum];
        UIWebView *webView = [[UIWebView alloc] init];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

#pragma mark - eventResponse
- (void)configButtonClick:(id)sender
{

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)serviceButtonOnClick:(id)sender{
    
    [self.actionSheet show];
}
#pragma mark - privateMothed
- (void)addSubContraint{
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(__SCALE(30.f) + 0);
        make.width.height.mas_equalTo(__SCALE(58.f));
    }];
    [self.verifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headImageView);
        make.top.equalTo(self.headImageView.mas_bottom).offset(__SCALE(25.f));
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headImageView);
        make.top.equalTo(self.verifyLabel.mas_bottom).offset(__SCALE(8.f));
    }];
    [self.serviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headImageView);
        make.top.equalTo(self.descLabel.mas_bottom).offset(__SCALE(0.f));
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headImageView);
        make.top.equalTo(self.serviceButton.mas_bottom).offset(__SCALE(30.f));
        make.height.mas_equalTo(__SCALE(37.f));
        make.width.mas_equalTo(SCREEN_WIDTH - __SCALE(10.f) * 2);
    }];
    
}
#pragma mark - getterMothed
- (UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headImageView.image = [UIImage imageNamed:@"cashFinished.png"];
    }
    return _headImageView;
}
- (UILabel *)verifyLabel{
    if (!_verifyLabel) {
        _verifyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _verifyLabel.text = @"已提交审核";
        _verifyLabel.font = FONT_SCALE(18);
        _verifyLabel.textAlignment = NSTextAlignmentCenter;
        _verifyLabel.textColor = UIColorFromRGB(0x333333);
    }
    return _verifyLabel;
}
- (UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLabel.textColor = UIColorFromRGB(0x666666);
        _descLabel.font = FONT_SCALE(12);
        _descLabel.text = @"1个工作日内处理，或需求客服帮助";
    }
    return _descLabel;
}
- (UIButton *)serviceButton{
    
    if (!_serviceButton) {
        _serviceButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_serviceButton setTitle:@"400-689-2227" forState:UIControlStateNormal];
        [_serviceButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        _serviceButton.titleLabel.font = FONT_SCALE(12);
        [_serviceButton addTarget:self action:@selector(serviceButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _serviceButton;
}
- (UIButton *)commitButton{
    if (!_commitButton) {
        _commitButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_commitButton setTitle:@"完成" forState:UIControlStateNormal];
        [_commitButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(configButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _commitButton.titleLabel.font = FONT_SCALE(15);
        _commitButton.backgroundColor = THEME_COLOR;
        _commitButton.layer.cornerRadius = 3.f;
    }
    return _commitButton;
}
- (UIButton *)leftBackButton{
    if (!_leftBackButton) {
        _leftBackButton = [[UIButton alloc] initWithFrame:__Rect(0, 0, __SCALE(30.f), __SCALE(30.f))];
        [_leftBackButton setImage:[UIImage imageNamed:@"allBack.png"] forState:UIControlStateNormal];
        [_leftBackButton addTarget:self action:@selector(configButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBackButton;
}
#pragma mark - 客服电话显示Alert
- (CLAlertController *)actionSheet{
    
    if (!_actionSheet) {
        _actionSheet = [CLAlertController alertControllerWithTitle:nil message:@"请联系客服寻求帮助" style:CLAlertControllerStyleActionSheet delegate:self];
        _actionSheet.buttonItems = @[@"取消", @"呼叫 400-689-2227"];
    }
    return _actionSheet;
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
