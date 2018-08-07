//
//  CLLoginSMSView.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/5.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLoginSMSView.h"
#import "CQInputTextFieldView.h"
#import "CLConfigMessage.h"
#import "NSString+Legitimacy.h"
#import "UIButton+SMSCertify.h"
#import "CLSaveUserPassWordTool.h"

@interface CLLoginSMSView () <SMSCertifyDelegate>

@property (nonatomic, strong) CQInputTextFieldView* mobileText;
@property (nonatomic, strong) CQInputTextFieldView* certifyCodeText;
@property (nonatomic, strong) UIButton* certifyBtn;
@property (nonatomic, strong) UIButton* commitBtn;
@property (nonatomic, strong) UILabel* messageLbl;

@end

@implementation CLLoginSMSView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void) createUI {
    
    [self addSubview:self.mobileText];
    [self addSubview:self.certifyCodeText];
    [self addSubview:self.commitBtn];
    [self addSubview:self.messageLbl];

    [self.mobileText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commitBtn);
        make.right.equalTo(self.commitBtn);
        make.top.equalTo(self);
        make.height.mas_equalTo(__SCALE(35));
    }];
    
    [self.certifyCodeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mobileText);
        make.right.equalTo(self.mobileText);
        make.top.equalTo(self.mobileText.mas_bottom).offset(__SCALE(15.f));
        make.height.equalTo(self.mobileText);
    }];
    
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(20.f));
        make.right.equalTo(self).offset(__SCALE(- 20.f));
        make.top.equalTo(self.certifyCodeText.mas_bottom).offset(__SCALE(20));
        make.height.equalTo(self.mobileText);
    }];
    
    [self.messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.commitBtn.mas_bottom);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self).offset(__SCALE(-10.f));
    }];
    
}

#pragma mark - 判断登录按钮点击状态

- (void) chechCommitBtnEnable {
    
    BOOL ret = (self.mobileText.inputValidState && self.certifyCodeText.inputValidState);
    self.commitBtn.enabled = ret;
    [self.commitBtn setBackgroundColor:ret?THEME_COLOR:UNABLE_COLOR];
    self.commitBtn.layer.borderColor = ret ? THEME_COLOR.CGColor : THEME_COLOR.CGColor;
    
    if (self.mobileText.inputValidState) {
        
        if ([self.delegate respondsToSelector:@selector(smsSyncRightMobile:)]) {
            
            [self.delegate smsSyncRightMobile:self.mobileText.text];
        }
    }
}
#pragma mark - 判断验证码是否可以被点击
- (void) checkCertifyCodeEnbale{
    
    self.certifyBtn.backgroundColor = self.mobileText.inputValidState ? THEME_COLOR : UNABLE_COLOR;
    self.certifyBtn.enabled = self.mobileText.inputValidState;
}
- (void) commitClicked:(id)sender {
    
    //登录
    _mobile = self.mobileText.text;
    _verity_code = self.certifyCodeText.text;
    
    if ([self.delegate respondsToSelector:@selector(SMSLoginCommitEventWithMobile:verityCode:)]) {
        [self.delegate SMSLoginCommitEventWithMobile:_mobile verityCode:_verity_code];
    }
}

#pragma mark - SMSCertifyDelegate

- (void) startTimeCountDown {
    
    if (!self.mobileText.inputValidState) {
        return;
    }
    self.mobileText.inputEnable = NO;
    if ([self.delegate respondsToSelector:@selector(sendSMSVerifyCode:)]) {
        [self.delegate sendSMSVerifyCode:self.mobileText.text];
    }
}

- (void) endTimeCountDown {
    
    self.mobileText.inputEnable = YES;
}

- (BOOL) canStarting {
    
    return self.mobileText.inputValidState;
}

- (void)syncMobile:(NSString *)defaultMobile{
    
    if ([defaultMobile isEqualToString:self.mobileText.text]) {
        return;
    }
    self.mobileText.defautlText = defaultMobile;
    [self checkCertifyCodeEnbale];
}

#pragma mark - getter

- (CQInputTextFieldView *)mobileText {
    
    if (!_mobileText) {
        WS(_weakSelf)
        _mobileText = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, __SCALE(35))];
        textLbl.text = @"手机号:";
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = FONT(14);
        _mobileText.leftViewEdgeType = CLLeftViewEdgeTypeEdge;
        _mobileText.leftView = textLbl;
        _mobileText.defautlText = [CLSaveUserPassWordTool readUserId];
        _mobileText.limitType = CQInputLimitTypeNumber;
        _mobileText.limitLength = 11;
        _mobileText.textPlaceholder = @"已注册的手机号";
        _mobileText.inputTextType = inputTextTypeUnderline;
        _mobileText.keyBoardType = UIKeyboardTypeNumberPad;
        _mobileText.checkImputTextValid = ^BOOL(NSString* text){
            return [text checkTelephoneValid];
        };
        _mobileText.textContentChange = ^{
            [_weakSelf chechCommitBtnEnable];
            [_weakSelf checkCertifyCodeEnbale];
        };
        [self checkCertifyCodeEnbale];
    }
    return _mobileText;
}
- (CQInputTextFieldView *)certifyCodeText {
    
    if (!_certifyCodeText) {
        _certifyCodeText = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, __SCALE(35))];
        textLbl.text = @"验证码:";
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = FONT(14);
        _certifyCodeText.leftViewEdgeType = CLLeftViewEdgeTypeEdge;
        _certifyCodeText.leftView = textLbl;
        _certifyCodeText.rightView = self.certifyBtn;
        _certifyCodeText.textPlaceholder = @"输入短信中的验证码";
        _certifyCodeText.inputTextType = inputTextTypeUnderline;
        _certifyCodeText.limitType = CQInputLimitTypeNumber;
        _certifyCodeText.limitLength = 4;
        _certifyCodeText.keyBoardType = UIKeyboardTypeNumberPad;
        WS(_weakSelf)
        _certifyCodeText.checkImputTextValid = ^BOOL(NSString* text){
            return ((text.length == 4) && [text isPureNumandCharacters]);
        };
        _certifyCodeText.textContentChange = ^{
            [_weakSelf chechCommitBtnEnable];
        };
    }
    return _certifyCodeText;
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

- (UIButton *)commitBtn {
    
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _commitBtn.enabled = NO;
        [_commitBtn setBackgroundColor:UNABLE_COLOR];
        [_commitBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = FONT_SCALE(15.f);
        _commitBtn.layer.cornerRadius = 2.f;
        _commitBtn.layer.borderWidth = .5f;
        _commitBtn.layer.borderColor = THEME_COLOR.CGColor;
        [_commitBtn addTarget:self action:@selector(commitClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _commitBtn;
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

- (void)dealloc {
    
    self.certifyBtn.smsDelegate = nil;
}

@end
