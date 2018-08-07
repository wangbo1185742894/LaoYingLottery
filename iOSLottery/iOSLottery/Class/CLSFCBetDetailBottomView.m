//
//  CLSFCBetDetailBottomView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/27.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSFCBetDetailBottomView.h"

#import "CLConfigMessage.h"

#import "CLSFCManager.h"

#import "UITextField+InputLimit.h"

#import "UILabel+CLAttributeLabel.h"

#import "CLShowHUDManager.h"


@interface CLSFCBetDetailBottomView ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *betLabel;//投
@property (nonatomic, strong) UITextField *multipleTextField;//倍数textField
@property (nonatomic, strong) UILabel *mulLabel;//倍label
@property (nonatomic, strong) UIView *bottomLineView;//串关底部横线

@property (nonatomic, strong) UILabel *moneyLabel;//钱数
@property (nonatomic, strong) UILabel *noteMultipleLabel;//注数 倍数

/**
 付款button
 */
@property (nonatomic, strong) UIButton *payButton;


@end

@implementation CLSFCBetDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorFromRGB(0xffffff);
        
        [self p_addSubviews];
        [self p_addConstraints];
        
        self.multipleTextField.text = [NSString stringWithFormat:@"%zi", [[CLSFCManager shareManager] getDefaultMultiple]];
        
        [self reloadAwardAndNote];
    }
    return self;
}

- (void)p_addSubviews
{
    [self addSubview:self.betLabel];
    [self addSubview:self.multipleTextField];
    [self addSubview:self.mulLabel];
    [self addSubview:self.bottomLineView];
    
    [self addSubview:self.moneyLabel];
    [self addSubview:self.noteMultipleLabel];
    
    [self addSubview:self.payButton];

}

- (void)p_addConstraints
{
    [self.betLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.multipleTextField.mas_left).offset(CL__SCALE(-10.f));
        make.centerY.equalTo(self.multipleTextField);
    }];
    [self.multipleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self).offset(CL__SCALE(7.f));
        make.width.mas_equalTo(CL__SCALE(88.f));
        make.height.mas_offset(CL__SCALE(35.f));
        make.bottom.equalTo(self.bottomLineView.mas_top).offset(CL__SCALE(-5.f));
    }];
    [self.mulLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.multipleTextField.mas_right).offset(CL__SCALE(5.f));
        make.centerY.equalTo(self.multipleTextField);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.payButton.mas_top).offset(CL__SCALE(-8.f));
        make.height.mas_equalTo(0.5f);
        make.left.right.equalTo(self);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.noteMultipleLabel.mas_top).offset(CL__SCALE(-4.f));
    }];
    
    [self.noteMultipleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(self).offset(CL__SCALE(-6.f));
        make.centerX.equalTo(self);
    }];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.mas_bottom).offset(CL__SCALE(-7.f));
        make.right.equalTo(self).offset(CL__SCALE(- 10.f));
        make.height.mas_equalTo(CL__SCALE(35.f));
        make.width.mas_equalTo(CL__SCALE(70.f));
        
    }];
    
}

- (void)hiddenKeyBoard{
    
    
    [self.multipleTextField resignFirstResponder];
}

- (void)reloadBetDetailBottonViewUI{
    
    
    self.multipleTextField.text = [NSString stringWithFormat:@"%zi", [[CLSFCManager shareManager] getDefaultMultiple]];
    [self reloadAwardAndNote];
    
}

#pragma mark ---- 刷新底部UI -----
- (void)reloadAwardAndNote
{
    
    if ([[CLSFCManager shareManager] getNoteNumber] > 0) {
        //如果注数大于0
        
        self.moneyLabel.text = [NSString stringWithFormat:@"共%ld元",[[CLSFCManager shareManager] getNoteNumber] * 2 * [[CLSFCManager shareManager] getBetTimes]];
        
        self.noteMultipleLabel.text = [NSString stringWithFormat:@"%ld注,%ld倍",[[CLSFCManager shareManager] getNoteNumber],[[CLSFCManager shareManager] getBetTimes]];
        
    }else{
        
        self.moneyLabel.text = @"共0元";
        self.noteMultipleLabel.text = [NSString stringWithFormat:@"%ld注,%ld倍",[[CLSFCManager shareManager] getNoteNumber],[self.multipleTextField.text integerValue]];
    }
    
    if (([[CLSFCManager shareManager] getDefaultMultiple] * [[CLSFCManager shareManager] getNoteNumber]) > 0) {
        self.payButton.userInteractionEnabled = YES;
        self.payButton.backgroundColor = UIColorFromRGB(0xe63222);
    }else{
        self.payButton.userInteractionEnabled = NO;
        self.payButton.backgroundColor = UIColorFromRGBandAlpha(0xe63222, 0.5);
    }
    
    
}


