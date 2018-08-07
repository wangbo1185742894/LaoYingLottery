//
//  CLLoginPwdView.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/5.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLoginPwdView.h"
#import "CQInputTextFieldView.h"
#import "NSString+Legitimacy.h"
#import "CLConfigMessage.h"
#import "CLSaveUserPassWordTool.h"
@interface CLLoginPwdView ()

@property (nonatomic, strong) CQInputTextFieldView* accountText;
@property (nonatomic, strong) CQInputTextFieldView* pwdText;
@property (nonatomic, strong) UIButton* forgetPwdBtn;
@property (nonatomic, strong) UIButton* storePwdBtn;
@property (nonatomic, strong) UIButton* commitBtn;

@end

@implementation CLLoginPwdView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.accountText];
        [self addSubview:self.pwdText];
        [self addSubview:self.storePwdBtn];
        [self addSubview:self.forgetPwdBtn];
        [self addSubview:self.commitBtn];
        
        [self.accountText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(__SCALE(20.f));
            make.right.equalTo(self).offset(__SCALE(-20.f));
            make.top.equalTo(self);
            make.height.mas_equalTo(__SCALE(35));
        }];
        
        [self.pwdText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.accountText);
            make.right.equalTo(self.accountText);
            make.top.equalTo(self.accountText.mas_bottom).offset(__SCALE(15.f));
            make.height.equalTo(self.accountText);
        }];

        [self.storePwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.pwdText);
            make.top.equalTo(self.pwdText.mas_bottom).offset(__SCALE(5));
//            make.width.mas_equalTo(80);
            make.height.mas_equalTo(20);
        }];
        
        [self.forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.storePwdBtn);
            make.right.equalTo(self.accountText);
            make.height.equalTo(self.storePwdBtn);
        }];
        
        [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.storePwdBtn.mas_bottom).offset(__SCALE(20.f));
            make.left.equalTo(self.accountText);
            make.right.equalTo(self.accountText);
            make.bottom.equalTo(self).offset(__SCALE(-10));
            make.height.equalTo(self.accountText);
        }];
        [self chechCommitBtnEnable];
    }
    return self;
}

#pragma mark - private

- (void) commitEvent:(id)sender {
    
    _account = self.accountText.text;
    _password = self.pwdText.text;
    if ([self.delegate respondsToSelector:@selector(pwdLoginEventWithMobile:password:)]) {
        [self.delegate pwdLoginEventWithMobile:_account password:_password];
    }
}

- (void) forgetEvent:(id)sender {

    if ([self.delegate respondsToSelector:@selector(forgetPwdEvent)]) {
        [self.delegate forgetPwdEvent];
    }
}

- (void) storeEvent:(id)sender {
    
    _isStoreingPwd = !_isStoreingPwd;
     [_storePwdBtn setImage:[UIImage imageNamed:_isStoreingPwd?@"checkboxSelect":@"checkboxUnSelect"] forState:UIControlStateNormal];
}

- (void) chechCommitBtnEnable {
    
    BOOL ret = (self.accountText.inputValidState &&
                self.pwdText.inputValidState);
    self.commitBtn.enabled = ret;
    [self.commitBtn setBackgroundColor:ret?THEME_COLOR:UNABLE_COLOR];
    self.commitBtn.layer.borderColor = THEME_COLOR.CGColor;

    if (self.accountText.inputValidState) {
        
        if ([self.delegate respondsToSelector:@selector(pwdSyncRightMobile:)]) {
            
            [self.delegate pwdSyncRightMobile:self.accountText.text];
        }
    }
}
- (void)syncMobile:(NSString *)defaultMobile{
    
    if ([defaultMobile isEqualToString:self.accountText.text]) {
        return;
    }
    self.accountText.defautlText = defaultMobile;
}
#pragma mark  - getter

- (CQInputTextFieldView *)accountText {
    
    if (!_accountText) {
        _accountText = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        _accountText.leftViewEdgeType = CLLeftViewEdgeTypeEdge;
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, __SCALE(35))];
        textLbl.text = @"账号:";
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = FONT(14);
        _accountText.leftView = textLbl;
        _accountText.textPlaceholder = @"已注册的手机号";
        _accountText.inputTextType = inputTextTypeUnderline;
        _accountText.limitType = CQInputLimitTypeNumber;
        _accountText.limitLength = 11;
        _accountText.checkImputTextValid = ^BOOL(NSString* text){
            return [text checkTelephoneValid];
        };
        WS(_weakSelf)
        _accountText.textContentChange = ^{
            [_weakSelf chechCommitBtnEnable];
        };
        _accountText.defautlText = [CLSaveUserPassWordTool readUserId];
    }
    return _accountText;
}

- (CQInputTextFieldView *)pwdText {
    
    if (!_pwdText) {
        _pwdText = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, __SCALE(35))];
        textLbl.text = @"密码:";
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = FONT(14);
        _pwdText.leftViewEdgeType = CLLeftViewEdgeTypeEdge;
        _pwdText.leftView = textLbl;
        _pwdText.secureTextEntry = YES;
        _pwdText.canShowSecureTxt = YES;
        _pwdText.textPlaceholder = @"请填写密码";
        _pwdText.inputTextType = inputTextTypeUnderline;
        _pwdText.limitLength = 15;
        _pwdText.checkImputTextValid = ^BOOL(NSString* text){
            return [text checkDomainOfCharAndNum];
        };
        WS(_weakSelf)
        _pwdText.textContentChange = ^{
            [_weakSelf chechCommitBtnEnable];
        };
        _pwdText.defautlText = [CLSaveUserPassWordTool readPassWord];
    }
    return _pwdText;
}

- (UIButton *)storePwdBtn {
    
    if (!_storePwdBtn) {
        _storePwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_storePwdBtn setImage:[UIImage imageNamed:@"checkboxSelect"] forState:UIControlStateNormal];
        [_storePwdBtn setTitle:@"记住密码" forState:UIControlStateNormal];
        [_storePwdBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_storePwdBtn addTarget:self action:@selector(storeEvent:) forControlEvents:UIControlEventTouchUpInside];
        _storePwdBtn.contentMode = UIViewContentModeLeft;
        _storePwdBtn.titleLabel.font = FONT_SCALE(10);
        _storePwdBtn.imageEdgeInsets = UIEdgeInsetsMake(0, - 3, 0, 0);
        
    }
    return _storePwdBtn;
}

- (UIButton *)forgetPwdBtn {
    
    if (!_forgetPwdBtn) {
        _forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPwdBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetPwdBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_forgetPwdBtn addTarget:self action:@selector(forgetEvent:) forControlEvents:UIControlEventTouchUpInside];
        _storePwdBtn.contentMode = UIViewContentModeRight;
        _forgetPwdBtn.titleLabel.font = FONT_SCALE(10);

    }
    return _forgetPwdBtn;
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
        [_commitBtn addTarget:self action:@selector(commitEvent:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _commitBtn;
}

@end
