//
//  CLAddBankCardCertifyViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/5.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLAddBankCardCertifyViewController.h"
#import "CQInputTextFieldView.h"
#import "NSString+Legitimacy.h"
#import "UIButton+SMSCertify.h"
#import "CLSendVerifyCodeAPI.h"
#import "CLBindBankCardAPI.h"
#import "CLLoadingAnimationView.h"
#import "CLAllAlertInfo.h"
#import "CLAlertPromptMessageView.h"
#import "CLAllJumpManager.h"

@interface CLAddBankCardCertifyViewController () <SMSCertifyDelegate,CLRequestCallBackDelegate>

@property (nonatomic, strong) CQInputTextFieldView* bankNameText;
@property (nonatomic, strong) CQInputTextFieldView* mobileText;
@property (nonatomic, strong) CQInputTextFieldView* certifyCodeText;
@property (nonatomic, strong) UIButton* commitBtn;

@property (nonatomic, strong) UIButton* certifyBtn;

@property (nonatomic, strong) CLSendVerifyCodeAPI* sendVerifyAPI;
@property (nonatomic, strong) CLBindBankCardAPI* bindBankCardAPI;
@property (nonatomic, strong) UIButton* mobileIntrBtn;
@property (nonatomic, strong) CLAlertPromptMessageView *alertPromptMessageView;
@end

@implementation CLAddBankCardCertifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"银行卡确认信息";
    [self createUI];
    [self updateCommitBtnEnable];
    if (self.bankCardBinInfo) {
        self.bankNameText.defautlText = [NSString stringWithFormat:@"%@",self.bankCardBinInfo[@"bank_short_name"]];
    }
}

- (void) createUI {
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [self.view addSubview:self.bankNameText];
    [self.view addSubview:self.mobileText];
    [self.view addSubview:self.certifyCodeText];
    [self.view addSubview:self.certifyCodeText];
    [self.view addSubview:self.commitBtn];
    
    [self.bankNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(0);
        make.height.mas_offset(__SCALE(35));
    }];
    
    [self.mobileText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.bankNameText.mas_bottom).offset(10);
        make.height.equalTo(self.bankNameText);
    }];
    
    [self.certifyCodeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mobileText.mas_bottom);
        make.height.equalTo(self.bankNameText);
    }];
    
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.certifyCodeText.mas_bottom).offset(50);
        make.height.mas_equalTo(__SCALE(35));
    }];
    
}

- (void)updateCommitBtnEnable
{
    BOOL ret = (self.mobileText.inputValidState && self.certifyCodeText.inputValidState);
    self.commitBtn.enabled = ret;
    [self.commitBtn setBackgroundColor:ret?THEME_COLOR:UNABLE_COLOR];
    self.commitBtn.layer.borderColor = THEME_COLOR.CGColor;
}
#pragma mark ------------ event Response ------------
- (void) commitClicked:(id)sender {
    
    self.bindBankCardAPI.bankCardBinDict = self.bankCardBinInfo;
    self.bindBankCardAPI.mobile = self.mobileText.text;
    self.bindBankCardAPI.certifyCode = self.certifyCodeText.text;
    
    
    [self.bindBankCardAPI start];
    [[CLLoadingAnimationView shareLoadingAnimationView] showLoadingAnimationWithView:self.view type:CLLoadingAnimationTypeNormal];
}
- (void)mobileIntrEvent:(UIButton *)btn{
    
    [self.alertPromptMessageView showInView:self.view.window];
}
#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
    if (request == self.sendVerifyAPI) {
        if (request.urlResponse.success) {
            [self show:@"验证码已发送,请注意查收"];
        }
    } else {
        
        if (request.urlResponse.success) {
            [self show:@"绑卡成功"];
            DELAY(1.f, ^{
                if (self.blockName && self.blockName.length > 0) {
                    [[CLAllJumpManager shareAllJumpManager] open:self.blockName];
                }
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
            });
            
        } else {
            [self show:request.urlResponse.errorMessage];
        }
        
    }
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
    if (request == self.sendVerifyAPI) {
        //忽略
    } else {
        [self show:request.urlResponse.errorMessage];
    }
}

#pragma mark - SMSCertifyDelegate

- (void)startTimeCountDown {
    
    self.sendVerifyAPI.mobile = self.mobileText.text;
    self.mobileText.inputEnable = NO;
    [self.sendVerifyAPI start];
    [[CLLoadingAnimationView shareLoadingAnimationView] showLoadingAnimationWithView:self.view type:CLLoadingAnimationTypeNormal];
}

- (void)endTimeCountDown {
    
    self.mobileText.inputEnable = YES;
}

- (BOOL)canStarting {
    
    if (!self.mobileText.inputValidState) {
        [self show:@"手机号码格式不正确"];
    }
    return self.mobileText.inputValidState;
}

#pragma mark - getter

- (CQInputTextFieldView *)bankNameText {
    
    if (!_bankNameText) {
        _bankNameText = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, __SCALE(35))];
        textLbl.text = @"所属银行:";
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = FONT(13);
        _bankNameText.leftView = textLbl;
        _bankNameText.textColor = THEME_COLOR;
        _bankNameText.defautlText = @"";
        _bankNameText.inputEnable = NO;
        _bankNameText.inputTextType = inputTextTypeUnderline;
    }
    return _bankNameText;
}

