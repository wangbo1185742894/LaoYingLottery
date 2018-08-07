//
//  CLRedEnveExchangeViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/29.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLRedEnveExchangeViewController.h"
#import "CLConfigMessage.h"
#import "CLRedEnveExchangeAPI.h"


#define CQRedPacketsConversionMargin 74.f
#define CQRedPacketsConversionNumber 10
NSString * const redPacketsConversionDescString = @"兑换码一般通过活动发放，没有固定的获取方式，如果您获得了兑换码，请在下方输入框内输入兑换码兑换。\n兑换成功后，使用规则见具体兑换的红包说明。！";
NSString * const redPacketsConversionHintString = @"请输入10位兑换码（不区分大小写）";
@interface CLRedEnveExchangeViewController () <UITextFieldDelegate,CLRequestCallBackDelegate >
{
    CGFloat _textfieldY;
}
@property (nonatomic, copy) void(^redConversionBlock)(id method);
@property (nonatomic, strong) UILabel *conversionDescLabel;
@property (nonatomic, strong) UILabel *conversionHintLabel;
@property (nonatomic, strong) UITextField *conversionTextField;
@property (nonatomic, strong) UIButton *conversionButton;

@property (nonatomic, strong) CLRedEnveExchangeAPI* exchangeAPI;

@end

@implementation CLRedEnveExchangeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"红包兑换";
    _textfieldY = 150.f;
    self.view.backgroundColor = UIColorFromRGB(0xefefef);
    [self.view addSubview:self.conversionDescLabel];
    [self.view addSubview:self.conversionHintLabel];
    [self.view addSubview:self.conversionTextField];
    [self.view addSubview:self.conversionButton];
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    
    if (request.urlResponse.success) {
        [self show:@"兑换成功"];
        WS(_ws)
        DELAY(1.f, ^{
            [_ws.navigationController popViewControllerAnimated:YES];
        });
    } else {
        [self show:request.urlResponse.errorMessage];
    }
    
    self.conversionButton.enabled = YES;
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
    self.conversionButton.enabled = YES;
}

//** 兑换红包按钮触发 */
- (void)setRedConversionAction
{
    if (self.conversionTextField.isFirstResponder) {
        [self.conversionTextField resignFirstResponder];
    }
    
    
    self.exchangeAPI.redeem_code = self.conversionTextField.text;
    
    self.conversionButton.enabled = NO;
    [self.exchangeAPI start];
}

#pragma mark - textfiedNotification

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary* datainfo = [aNotification userInfo];
    CGSize kbSize = [[datainfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    [UIView animateWithDuration:0.3f animations:^{
        self.conversionTextField.frame = __Rect(__Obj_Frame_X(self.conversionTextField), __Obj_Frame_Y(self.conversionTextField) - kbSize.height, __Obj_Bounds_Width(self.conversionTextField), __Obj_Bounds_Height(self.conversionTextField));
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    if (__Obj_Frame_Y(self.conversionTextField) == _textfieldY) {
        return;
    }
    
    [UIView animateWithDuration:0.4f animations:^{
        self.conversionTextField.frame = __Rect(__Obj_Frame_X(self.conversionTextField), _textfieldY, __Obj_Bounds_Width(self.conversionTextField), __Obj_Bounds_Height(self.conversionTextField));
    }];
}

#pragma mark - textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)conversionTextFieldChangeText:(UITextField *)textField
{
    if (textField.markedTextRange == nil)
    {
        if (textField.text.length >= CQRedPacketsConversionNumber)
        {
            self.conversionButton.enabled = YES;
            textField.text = [textField.text substringToIndex:CQRedPacketsConversionNumber];
            [self.conversionButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [self.conversionButton setBackgroundColor:LINK_COLOR];
        }
        else
        {
            self.conversionButton.enabled = NO;
            [self.conversionButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [self.conversionButton setBackgroundColor:UNABLE_COLOR];
        }
    }
}

#pragma mark - touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.conversionTextField.isFirstResponder)
    {
        [self.conversionTextField resignFirstResponder];
    }
}

#pragma mark - gettinMethod

- (UILabel *)conversionDescLabel
{
    if (!_conversionDescLabel) {
        AllocNormalLabel(_conversionDescLabel, redPacketsConversionDescString, FONT(12), NSTextAlignmentLeft, UIColorFromRGB(0x999999), __Rect(CQRedPacketsConversionMargin, CQRedPacketsConversionMargin, SCREEN_WIDTH - 2 * CQRedPacketsConversionMargin, 55.f));
        _conversionDescLabel.numberOfLines = 0;
    }
    return _conversionDescLabel;
}

- (UILabel *)conversionHintLabel
{
    if (!_conversionHintLabel) {
        AllocNormalLabel(_conversionHintLabel, redPacketsConversionHintString, FONT(13), NSTextAlignmentCenter, UIColorFromRGB(0x666666), __Rect(__Obj_Frame_X(self.conversionDescLabel), __Obj_YH_Value(self.conversionDescLabel) + 5.f, __Obj_Bounds_Width(self.conversionDescLabel), 36.f));
    }
    return _conversionHintLabel;
}

- (UITextField *)conversionTextField
{
    if (!_conversionTextField) {
        _conversionTextField = [[UITextField alloc] init];
        _conversionTextField.frame = __Rect(__Obj_Frame_X(self.conversionHintLabel), __Obj_YH_Value(self.conversionHintLabel), __Obj_Bounds_Width(self.conversionHintLabel), 40.f);
        _conversionTextField.layer.borderWidth = 1.f;
        _conversionTextField.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
        _conversionTextField.backgroundColor = UIColorFromRGB(0xffffff);
        _conversionTextField.layer.masksToBounds = YES;
        _conversionTextField.layer.cornerRadius = 5.f;
        _conversionTextField.placeholder = @"兑换码";
        _conversionTextField.font = FONT(12);
        _conversionTextField.textColor = UIColorFromRGB(0xbbbbbb);
        _conversionTextField.leftView = [[UIView alloc] initWithFrame:__Rect(0, 0, 10.f, 10.f)];
        _conversionTextField.leftViewMode = UITextFieldViewModeAlways;
        _conversionTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _conversionTextField.delegate = self;
        [_conversionTextField addTarget:self action:@selector(conversionTextFieldChangeText:) forControlEvents:UIControlEventEditingChanged];
    }
    return _conversionTextField;
}

- (UIButton *)conversionButton
{
    if (!_conversionButton) {
        _conversionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _conversionButton.frame = __Rect(20.f, __Obj_YH_Value(self.conversionTextField) + 30.f, SCREEN_WIDTH - 40.f, __SCALE(35.f));
        [_conversionButton setTitle:@"立即兑换" forState:UIControlStateNormal];
        _conversionButton.titleLabel.font = FONT(15);
        [_conversionButton setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [_conversionButton setBackgroundColor:UNABLE_COLOR];
        _conversionButton.layer.masksToBounds = YES;
        _conversionButton.layer.cornerRadius = 4.f;
        [_conversionButton addTarget:self action:@selector(setRedConversionAction) forControlEvents:UIControlEventTouchUpInside];
        _conversionButton.enabled = NO;
    }
    return _conversionButton;
}

- (CLRedEnveExchangeAPI *)exchangeAPI {
    
    if (!_exchangeAPI) {
        _exchangeAPI = [[CLRedEnveExchangeAPI alloc] init];
        _exchangeAPI.delegate = self;
    }
    return _exchangeAPI;
}

- (void)dealloc {
    
    if (_exchangeAPI) {
        _exchangeAPI.delegate = nil;
        [_exchangeAPI cancel];
    }
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
