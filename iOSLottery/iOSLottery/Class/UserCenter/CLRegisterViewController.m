//
//  CLRegisterViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/5.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLRegisterViewController.h"
#import "CQInputTextFieldView.h"
#import "NSString+Legitimacy.h"
#import "UIButton+SMSCertify.h"
#import "CLSendVerifyCodeAPI.h"
#import "CLUserLoginRegisterAPI.h"
#import "CLLoginRegisterAdapter.h"
#import "CLSaveUserPassWordTool.h"


@interface CLRegisterViewController () <SMSCertifyDelegate,CLRequestCallBackDelegate>

@property (nonatomic, strong) CQInputTextFieldView* mobileText;
@property (nonatomic, strong) CQInputTextFieldView* verfyCodeText;
@property (nonatomic, strong) CQInputTextFieldView* loginPwdText;
@property (nonatomic, strong) CQInputTextFieldView* loginPwdRepeatText;

@property (nonatomic, strong) UIButton* certifyBtn;
@property (nonatomic, strong) UIButton* registerBtn;
@property (nonatomic, strong) UILabel* messageLbl;

@property (nonatomic, strong) CLSendVerifyCodeAPI* sendVerifyCodeAPI;
@property (nonatomic, strong) CLUserLoginRegisterAPI* registerAPI;

@end

@implementation CLRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"注册";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
    
}

- (void) chechCommitBtnEnable {
    
    BOOL ret = (self.mobileText.inputValidState &&
                self.verfyCodeText.inputValidState &&
                self.loginPwdText.inputValidState &&
                self.loginPwdRepeatText.inputValidState);
    self.registerBtn.enabled = ret;
    [self.registerBtn setBackgroundColor:ret?THEME_COLOR:UNABLE_COLOR];
    self.registerBtn.layer.borderColor = THEME_COLOR.CGColor;
}
- (void)checkCertifyEnable{
    
    self.certifyBtn.backgroundColor = self.mobileText.inputValidState ? THEME_COLOR : UNABLE_COLOR;
    self.certifyBtn.enabled = self.mobileText.inputValidState;
}
- (void)registerClicked:(id)sender {
    
    if (![self.loginPwdText.text isEqualToString:self.loginPwdRepeatText.text]) {
        [self show:@"两次密码输入不一致"];
        return;
    }
    
    self.registerAPI.mobile = self.mobileText.text;
    self.registerAPI.verify_code = self.verfyCodeText.text;
    self.registerAPI.loginPassword = self.loginPwdText.text;
    [self showLoading];
    [self.registerAPI start];
}

- (void) createUI {
    
    [self.view addSubview:self.mobileText];
    [self.view addSubview:self.verfyCodeText];
    [self.view addSubview:self.loginPwdText];
    [self.view addSubview:self.loginPwdRepeatText];
    [self.view addSubview:self.registerBtn];
    [self.view addSubview:self.messageLbl];
    
    [self.mobileText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(__SCALE(20.f));
        make.right.equalTo(self.view).offset(__SCALE(- 20.f));
        make.top.equalTo(self.view).offset(__SCALE(35.f));
        make.height.mas_equalTo(__SCALE(35));
    }];

    [self.verfyCodeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.mobileText);
        make.top.equalTo(self.mobileText.mas_bottom).offset(__SCALE(15.f));
        make.height.equalTo(self.mobileText);
    }];
    
    [self.loginPwdText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.mobileText);
        make.top.equalTo(self.verfyCodeText.mas_bottom).offset(__SCALE(15.f));
        make.height.equalTo(self.mobileText);
    }];
    
    [self.loginPwdRepeatText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.mobileText);
        make.top.equalTo(self.loginPwdText.mas_bottom).offset(__SCALE(15.f));
        make.height.equalTo(self.mobileText);
    }];

    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mobileText);
        make.right.equalTo(self.mobileText);
        make.top.equalTo(self.loginPwdRepeatText.mas_bottom).offset(__SCALE(20));
        make.height.equalTo(self.mobileText);
    }];
    
    [self.messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.registerBtn.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request == self.registerAPI) {
        
        if (request.urlResponse.success) {
            
            [self checkRegisterQualifyWithData:[request.urlResponse.resp firstObject]];
            //缓存用户名
            [CLSaveUserPassWordTool saveUserId:self.mobileText.text PassWord:self.loginPwdText.text];
        } else {
            [self show:request.urlResponse.errorMessage];
        }
    } else if (request == self.sendVerifyCodeAPI) {
        if (request.urlResponse.success) {
            [self show:@"验证码已发送,请注意查收"];
        }
    }
    [self stopLoading];
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
    
    [self stopLoading];
}