- (CQInputTextFieldView *)mobileText {
    
    if (!_mobileText) {
        _mobileText = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, __SCALE(70), __SCALE(35))];
        textLbl.text = @"预留手机号:";
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = FONT(13);
        _mobileText.leftView = textLbl;
        _mobileText.textPlaceholder = @"银行登记的预留手机号";
        _mobileText.rightView = self.mobileIntrBtn;
        _mobileText.inputTextType = inputTextTypeUnderline;
        _mobileText.limitType = CQInputLimitTypeNumber;
        _mobileText.limitLength = 11;
        _mobileText.keyBoardType = UIKeyboardTypeNumberPad;
        _mobileText.checkImputTextValid = ^BOOL(NSString* text){
            return [text checkTelephoneValid];
        };
    
    }
    return _mobileText;
}
- (CQInputTextFieldView *)certifyCodeText {
    
    if (!_certifyCodeText) {
        _certifyCodeText = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, __SCALE(35))];
        textLbl.text = @"验证码:";
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = FONT(13);
        _certifyCodeText.leftView = textLbl;
        _certifyCodeText.rightView = self.certifyBtn;
        _certifyCodeText.textPlaceholder = @"请输入4位验证码";
        _certifyCodeText.limitLength = 4;
        _certifyCodeText.inputTextType = inputTextTypeUnderline;
        _certifyCodeText.limitType = CQInputLimitTypeNumber;
        _certifyCodeText.keyBoardType = UIKeyboardTypeNumberPad;
        WS(_weakSelf)
        _certifyCodeText.checkImputTextValid = ^BOOL(NSString* text){
            return ((text.length == 4) && [text isPureNumandCharacters]);
        };
        _certifyCodeText.textContentChange = ^{
            [_weakSelf updateCommitBtnEnable];
        };
    }
    return _certifyCodeText;
}

- (UIButton *)commitBtn {
    
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _commitBtn.enabled = NO;
        [_commitBtn setBackgroundColor:UNABLE_COLOR];
        [_commitBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = FONT_SCALE(15.f);
        _commitBtn.layer.cornerRadius = 2.f;
        _commitBtn.layer.borderWidth = .5f;
        [_commitBtn addTarget:self action:@selector(commitClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _commitBtn;
}

- (UIButton *)certifyBtn {
    
    if (!_certifyBtn) {
        _certifyBtn = [[UIButton alloc] initWithFrame:__Rect(0, 0, __SCALE(90.f), __SCALE(30.f))];
        [_certifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _certifyBtn.layer.borderWidth = .5f;
        _certifyBtn.layer.borderColor = UIColorFromRGB(0xaaddff).CGColor;
        [_certifyBtn setBackgroundColor:THEME_COLOR];
        _certifyBtn.titleLabel.font = FONT_FIX(11.f);
        _certifyBtn.layer.cornerRadius = 3.f;
        _certifyBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_certifyBtn addCertifyDelegate:self];
    }
    return _certifyBtn;

}
- (UIButton *)mobileIntrBtn
{
    if (!_mobileIntrBtn) {
        _mobileIntrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mobileIntrBtn.frame = __Rect(0, 0, __SCALE(30.f), __SCALE(30.f));
        _mobileIntrBtn.backgroundColor = [UIColor whiteColor];
        [_mobileIntrBtn setImage:[UIImage imageNamed:@"bankCardNeedMobile.png"] forState:UIControlStateNormal];
        [_mobileIntrBtn addTarget:self action:@selector(mobileIntrEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mobileIntrBtn;
}
- (CLSendVerifyCodeAPI *)sendVerifyAPI {
    
    if (!_sendVerifyAPI) {
        _sendVerifyAPI = [[CLSendVerifyCodeAPI alloc] init];
        _sendVerifyAPI.delegate = self;
    }
    return _sendVerifyAPI;
}

- (CLBindBankCardAPI *)bindBankCardAPI {
    
    if (!_bindBankCardAPI) {
        _bindBankCardAPI = [[CLBindBankCardAPI alloc] init];
        _bindBankCardAPI.delegate = self;
    }
    return _bindBankCardAPI;
}

- (CLAlertPromptMessageView *)alertPromptMessageView{
    
    if (!_alertPromptMessageView) {
        _alertPromptMessageView = [[CLAlertPromptMessageView alloc] init];
        _alertPromptMessageView.desTitle = allAlertInfo_BankCardNeedMobile;
        _alertPromptMessageView.cancelTitle = @"知道了";
        
    }
    return _alertPromptMessageView;
}
- (void)dealloc {
    
    if (_sendVerifyAPI) {
        _sendVerifyAPI.delegate = nil;
        [_sendVerifyAPI cancel];
    }
    
    if (_bindBankCardAPI) {
        _bindBankCardAPI.delegate = nil;
        [_bindBankCardAPI cancel];
    }
    
    self.certifyBtn.smsDelegate = nil;
    
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
