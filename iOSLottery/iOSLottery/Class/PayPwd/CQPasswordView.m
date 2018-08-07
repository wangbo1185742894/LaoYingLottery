//
//  CQPasswordView.m
//  caiqr
//
//  Created by 彩球 on 16/4/6.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQPasswordView.h"
#import "CQPasswordLayer.h"
#import "CLConfigMessage.h"
#import "NSString+Legitimacy.h"

#define CQPasswordLengthLimit 6

@interface CQPasswordView ()<UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray* dotLayerArray;
@property (nonatomic, strong) UITextField* textField;

@end

@implementation CQPasswordView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.canEdit = YES;
        
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
        self.layer.cornerRadius = 5.f;
        
        [self addSubview:self.textField];
        CGFloat width = (self.bounds.size.width / CQPasswordLengthLimit);
        for (int i = 0; i < CQPasswordLengthLimit; i++) {
            CQPasswordLayer* layer = [CQPasswordLayer layer];
            layer.frame = __Rect(i * width, 0, width, __Obj_Bounds_Height(self));
            [self.dotLayerArray addObject:layer];
            [self.layer addSublayer:layer];
            if (i != 0) {
                CALayer* lineLayer = [CALayer layer];
                lineLayer.frame = __Rect(i * width - 1.f, 0, 1.f, __Obj_Bounds_Height(self));
                lineLayer.backgroundColor = UIColorFromRGB(0xeeeeee).CGColor;
                [self.layer addSublayer:lineLayer];
            }
        }
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.isSelectState = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.isSelectState = NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!self.canEdit) {
        return NO;
    }
    
    BOOL ret = ((string.length == 0) || [string isPureNumandCharacters]);
    return ret;
}

- (void)textFieldContentChange:(UITextField*)myTextField
{
    
    BOOL ret = (myTextField.text.length > CQPasswordLengthLimit);
    
    //判断超过最大限制 修改
    NSInteger count = (myTextField.text.length);
    if (ret) {
        count = CQPasswordLengthLimit;
        myTextField.text = [myTextField.text substringToIndex:CQPasswordLengthLimit];
    }
    
    _password = myTextField.text;

    //如果输入完成 执行block
    if (myTextField.text.length == CQPasswordLengthLimit) {
        if (self.inputMixNoFinish) {
            self.inputMixNoFinish(_password);
        }
    }

        [self.dotLayerArray enumerateObjectsUsingBlock:^(CQPasswordLayer* obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        obj.showDot = (idx < count);
        
    }];
    
    if (self.inputContentChange) {
        self.inputContentChange();
    }
    
}

#pragma mark - private

- (void)tapClicked:(id)sender
{
    [self showKeyboard];
}

- (void)showKeyboard
{
    [self.textField becomeFirstResponder];
}


- (void)hideKeyboard
{
    [self.textField resignFirstResponder];
}

- (void)clearInputContent
{
    self.textField.text = @"";
    [self textFieldContentChange:self.textField];
}

#pragma mark - setter

- (void)setIsSelectState:(BOOL)isSelectState
{
    _isSelectState = isSelectState;
    if (_isSelectState) {
//        [self showKeyboard];
         self.layer.borderColor = self.selectedColor.CGColor;
    } else {
//        [self hideKeyboard];
         self.layer.borderColor = UIColorFromRGB(0xBBBBBB).CGColor;
    }
    //设置视图选中状态
}

#pragma mark - getter

- (UIColor *)selectedColor
{
    if (!_selectedColor) {
        return THEME_COLOR;
    }
    return _selectedColor;
}

- (BOOL)isValid
{
    return (_password.length == CQPasswordLengthLimit);
}

- (NSMutableArray *)dotLayerArray
{
    if (!_dotLayerArray) {
        _dotLayerArray = [NSMutableArray new];
    }
    return _dotLayerArray;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:__Rect(0, 0, __Obj_Bounds_Width(self), __Obj_Bounds_Height(self))];
        _textField.hidden = YES;
        [_textField addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventEditingChanged];
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textField;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