- (void) checkRegisterQualifyWithData:(NSDictionary*)data{
    NSDictionary *userInfoDic = [data objectForKey:@"user_info"];
    id is_new = [userInfoDic objectForKey:@"is_new"];
    //数据合法性校验
    if (is_new == NULL) {
        [self show:@"数据错误"];
        return;
    }
    if (![is_new boolValue]) {
        [self show:@"该用户已注册"];
        return;
    }
    [CLLoginRegisterAdapter loginSuccessWithMessage:data];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - SMSCertifyDelegate

- (void) startTimeCountDown {
 
   
    self.sendVerifyCodeAPI.mobile = self.mobileText.text;
    [self showLoading];
    [self.sendVerifyCodeAPI start];
}

- (void) endTimeCountDown {
    
}

- (BOOL) canStarting {
    
    BOOL ret = self.mobileText.inputValidState;
    if (!ret) {
        [self show:@"手机号码不正确"];
    }
    return ret;
}

#pragma mark - getter

- (CQInputTextFieldView *)mobileText {
    
    if (!_mobileText) {
        _mobileText = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, __SCALE(35))];
        textLbl.text = @"手机号:";
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = FONT(14);
        _mobileText.leftView = textLbl;
        _mobileText.textPlaceholder = @"11位数字手机号";
        _mobileText.inputTextType = inputTextTypeUnderline;
        _mobileText.limitType = CQInputLimitTypeNumber;
        _mobileText.limitLength = 11;
        _mobileText.leftViewEdgeType = CLLeftViewEdgeTypeEdge;
        _mobileText.keyBoardType = UIKeyboardTypeNumberPad;
        _mobileText.checkImputTextValid = ^BOOL(NSString* text){
            return [text checkTelephoneValid];
        };
        WS(_weakSelf)
        _mobileText.textContentChange = ^{
            [_weakSelf chechCommitBtnEnable];
            [_weakSelf checkCertifyEnable];
        };
    }
    return _mobileText;
}
- (CQInputTextFieldView *)verfyCodeText {
    
    if (!_verfyCodeText) {
        _verfyCodeText = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, __SCALE(35))];
        textLbl.text = @"验证码:";
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = FONT(14);
        _verfyCodeText.leftView = textLbl;
        _verfyCodeText.rightView = self.certifyBtn;
        _verfyCodeText.textPlaceholder = @"输入短信中的验证码";
        _verfyCodeText.inputTextType = inputTextTypeUnderline;
        _verfyCodeText.limitType = CQInputLimitTypeNumber;
        _verfyCodeText.leftViewEdgeType = CLLeftViewEdgeTypeEdge;
        _verfyCodeText.limitLength = 4;
        _verfyCodeText.keyBoardType = UIKeyboardTypeNumberPad;
        WS(_weakSelf)
        _verfyCodeText.checkImputTextValid = ^BOOL(NSString* text){
            return ((text.length == 4) && [text isPureNumandCharacters]);
        };
        _verfyCodeText.textContentChange = ^{
            [_weakSelf chechCommitBtnEnable];
        };
    }
    return _verfyCodeText;
}

- (UIButton *)certifyBtn {
    
    if (!_certifyBtn) {
        _certifyBtn = [[UIButton alloc] initWithFrame:__Rect(0, 0, __SCALE(90.f), __SCALE(30.f))];
        [_certifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _certifyBtn.layer.borderWidth = .5f;
        _certifyBtn.layer.borderColor = THEME_COLOR.CGColor;
        [_certifyBtn setBackgroundColor:UNABLE_COLOR];
        _certifyBtn.enabled = NO;
        _certifyBtn.titleLabel.font = FONT_FIX(11.f);
        _certifyBtn.layer.cornerRadius = 3.f;
        _certifyBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_certifyBtn addCertifyDelegate:self];
    }
    return _certifyBtn;
}

