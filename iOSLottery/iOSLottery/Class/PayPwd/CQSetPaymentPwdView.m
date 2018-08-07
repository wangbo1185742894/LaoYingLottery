//
//  CQSetPaymentPwdView.m
//  caiqr
//
//  Created by 彩球 on 16/4/7.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQSetPaymentPwdView.h"
#import "CLConfigMessage.h"
#import "CQPasswordView.h"

//#import "NSString+CQExpandNSString.h"
//#import "CQErrorManager.h"
@interface CQSetPaymentPwdView ()

@property (nonatomic, strong) UILabel* titleLbl;
@property (nonatomic, strong) UIButton* closeBtn;


@property (nonatomic, strong) UILabel* firstTitleLbl;
@property (nonatomic, strong) UILabel* secoundTitleLbl;
@property (nonatomic, strong) CQPasswordView* firstPwdView;
@property (nonatomic, strong) CQPasswordView* secoundPwdView;

@property (nonatomic, strong) UIButton* confirmBtn;

@end

@implementation CQSetPaymentPwdView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        [self addSubview:self.titleLbl];
        [self addSubview:self.closeBtn];
        [self addSubview:self.firstTitleLbl];
        [self addSubview:self.secoundTitleLbl];
        [self addSubview:self.firstPwdView];
        [self addSubview:self.secoundPwdView];
        [self addSubview:self.confirmBtn];
        
        self.frame = __Rect(__Obj_Frame_X(self), __Obj_Frame_Y(self), __Obj_Bounds_Width(self), __Obj_YH_Value(self.confirmBtn) + 20.f);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10.f;
        
        [self observePwdViewChange];

    }
    return self;
}

#pragma mark - keyBoard Nofitication

- (void)addkeyBoardObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)cancelKeyBoardObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    
    if (self.keyBoardObserver) {
        self.keyBoardObserver(YES,height);
    }
}

- (void)keyboardWillHide:(id)sender
{
    if (self.keyBoardObserver) {
        self.keyBoardObserver(NO,0);
    }
}

#pragma mark - private

- (void)startEdit
{
    [self.firstPwdView showKeyboard];
    self.firstPwdView.isSelectState = YES;
}

- (void)hideKeyboard
{
    [self.firstPwdView hideKeyboard];
    [self.secoundPwdView hideKeyboard];
    self.firstPwdView.isSelectState = self.secoundPwdView.isSelectState = NO;
}

- (void)observePwdViewChange
{
    [self setConfirmBtnEnable:(self.firstPwdView.isValid && self.secoundPwdView.isValid)];
}

- (void)firstPwdViewContentValidAction
{
    if (self.firstPwdView.isValid) {
        [self.secoundPwdView showKeyboard];
    }
}

- (void)setConfirmBtnEnable:(BOOL)enable
{
    [self.confirmBtn setBackgroundColor:enable?THEME_COLOR:UIColorFromRGB(0xdcdcdc)];
    self.confirmBtn.enabled = enable;
}

- (void)confirmBtnClicked:(id)sender
{
    if (![self.firstPwdView.password isEqualToString:self.secoundPwdView.password]) {
        //两次输入的密码不一致
        [self.firstPwdView clearInputContent];
        [self.secoundPwdView clearInputContent];
        [self.firstPwdView showKeyboard];
        (!self.exceptionMessage)?:self.exceptionMessage(@"两次密码不一致，请重新输入");
        return;
    }
    
    if (self.confirmEvent) {
        self.confirmEvent(self.firstPwdView.password);
    }
    
}

- (void)closePaymentViewEvent:(id)sender
{
    if (self.closeViewHandler) {
        self.closeViewHandler();
    }
}

#pragma mark - getter


- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        AllocNormalLabel(_titleLbl, @"设置6位支付密码", FONT_SCALE(14.f), NSTextAlignmentCenter, UIColorFromRGB(0x333333), __Rect(0, 10.f, __Obj_Bounds_Width(self), __SCALE(25.f)))
    }
    return _titleLbl;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = __Rect(__Obj_Bounds_Width(self) - 35.f, 5.f, 30, 30);
        [_closeBtn setImage:[UIImage imageNamed:@"pwdPop_delete"] forState:UIControlStateNormal];
