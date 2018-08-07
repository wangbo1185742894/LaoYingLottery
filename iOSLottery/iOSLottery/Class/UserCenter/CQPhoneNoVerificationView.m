//
//  CQPhoneNoVerificationView.m
//  caiqr
//
//  Created by 彩球 on 15/9/15.
//  Copyright (c) 2015年 Paul. All rights reserved.
//

#import "CQPhoneNoVerificationView.h"
#import "CLConfigMessage.h"

#import "CQInputTextFieldView.h"
#import "Masonry.h"


#define PhoneNoVerificationViewEdge 10.f
#define PhoneNoVerificationCountDownMaxSec 60
#define PhoneVerificationViewHeight __SCALE(42.f)

@interface CQPhoneNoVerificationView()<UITextFieldDelegate>

@property (nonatomic, strong) CQInputTextFieldView* phoneNumberTextFieldView;
@property (nonatomic, strong) CQInputTextFieldView* verificationCodeTextFieldView;
@property (nonatomic, strong) UIButton* getVerificationCodeBtn;
@property (nonatomic, strong) UIButton* confirmBtn;
@property (nonatomic, strong) UILabel* messageLabel;

@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, assign) NSTimeInterval timerCountDownCurrentSec;
@property (nonatomic, strong) NSString* validPhoneNumber;

@end

@implementation CQPhoneNoVerificationView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer* closeKeyBoardtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapEvent:)];
        [self addGestureRecognizer:closeKeyBoardtap];

        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self addSubview:self.phoneNumberTextFieldView];
    [self addSubview:self.verificationCodeTextFieldView];
    [self addSubview:self.confirmBtn];
    [self addSubview:self.messageLabel];
//    NSLog(@"++++++++%f",CGRectGetMaxY(self.messageLabel.frame));
    [self textFieldChanged:nil];
    
    
    [self.phoneNumberTextFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(PhoneVerificationViewHeight);
    }];
    
    [self.verificationCodeTextFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.phoneNumberTextFieldView.mas_bottom);
        make.height.equalTo(self.phoneNumberTextFieldView.mas_height);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(PhoneNoVerificationViewEdge));
        make.right.equalTo(self).offset(-__SCALE(PhoneNoVerificationViewEdge));
        make.height.mas_equalTo(__SCALE(37.f));
        make.bottom.equalTo(self.messageLabel.mas_top);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.confirmBtn.mas_bottom).offset(__SCALE(5));
        make.height.mas_equalTo(__SCALE(15));
        make.bottom.equalTo(self).offset(-10);
        
    }];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideNotification:) name:UIKeyboardWillHideNotification     object:nil];
}
#pragma mark - 键盘监听响应事件
- (void)keyboardDidShowNotification:(NSNotification*)no
{
    if ([self.delegate respondsToSelector:@selector(keyBoardWillShow)]) {
        [self.delegate keyBoardWillShow];
    }
    if (self.keyBoardShowOrHide) {
        self.keyBoardShowOrHide(YES,200);
    }
    
}
- (void)keyboardDidHideNotification:(NSNotification*)no
{
    if ([self.delegate respondsToSelector:@selector(keyBoardWillHide)]) {
        [self.delegate keyBoardWillHide];
    }
    if (self.keyBoardShowOrHide) {
        self.keyBoardShowOrHide(NO,0);
    }
}
#pragma mark - 点击View响应收回键盘事件
- (void)viewTapEvent:(UITapGestureRecognizer*)tap
{
    [self hideKeyboard];
}
#pragma mark - 获取验证码按钮响应事件
- (void)getVerificationCodeEvent:(UIButton*)btn
{
    if (self.phoneNumberTextFieldView.inputValidState)
    {
        
        if ([self.delegate respondsToSelector:@selector(getVerificationCodeWithPhoneNumber:)]) {
            [self.delegate getVerificationCodeWithPhoneNumber:self.phoneNumberTextFieldView.text];
        }
        if (self.getVerificationCodeFromPhone) {
            self.getVerificationCodeFromPhone(self.phoneNumberTextFieldView.text);
        }
        self.validPhoneNumber = self.phoneNumberTextFieldView.text;
        [self setVerifyButtonAble:NO];       //设置发送验证码按钮不可点击
//        self.verificationCodeTextFieldView.inputEnable = YES;//设置验证码可输入
         [self.verificationCodeTextFieldView becomeFirstResponder];
        //开启计时器
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.timerCountDownCurrentSec = PhoneNoVerificationCountDownMaxSec;
        
        //初始化倒计时时间
        self.getVerificationCodeBtn.titleLabel.text = [NSString stringWithFormat:@"获取验证码(%zis)",PhoneNoVerificationCountDownMaxSec];
        [self.getVerificationCodeBtn setTitle:[NSString stringWithFormat:@"获取验证码(%zis)",PhoneNoVerificationCountDownMaxSec] forState:UIControlStateDisabled];
        //开始倒计时
        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerCountDown:) userInfo:nil repeats:YES];
        self.timer = timer;
        timer = nil;
    }
    else
    {
        //ERROR
        if ([self.delegate respondsToSelector:@selector(verifyExceptionDescription:)]) {
            [self.delegate verifyExceptionDescription:@"手机号码非法"];
        }
    }
}
#pragma mark - 计时器响应事件
- (void)timerCountDown:(NSTimer*)timer
{
    if (self.timerCountDownCurrentSec <= 1)
    {//倒计时结束时
        [timer invalidate];
        timer = nil;
        self.timer = nil;
        [self textFieldChanged:nil];
        [self.getVerificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.getVerificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateDisabled];
        self.phoneNumberTextFieldView.inputEnable = YES;//倒计时结束后允许改变手机号
    }
    else
    {//倒计时中
        NSInteger num = --self.timerCountDownCurrentSec;
        self.phoneNumberTextFieldView.inputEnable = NO;//倒计时过程中不允许改变手机号
        [self.getVerificationCodeBtn setTitle:[NSString stringWithFormat:@"获取验证码(%zis)",num] forState:UIControlStateDisabled];
    }
}
#pragma mark - 停止计时器timer
- (void)stopVerifyCodeTimer{
    [self.timer invalidate];
    self.timer = nil;
    [self textFieldChanged:nil];
    [self.getVerificationCodeBtn setTitle:@"获取验证码"forState:UIControlStateNormal];
    [self.getVerificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateDisabled];
    self.phoneNumberTextFieldView.inputEnable = YES;//倒计时结束后允许改变手机号
    self.timerCountDownCurrentSec = 60.f;
}
#pragma mark - 登录按钮响应事件
- (void)confirmEvent:(UIButton*)btn
{
    [self hideKeyboard];
    if (self.verificationCodeTextFieldView.inputValidState)
    {
        if ([self.phoneNumberTextFieldView.text isEqualToString:self.validPhoneNumber]) {
            if ([self.delegate respondsToSelector:@selector(confirmClicked)]) {
                [self.delegate confirmClicked];
            }
            if (self.confirmEventAction) {
                self.confirmEventAction();
            }
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(verifyExceptionDescription:)]) {
                [self.delegate verifyExceptionDescription:@"获取验证码的手机号与当前输入的手机号不一致"];
            }
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(verifyExceptionDescription:)]) {
            [self.delegate verifyExceptionDescription:@"验证码不足4位"];
        }
    }
    
}
#pragma mark - 隐藏键盘
- (void)hideKeyboard
{
    [self.phoneNumberTextFieldView becomeFirstResponder];
    [self.verificationCodeTextFieldView resignFirstResponder];
}
#pragma mark - 检查验证码是否是4位
- (BOOL)checkVerificationCode:(NSString*)code
{
    return (code.length == 4);
}