- (CQInputTextFieldView *)loginPwdText {
    
    if (!_loginPwdText) {
        _loginPwdText = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, __SCALE(35))];
        textLbl.text = @"登录密码:";
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = FONT(14);
        _loginPwdText.leftView = textLbl;
        _loginPwdText.secureTextEntry = YES;
        _loginPwdText.canShowSecureTxt = YES;
        _loginPwdText.textPlaceholder = @"6-15位数字或字母";
        _loginPwdText.inputTextType = inputTextTypeUnderline;
        _loginPwdText.leftViewEdgeType = CLLeftViewEdgeTypeEdge;
        _loginPwdText.checkImputTextValid = ^BOOL(NSString* text){
            return [text checkDomainOfCharAndNum];
        };
        WS(_weakSelf)
        _loginPwdText.textContentChange = ^{
            [_weakSelf chechCommitBtnEnable];
        };
    }
    return _loginPwdText;
}

- (CQInputTextFieldView *)loginPwdRepeatText {
    
    if (!_loginPwdRepeatText) {
        _loginPwdRepeatText = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, __SCALE(35))];
        textLbl.text = @"确认密码:";
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = FONT(14);
        _loginPwdRepeatText.leftView = textLbl;
        _loginPwdRepeatText.secureTextEntry = YES;
        _loginPwdRepeatText.canShowSecureTxt = YES;
        _loginPwdRepeatText.textPlaceholder = @"再次输入密码";
        _loginPwdRepeatText.inputTextType = inputTextTypeUnderline;
        _loginPwdRepeatText.leftViewEdgeType = CLLeftViewEdgeTypeEdge;
        _loginPwdRepeatText.checkImputTextValid = ^BOOL(NSString* text){
            return [text checkDomainOfCharAndNum];
        };
        WS(_weakSelf)
        _loginPwdRepeatText.textContentChange = ^{
            [_weakSelf chechCommitBtnEnable];
        };
    }
    return _loginPwdRepeatText;
}

- (UIButton *)registerBtn {
    
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _registerBtn.enabled = NO;
        [_registerBtn setBackgroundColor:UNABLE_COLOR];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _registerBtn.titleLabel.font = FONT_SCALE(15.f);
        _registerBtn.layer.cornerRadius = 2.f;
        _registerBtn.layer.borderWidth = .5f;
        _registerBtn.layer.borderColor = THEME_COLOR.CGColor;
        [_registerBtn addTarget:self action:@selector(registerClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _registerBtn;
}

- (UILabel *)messageLbl {
    
    if (!_messageLbl) {
        _messageLbl = [[UILabel alloc] init];
        _messageLbl.backgroundColor = [UIColor clearColor];
        _messageLbl.text = @"老鹰彩票不会在任何地方泄露您的手机号码";
        _messageLbl.textAlignment = NSTextAlignmentCenter;
        _messageLbl.font = FONT_SCALE(10);
        _messageLbl.textColor = UIColorFromRGB(0xdcdcdc);
    }
    return _messageLbl;
}

- (CLSendVerifyCodeAPI *)sendVerifyCodeAPI {
    
    if (!_sendVerifyCodeAPI) {
        _sendVerifyCodeAPI = [[CLSendVerifyCodeAPI alloc] init];
        _sendVerifyCodeAPI.delegate = self;
    }
    return _sendVerifyCodeAPI;
}

- (CLUserLoginRegisterAPI *)registerAPI {
    
    if (!_registerAPI) {
        _registerAPI = [[CLUserLoginRegisterAPI alloc] init];
        _registerAPI.delegate = self;
    }
    return _registerAPI;
}

- (void)dealloc {
    
    if (_sendVerifyCodeAPI) {
        _sendVerifyCodeAPI.delegate = nil;
        [_sendVerifyCodeAPI cancel];
    }
    if (_registerAPI) {
        _registerAPI.delegate = nil;
        [_registerAPI cancel];
    }
    
    self.certifyBtn.smsDelegate = nil;
//    NSLog(@"-----dealloc");
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
