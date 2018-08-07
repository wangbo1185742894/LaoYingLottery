//
//  CQInputTextFieldView.m
//  caiqr
//
//  Created by 彩球 on 16/3/24.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQInputTextFieldView.h"
#import "Masonry.h"
#import "NSString+Legitimacy.h"
#import "CLConfigMessage.h"
@interface CQInputTextFieldView ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel* titleLbl;

@property (nonatomic, strong) UITextField* textField;

@property (nonatomic, strong) UIView* underLineLayer;

@property (nonatomic, strong) UIButton* lookPasswordBtn;

@end

@implementation CQInputTextFieldView


- (instancetype)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if (self) {
        self.limitLength = 0;
        _inputExistText = NO;
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.textField];
        [self addSubview:self.underLineLayer];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(__SCALE(10.f));
            make.right.equalTo(self).offset(__SCALE(-10.f));
        }];
        
        [self.underLineLayer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_offset(.5f);
            
        }];
    }
    return self;
}

#pragma mark - private

- (void)becomeFirstResponder
{
    [self.textField becomeFirstResponder];
}

- (void)resignFirstResponder
{
    [self.textField resignFirstResponder];
}

- (void)contentChange:(id)sender
{
    if (self.textField.text.length > _text.length) {
        NSString *diffStr = [self.textField.text substringFromIndex:_text.length];
        if (![self inputLimitWithString:diffStr]) {
            
            self.textField.text = _text;
            return;
        }
        if (self.limitLength > 0 &&
            self.textField.text.length > self.limitLength) {
            self.textField.text = _text;
            return;
        }

    }
    _text = self.textField.text;
    
    _inputExistText = (_text.length > 0);
    if (self.textContentChange) {
        self.textContentChange();
    }
    
    BOOL ret = YES;
    if (self.checkImputTextValid) {
        ret = self.checkImputTextValid(_text);
    }
    
    self.underLineLayer.backgroundColor = (ret)?THEME_COLOR : UIColorFromRGB(0xe5e5e5);
    
}

- (void)lookPasswordOnClick:(UIButton *)btn{
    
    self.textField.secureTextEntry = !self.textField.secureTextEntry;
    self.textField.font = [UIFont systemFontOfSize:13];
    if (self.textField.secureTextEntry) {
        [self.lookPasswordBtn setImage:[UIImage imageNamed:@"unLook.png"] forState:UIControlStateNormal];
    }else{
        [self.lookPasswordBtn setImage:[UIImage imageNamed:@"look.png"] forState:UIControlStateNormal];
    }
    
}

#pragma mark - setter

- (void)setTextColor:(UIColor *)textColor {
    
    self.textField.textColor = textColor;
}

- (void)setTextPlaceholder:(NSString *)textPlaceholder
{
    self.textField.placeholder = textPlaceholder;
}

- (void)setKeyBoardType:(UIKeyboardType)keyBoardType
{
    self.textField.keyboardType = keyBoardType;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry
{
    _secureTextEntry = secureTextEntry;
    self.textField.secureTextEntry = secureTextEntry;
}

- (void)setInputTextType:(CQInputTextType)inputTextType
{
    if (inputTextTypeNormal == inputTextType) {
        self.underLineLayer.hidden = YES;
        self.textField.layer.borderWidth = 0.f;
        self.textField.layer.cornerRadius = 0.f;
    }
    else if (inputTextTypeRect == inputTextType) {
        self.underLineLayer.hidden = YES;
        self.textField.layer.borderWidth = 0.5f;
        self.textField.layer.cornerRadius = 0.f;
    }
    else if (inputTextTypeUnderline == inputTextType)
    {
        self.underLineLayer.hidden = NO;
        self.textField.layer.borderWidth = 0.f;
        self.textField.layer.cornerRadius = 4.f;
    }
}

- (void)setInputEnable:(BOOL)inputEnable
{
    self.textField.enabled = inputEnable;
}

- (void)setDefautlText:(NSString *)defautlText
{
    _defautlText = defautlText;
    self.textField.text = _defautlText;
    _text = _defautlText;
    _inputExistText = YES;
    [self contentChange:self.textField];
}


- (void)setCanShowSecureTxt:(BOOL)canShowSecureTxt {
    
    if (!_secureTextEntry) return;
    
    if (canShowSecureTxt) {
        self.textField.rightView = self.lookPasswordBtn;
    } else {
        self.textField.rightView = nil;
    }
    
}

- (void)setLeftView:(UIView *)leftView {
    
    self.textField.leftView = leftView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setRightView:(UIView *)rightView {
    
    self.textField.rightView = rightView;
}

- (void)setLeftViewEdgeType:(CLLeftViewEdgeType)leftViewEdgeType{
    
    if (leftViewEdgeType == CLLeftViewEdgeTypeNormal) {
        
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(__SCALE(10.f));
            make.right.equalTo(self).offset(__SCALE(-10.f));
        }];
    }else if (leftViewEdgeType == CLLeftViewEdgeTypeEdge){
        
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(__SCALE(0.f));
            make.right.equalTo(self).offset(__SCALE(-0.f));
        }];
    }
}