//        [_closeBtn setContentEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [_closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closePaymentViewEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)firstTitleLbl
{
    if (!_firstTitleLbl) {
        AllocNormalLabel(_firstTitleLbl, @"设置", FONT_SCALE(14.f), NSTextAlignmentLeft, UIColorFromRGB(0x999999), __Rect(10, __Obj_YH_Value(self.titleLbl) + 10.f, __SCALE(35.f), __SCALE(40.f)))
    }
    return _firstTitleLbl;
}

- (UILabel *)secoundTitleLbl
{
    if (!_secoundTitleLbl) {
        AllocNormalLabel(_secoundTitleLbl, @"确认", FONT_SCALE(14.f), NSTextAlignmentLeft, UIColorFromRGB(0x999999), __Rect(10, __Obj_YH_Value(self.firstTitleLbl) + 25.f, __SCALE(35.f), __SCALE(40.f)))
    }
    return _secoundTitleLbl;
}

- (CQPasswordView *)firstPwdView
{
    if (!_firstPwdView) {
        _firstPwdView = [[CQPasswordView alloc] initWithFrame:__Rect(__Obj_XW_Value(self.firstTitleLbl), __Obj_Frame_Y(self.firstTitleLbl), __Obj_Bounds_Width(self) - __Obj_XW_Value(self.firstTitleLbl) - __Obj_Frame_X(self.firstTitleLbl), __Obj_Bounds_Height(self.firstTitleLbl))];
        WS(_weakSelf)
        _firstPwdView.inputContentChange = ^{
            [_weakSelf firstPwdViewContentValidAction];
            [_weakSelf observePwdViewChange];
        };
    }
    return _firstPwdView;
}

- (CQPasswordView *)secoundPwdView
{
    if (!_secoundPwdView) {
        _secoundPwdView = [[CQPasswordView alloc] initWithFrame:__Rect(__Obj_Frame_X(self.firstPwdView), __Obj_Frame_Y(self.secoundTitleLbl), __Obj_Bounds_Width(self.firstPwdView), __Obj_Bounds_Height(self.firstPwdView))];
        WS(_weakSelf)
        _secoundPwdView.inputContentChange = ^{
            [_weakSelf observePwdViewChange];
        };
    }
    return _secoundPwdView;
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _confirmBtn.frame = __Rect(0, 0, __Obj_Bounds_Width(self) - 20.f, __SCALE(30.f));
        _confirmBtn.center = CGPointMake(__Obj_Bounds_Width(self) / 2.f, __Obj_YH_Value(self.secoundPwdView) + 20.f + (__SCALE(30.f) / 2.f));
        [_confirmBtn setTitle:@"提交" forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = FONT_SCALE(12.f);
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn setBackgroundColor:THEME_COLOR];
        _confirmBtn.layer.cornerRadius = 6.f;
        [_confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

@end



@interface CQUserPaymentPwdView ()

@property (nonatomic, strong) UILabel* titleLbl;
@property (nonatomic, strong) UIButton* closeBtn;


@property (nonatomic, strong) UILabel* messageLbl;

@property (nonatomic, strong) CQPasswordView* passwordView;

@property (nonatomic, strong) UIButton* forgetPwdBtn;


@end

@implementation CQUserPaymentPwdView


- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        [self addSubview:self.titleLbl];
        [self addSubview:self.closeBtn];
        [self addSubview:self.passwordView];
        [self addSubview:self.forgetPwdBtn];
        
        self.frame = __Rect(__Obj_Frame_X(self), __Obj_Frame_Y(self), __Obj_Bounds_Width(self), __Obj_YH_Value(self.forgetPwdBtn) + 10.f);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5.f;
                
    }
    return self;
}


#pragma mark - keyBoard Nofitication

- (void)addkeyBoardObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

- (void)cancelKeyBoardObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    
    if (self.keyBoardObserver) {
        self.keyBoardObserver(YES,height);
    }
}

- (void)keyboardWillHide:(id)sender
{
    if (self.keyBoardObserver) {
        self.keyBoardObserver(NO,0);
    }
}


#pragma mark - private


- (void)forgetBtnEvent:(id)sender
{
    if (self.forgetEvent) {
        self.forgetEvent();
    }
}