#pragma mark ------------ event Response ------------
- (void)payButtonOnClick:(UIButton *)btn{
    
    //点击了支付按钮
    if ([[CLSFCManager shareManager] getToastText].length > 1) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[[CLSFCManager shareManager] getToastText] preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        
        [alert addAction:action];
        
        return;
    }
    
    !self.payBlock ? : self.payBlock();
}

#pragma mark ------------ textfield delegate ------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([textField.text isEqualToString:@""] || [textField.text integerValue] == 0) {
        textField.text = @"1";
        //[self sendTextfieldChangeNotification];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSInteger max = [[CLSFCManager shareManager] getMaxBetTimes];
    
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (toBeString.length == 1 && [toBeString isEqualToString:@"0"]) {
        
            
            [CLShowHUDManager showInWindowWithText:[NSString stringWithFormat:@"最小1倍"] type:CLShowHUDTypeOnlyText delayTime:.5f];
        
    }
    if ([toBeString longLongValue] > max) { //如果输入框内容大于5则弹出警告
    
        [CLShowHUDManager showInWindowWithText:[NSString stringWithFormat:@"最多%zi倍", max] type:CLShowHUDTypeOnlyText delayTime:.5f];
        
    }
    

    BOOL res = [textField limitNumberWithMaxNumber:max ShouldChangeCharactersInRange:range replacementString:string];

    if (res) {
        
        [[CLSFCManager shareManager] setBetTimes:[[textField.text stringByReplacingCharactersInRange:range withString:string] integerValue]];
    }else{
    
        [[CLSFCManager shareManager] setBetTimes:[textField.text integerValue]];
    }
    
    
    [self reloadAwardAndNote];
    return res;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField performSelector:@selector(selectAll:) withObject:textField afterDelay:0.1f];
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (!(textField.text && textField.text.length > 0)) {
        
        textField.text = @"1";
        [[CLSFCManager shareManager] setBetTimes:[textField.text integerValue]];
        [self reloadAwardAndNote];
    }
}

#pragma mark ---- 提示选择投注方式 ----
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];
    
    BOOL isContain = CGRectContainsPoint(self.payButton.frame, touchPoint);
    
    if (isContain == NO) return;
    
    if (self.payButton.userInteractionEnabled == YES) return;
    
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"" message:[[CLSFCManager shareManager] getToastText] delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
    
    [alert1 show];
}


#pragma mark ------------ getter Mothed ------------


- (UILabel *)betLabel{
    
    if (!_betLabel) {
        _betLabel = [[UILabel alloc] init];
        _betLabel.text = @"投";
        _betLabel.textColor = UIColorFromRGB(0x333333);
        _betLabel.font = FONT_SCALE(14.f);
    }
    return _betLabel;
}

- (UITextField *)multipleTextField{
    
    if (!_multipleTextField) {
        
        _multipleTextField = [[UITextField alloc] init];
        _multipleTextField.text = @"1";
        _multipleTextField.layer.borderColor = UIColorFromRGB(0x8f6e51).CGColor;
        _multipleTextField.layer.borderWidth = 0.5f;
        _multipleTextField.font = FONT_SCALE(14.f);
        _multipleTextField.layer.cornerRadius = 3.f;
        _multipleTextField.clipsToBounds = YES;
        _multipleTextField.textAlignment = NSTextAlignmentCenter;
        _multipleTextField.delegate = self;
        _multipleTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _multipleTextField;
}

- (UILabel *)mulLabel {
    
    if (!_mulLabel) {
        _mulLabel = [[UILabel alloc] init];
        _mulLabel.text = @"倍";
        _mulLabel.textColor = UIColorFromRGB(0x333333);
        _mulLabel.font = FONT_SCALE(14.f);
    }
    return _mulLabel;
}

- (UIView *)bottomLineView{
    
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = UIColorFromRGB(0xece5dd);
    }
    return _bottomLineView;
}

- (UILabel *)moneyLabel
{

    if (_moneyLabel == nil) {
        
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = @"20注 10倍 共40元";
        _moneyLabel.font = FONT_SCALE(16.f);
        _moneyLabel.textColor = UIColorFromRGB(0xE63222);
    }
    return _moneyLabel;
}

- (UILabel *)noteMultipleLabel{
    
    if (!_noteMultipleLabel) {
        _noteMultipleLabel = [[UILabel alloc] init];
        _noteMultipleLabel.text = @"0注，1倍";
        _noteMultipleLabel.font = FONT_SCALE(12.f);
        _noteMultipleLabel.textColor = UIColorFromRGB(0x333333);
    }
    return _noteMultipleLabel;
}


- (UIButton *)payButton{
    
    if (!_payButton ) {
        _payButton = [[UIButton alloc] init];
        [_payButton setTitle:@"付款" forState:UIControlStateNormal];
        _payButton.titleLabel.font = FONT_SCALE(16.f);
        [_payButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _payButton.backgroundColor = UIColorFromRGB(0xe63222);
        _payButton.layer.cornerRadius = 4.f;
        [_payButton addTarget:self action:@selector(payButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
    
}
@end