#pragma mark - delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.keyboardReturnAction) {
        self.keyboardReturnAction();
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (![self inputLimitWithString:string]) {
        return NO;
    }
    if (self.limitLength > 0 &&
        textField.text.length >= self.limitLength &&
        ![string isEqualToString:@""]) {
        return NO;
    }
    if (self.shouldChangeCharacters) {
        return self.shouldChangeCharacters(textField,range,string);
    } else {
        return YES;
    }
}

- (BOOL)inputLimitWithString:(NSString *)string{
    
    switch (self.limitType) {
        case CQInputLimitTypeNormal:
            return YES;
            break;
        case CQInputLimitTypeNumber:{
          
            return ([string checkStringIsOnlyHasNumber] || [string isEqualToString:@""]);
        }
            break;
        case CQInputLimitTypeNumberAndEnglish:{
            
            return ([string checkStringIsOnlyHasNumberAndEnglish] || [string isEqualToString:@""]);
        }
            break;
        default:
            break;
    }
    return YES;
}

#pragma mark - getter

- (BOOL)inputValidState
{
    if (self.checkImputTextValid) {
        return self.checkImputTextValid(self.textField.text);
    }
    return NO;
}

- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        _titleLbl = ({
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 5.f, 50.f * [UIScreen mainScreen].scale, self.bounds.size.height - 10.f)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.f];
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
    }
    return _titleLbl;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = ({
            UITextField* textF = [[UITextField alloc] initWithFrame:CGRectZero];
            textF.rightViewMode = UITextFieldViewModeAlways;
            textF.leftViewMode = UITextFieldViewModeAlways;
            textF.font = [UIFont systemFontOfSize:13];
            textF.delegate = self;
            textF.textColor = [UIColor colorWithRed:88.f/255.f green:88.f/255.f blue:88.f/255.f alpha:1.f];
            textF.layer.borderColor = [UIColor colorWithRed:220.f/255.f green:220.f/255.f blue:220.f/255.f alpha:1.f].CGColor;
            textF.layer.borderWidth = 0.5f;
            textF.layer.cornerRadius = 4.f;
            textF.clearButtonMode = UITextFieldViewModeWhileEditing;
            [textF addTarget:self action:@selector(contentChange:) forControlEvents:UIControlEventEditingChanged];
            textF;
        });
    }
    return _textField;
}


- (UIView *)underLineLayer
{
    if (!_underLineLayer) {
        _underLineLayer = ({
            UIView* layer = [[UIView alloc] initWithFrame:CGRectZero];
            layer.backgroundColor = [UIColor colorWithRed:239.f/255.f green:239.f/255.f blue:239.f/255.f alpha:1.f];
            layer.hidden = YES;
            layer;
        });
    }
    return _underLineLayer;
}

- (UIButton *)lookPasswordBtn{
    if (!_lookPasswordBtn) {
        _lookPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookPasswordBtn.frame = CGRectMake(0, 0, 18.f * [UIScreen mainScreen].scale, 18.f * [UIScreen mainScreen].scale);
        _lookPasswordBtn.center = CGPointMake((18.f * [UIScreen mainScreen].scale) / 2, (21.f * [UIScreen mainScreen].scale) / 2);
        [_lookPasswordBtn setImage:[UIImage imageNamed:@"unLook.png"] forState:UIControlStateNormal];
        [_lookPasswordBtn addTarget:self action:@selector(lookPasswordOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_lookPasswordBtn setAdjustsImageWhenHighlighted:NO];//取消按钮自动高亮效果
    }
    return _lookPasswordBtn;
}

@end