- (void)confirmPasswordAction
{
    if (self.confirmEvent) {
        self.confirmEvent(self.passwordView.password);
    }
}

- (void)closePaymentViewEvent:(id)sender
{
    if (self.closeViewHandler) {
        self.closeViewHandler();
    }
}

- (void)hideKeyboard
{
    [self.passwordView hideKeyboard];
}

- (void)clearPassword
{
    [self.passwordView clearInputContent];
}

- (void)startEdit
{
    [self.passwordView showKeyboard];
    self.passwordView.isSelectState = YES;
}

#pragma mark - setter

- (void)setShowForget:(BOOL)showForget
{
    self.forgetPwdBtn.hidden = !showForget;
}

- (void)setErrorMsg:(NSString *)errorMsg
{
//    self.messageLbl.text = errorMsg;
}

- (void)setControlCanInput:(BOOL)controlCanInput
{
    self.passwordView.canEdit = controlCanInput;
}

- (void)startAnimate
{
    
    CAKeyframeAnimation * moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnimation.values = @[[NSValue valueWithCGPoint:CGPointMake(self.passwordView.center.x - 10, self.passwordView.center.y)],[NSValue valueWithCGPoint:CGPointMake(self.passwordView.center.x + 10, self.passwordView.center.y)],[NSValue valueWithCGPoint:CGPointMake(self.passwordView.center.x - 5, self.passwordView.center.y)],[NSValue valueWithCGPoint:CGPointMake(self.passwordView.center.x + 5, self.passwordView.center.y)],[NSValue valueWithCGPoint:CGPointMake(self.passwordView.center.x, self.passwordView.center.y)]];
    
    moveAnimation.removedOnCompletion = YES;
    moveAnimation.duration = .4f;
    
    [self.passwordView.layer addAnimation:moveAnimation forKey:@"animateKey"];
    
}


#pragma mark - getter
- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        AllocNormalLabel(_titleLbl, @"输入支付密码", FONT_SCALE(14.f), NSTextAlignmentCenter, UIColorFromRGB(0x333333), __Rect(0, 10.f, __Obj_Bounds_Width(self), __SCALE(21.f)))
    }
    return _titleLbl;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = __Rect(__Obj_Bounds_Width(self) - 35.f, 5.f, 30, 30);
        [_closeBtn setImage:[UIImage imageNamed:@"pwdPop_delete"] forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closePaymentViewEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)messageLbl
{
    if (!_messageLbl) {
        AllocNormalLabel(_messageLbl, @"", FONT_SCALE(11.f), NSTextAlignmentCenter, UIColorFromRGB(0xd80000), __Rect(0, __Obj_YH_Value(self.titleLbl), __Obj_Bounds_Width(self), __SCALE(17.f)))
    }
    return _messageLbl;
}

- (CQPasswordView *)passwordView
{
    if (!_passwordView) {
        _passwordView = [[CQPasswordView alloc] initWithFrame:__Rect(10.f, __Obj_YH_Value(self.titleLbl) + 10.f, __Obj_Bounds_Width(self) - 20.f, __SCALE(40.f))];
        _passwordView.selectedColor = UIColorFromRGB(0xbbbbbb);
        WS(_weakSelf)
        _passwordView.inputMixNoFinish = ^(NSString* string){
            [_weakSelf confirmPasswordAction];
        };
    }
    return _passwordView;
}

- (UIButton *)forgetPwdBtn
{
    if (!_forgetPwdBtn) {
        _forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _forgetPwdBtn.frame = __Rect(__Obj_Bounds_Width(self) - 10.f - 80.f, __Obj_YH_Value(self.passwordView), 80.f, __SCALE(35.f));
        NSString *forgetePwdString = [NSString stringWithFormat:@"%@",@"忘记密码"];
        [_forgetPwdBtn setTitle:forgetePwdString forState:UIControlStateNormal];
        _forgetPwdBtn.titleLabel.font = FONT_SCALE(12.f);
        [_forgetPwdBtn setTitleColor:LINK_COLOR forState:UIControlStateNormal];
        [_forgetPwdBtn addTarget:self action:@selector(forgetBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPwdBtn;
}


@end