#pragma mark - textField值改变时调用的方法
- (void)textFieldChanged:(CQInputTextFieldView*)textFieldView
{
    //判断验证码是否合法
    BOOL verificationCodeValidity = self.verificationCodeTextFieldView.inputValidState;
    //判断手机号是否合法
    BOOL phoneNumberValidity = self.phoneNumberTextFieldView.inputValidState;
    
    if (!self.timer) {
        [self setVerifyButtonAble:phoneNumberValidity];
    }
    [self setConfirmBtnUsableState:(verificationCodeValidity && phoneNumberValidity)];
}
#pragma mark - 设置按钮不可被点击
//当发送验证码的时候 按钮不可被点击，并且背景颜色改变
- (void)setVerifyButtonAble:(BOOL)enAble
{
    self.getVerificationCodeBtn.enabled = enAble;
    [self.getVerificationCodeBtn setBackgroundColor:enAble?THEME_COLOR:UNABLE_COLOR];
}
//当验证码不足4位，手机号不合法时 登录按钮不能被点击
- (void)setConfirmBtnUsableState:(BOOL)state
{
    self.confirmBtn.enabled = state;
    [self.confirmBtn setBackgroundColor:state?THEME_COLOR:UNABLE_COLOR];
}

#pragma mark - setterMothed
//当进入登录页面时如果有缓存直接赋值
- (void)setPhoneNumber:(NSString *)phoneNumber
{
    self.phoneNumberTextFieldView.defautlText = phoneNumber;
    [self textFieldChanged:self.phoneNumberTextFieldView];
}
- (void)setConfirmBtnTitle:(NSString *)confirmBtnTitle
{
    _confirmBtnTitle = confirmBtnTitle;
    [self.confirmBtn setTitle:_confirmBtnTitle forState:UIControlStateNormal];
}
- (void)setIs_FirstResponde:(BOOL)is_FirstResponde{
    _is_FirstResponde = is_FirstResponde;
    if (is_FirstResponde) {
        [self.phoneNumberTextFieldView becomeFirstResponder];
    }else{
        [self.phoneNumberTextFieldView resignFirstResponder];
    }
}
#pragma mark - getterMothed
- (CQInputTextFieldView *)phoneNumberTextFieldView{
    if (!_phoneNumberTextFieldView) {
//        __Rect(0, 0, __Obj_Bounds_Width(self), __SCALE(42.f))
        _phoneNumberTextFieldView = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        _phoneNumberTextFieldView.inputTextType = inputTextTypeUnderline;
        WS(_weakSelf)
        _phoneNumberTextFieldView.textContentChange = ^(){
            [_weakSelf textFieldChanged:_weakSelf.phoneNumberTextFieldView];
        };
        _phoneNumberTextFieldView.textPlaceholder = @"已注册的手机号";
        _phoneNumberTextFieldView.keyBoardType = UIKeyboardTypeNumberPad;
        _phoneNumberTextFieldView.limitType = CQInputLimitTypeNumber;
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, __SCALE(50), PhoneVerificationViewHeight)];
        textLbl.text = @"手机号";
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = FONT(13);
        _phoneNumberTextFieldView.leftView = textLbl;
    }
    return _phoneNumberTextFieldView;
}
- (CQInputTextFieldView *)verificationCodeTextFieldView{
    if (!_verificationCodeTextFieldView) {
        _verificationCodeTextFieldView = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        _verificationCodeTextFieldView.inputTextType = inputTextTypeUnderline;
        WS(_weakSelf)
        _verificationCodeTextFieldView.textContentChange = ^(){
            [_weakSelf textFieldChanged:_weakSelf.verificationCodeTextFieldView];
        };
        _verificationCodeTextFieldView.keyboardReturnAction = ^(){
            [_weakSelf.verificationCodeTextFieldView becomeFirstResponder];
        };
        _verificationCodeTextFieldView.textPlaceholder = @"输入短信中的验证码";
        _verificationCodeTextFieldView.keyBoardType = UIKeyboardTypeNumberPad;
        _verificationCodeTextFieldView.limitType = CQInputLimitTypeNumber;
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, __SCALE(50), PhoneVerificationViewHeight)];
        textLbl.text = @"验证码";
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = FONT(13);
        _verificationCodeTextFieldView.leftView = textLbl;
        _verificationCodeTextFieldView.rightView = self.getVerificationCodeBtn;
    }
    return _verificationCodeTextFieldView;
}
- (UIButton *)getVerificationCodeBtn{
    if (!_getVerificationCodeBtn) {
        _getVerificationCodeBtn = [[UIButton alloc] initWithFrame:__Rect(0, 0, __SCALE(90.f), __SCALE(30.f))];
        [_getVerificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getVerificationCodeBtn.layer.borderWidth = .5f;
        _getVerificationCodeBtn.layer.borderColor = UIColorFromRGB(0xaaddff).CGColor;
        [_getVerificationCodeBtn setBackgroundColor:UNABLE_COLOR];
        [_getVerificationCodeBtn addTarget:self action:@selector(getVerificationCodeEvent:) forControlEvents:UIControlEventTouchUpInside];
        _getVerificationCodeBtn.titleLabel.font = FONT_FIX(11.f);
        _getVerificationCodeBtn.layer.cornerRadius = 3.f;
        _getVerificationCodeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _getVerificationCodeBtn;
}
- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_confirmBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmEvent:) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.titleLabel.font = FONT_SCALE(15.f);
        _confirmBtn.layer.cornerRadius = 3.f;
        _confirmBtn.layer.borderWidth = .5f;
        _confirmBtn.layer.borderColor = UIColorFromRGB(0xaaddff).CGColor;
        [self setConfirmBtnUsableState:NO];
    }
    return _confirmBtn;
}
- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = AllocNormalLabel(self.messageLabel, @"老鹰彩票不会在任何地方泄露您的手机号码", FONT_SCALE(11), NSTextAlignmentCenter, UIColorFromRGB(0xDCDCDC), __Rect(0, __Obj_YH_Value(self.confirmBtn) + __SCALE(5.f), __Obj_Bounds_Width(self), __SCALE(15.f)));
//        NSLog(@"messagelabel:%f", CGRectGetMaxY(_messageLabel.frame));
        }
    return _messageLabel;
}
//获取验证码
- (NSString *)verificationCode{
    return self.verificationCodeTextFieldView.text;
}
//获取手机号
- (NSString *)phoneNumber{
    return self.phoneNumberTextFieldView.text;
}


@end
