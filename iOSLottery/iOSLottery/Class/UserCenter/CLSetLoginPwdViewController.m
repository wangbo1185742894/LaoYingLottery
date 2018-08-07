//
//  CLSetLoginPwdViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/18.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLSetLoginPwdViewController.h"
#import "CQInputTextFieldView.h"
#import "NSString+Legitimacy.h"
#import "NSString+Coding.h"
#import "CLSetLoginPwdAPI.h"
#import "CLSettingAdapter.h"
#import "UINavigationItem+CLNavigationCustom.h"

@interface CLSetLoginPwdViewController () <CLRequestCallBackDelegate,CLRequestParamSource>

@property (nonatomic, strong) CQInputTextFieldView* reNewPwd;

@property (nonatomic, strong) CQInputTextFieldView* commitPwd;

@property (nonatomic, strong) UIButton* commitBtn;

@property (nonatomic, strong) CLSetLoginPwdAPI* setLoginPwdAPI;

@property (nonatomic, strong) UIButton* skipBtn;

@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation CLSetLoginPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"设置登录密码";
    self.view.backgroundColor = UIColorFromRGB(0xefefef);
    [self.view addSubview:self.reNewPwd];
    [self.view addSubview:self.commitPwd];
    [self.view addSubview:self.commitBtn];
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.skipBtn];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.backBtn]];
    [self.reNewPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(__SCALE(40));
        make.top.equalTo(self.view).offset(0);
    }];
    
    [self.commitPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.reNewPwd);
        make.top.equalTo(self.reNewPwd.mas_bottom);
    }];
    
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.commitPwd.mas_bottom).offset(20);
        make.height.mas_equalTo(__SCALE(37));
    }];
    
    [self configureCommitEnableState];
}

- (void)configureCommitEnableState {
    
    BOOL ret = (self.reNewPwd.inputValidState && self.commitPwd.inputValidState);
    
    self.commitBtn.enabled = ret;
    [self.commitBtn setBackgroundColor:ret?THEME_COLOR:UNABLE_COLOR];
    self.commitBtn.layer.borderColor = THEME_COLOR.CGColor;
}

- (void)commitClicked:(id)sender {
    
    if (![self.reNewPwd.text isEqualToString:self.commitPwd.text]) {
        [self show:@"两次密码输入不一致"];
        return;
    }
    
    [self.setLoginPwdAPI start];
}
#pragma mark ------------ event Response ------------
- (void)btnOnClick:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
    !self.setPwdFinishBlock ? : self.setPwdFinishBlock();
}
#pragma mark - 导航栏按钮触发事件
- (void)skipClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - CLRequestParamSource,CLRequestCallBackDelegate

- (NSDictionary *)paramsForPostApi:(CLBaseRequest *)request {
    
    return @{@"password":self.reNewPwd.text.md5,
             @"re_password":self.reNewPwd.text.md5};
}

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request.urlResponse.success) {
        [self show:@"设置成功"];
        [CLSettingAdapter updateLoginPwdStatus:YES];
        !self.setPwdFinishBlock ? : self.setPwdFinishBlock();
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self show:request.urlResponse.errorMessage];
    }
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
}

#pragma mark - getter

- (UIButton *)backBtn{
    
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_backBtn setImage:[UIImage imageNamed:@"allBack.png"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (CQInputTextFieldView *)reNewPwd
{
    if (!_reNewPwd) {
        _reNewPwd = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, __SCALE(35))];
        textLbl.text = @"新密码";
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = FONT(13);
        _reNewPwd.leftView = textLbl;
        _reNewPwd.secureTextEntry = YES;
        _reNewPwd.canShowSecureTxt = YES;
        _reNewPwd.textPlaceholder = @"请输入6-15位数字或字符";
        _reNewPwd.limitLength = 15;
        _reNewPwd.inputTextType = inputTextTypeUnderline;
        WS(_weakSelf)
        _reNewPwd.checkImputTextValid = ^BOOL(NSString* text){
            return text.checkDomainOfCharAndNum;
        };
        _reNewPwd.textContentChange = ^{
            [_weakSelf configureCommitEnableState];
        };
    }
    return _reNewPwd;
}

- (CQInputTextFieldView *)commitPwd
{
    if (!_commitPwd) {
        _commitPwd = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, __SCALE(35))];
        textLbl.text = @"确认密码";
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = FONT(13);
        _commitPwd.leftView = textLbl;
        _commitPwd.secureTextEntry = YES;
        _commitPwd.canShowSecureTxt = YES;
        _commitPwd.textPlaceholder = @"请再次输入新密码";
        _commitPwd.limitLength = 15;
        _commitPwd.inputTextType = inputTextTypeUnderline;
        WS(_weakSelf)
        _commitPwd.checkImputTextValid = ^BOOL(NSString* text){
            return text.checkDomainOfCharAndNum;
        };
        _commitPwd.textContentChange = ^{
            [_weakSelf configureCommitEnableState];
        };
    }
    return _commitPwd;
}

- (UIButton *)commitBtn {
    
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitBtn setBackgroundColor:[UIColor blueColor]];
        _commitBtn.titleLabel.font = FONT_SCALE(14);
        _commitBtn.layer.borderWidth = .5f;
        [_commitBtn addTarget:self action:@selector(commitClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (UIButton *)skipBtn
{
    if (!_skipBtn) {
        _skipBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _skipBtn.frame = __Rect(0, 0, 50.f, 30.f);
        [_skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [_skipBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        _skipBtn.titleLabel.font = FONT_SCALE(13.f);
        [_skipBtn addTarget:self action:@selector(skipClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipBtn;
}
- (CLSetLoginPwdAPI *)setLoginPwdAPI{
    
    if (!_setLoginPwdAPI) {
        _setLoginPwdAPI = [[CLSetLoginPwdAPI alloc] init];
        _setLoginPwdAPI.delegate = self;
        _setLoginPwdAPI.paramSource = self;
    }
    return _setLoginPwdAPI;
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
