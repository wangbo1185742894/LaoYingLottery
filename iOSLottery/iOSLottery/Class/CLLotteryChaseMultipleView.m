//
//  CLLotteryChaseMultipleView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/21.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLotteryChaseMultipleView.h"
#import "CLConfigMessage.h"
#import "UITextField+InputLimit.h"
#import "CLShowHUDManager.h"
#import "CLLotteryMaxPeriodRequest.h"
#import "CLLotteryMaxPeriodModel.h"
#import "CLAlertPromptMessageView.h"
#import "CLAllAlertInfo.h"
@interface CLLotteryChaseMultipleView ()<UITextFieldDelegate, CLRequestCallBackDelegate>

//一天最大期次
@property (nonatomic, assign) NSInteger todayPeriods;
@property (nonatomic, assign) NSInteger maxPeriod;//最大期次
@property (nonatomic, assign) NSInteger maxMutiple;//最大倍数
@property (nonatomic, strong) CLLotteryMaxPeriodRequest *maxPeriodRequest;//最大期次
@property (nonatomic, strong) CLAlertPromptMessageView *alertPromptMsgView;//中奖后停止追号提示
@property (nonatomic, strong) UIView *additionalBaseView;//追加基层View
@property (nonatomic, strong) UIButton *additionalImageButton;
@property (nonatomic, strong) UIButton *additionalButton;

@property (nonatomic, strong) UIView *additionalTopLineView;

@end
@implementation CLLotteryChaseMultipleView
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorFromRGBandAlpha(0x000000, 0.3);
        self.maxPeriod = 9999;
        self.todayPeriods = 78;
        [self addSubview:self.topLineImageView];
        [self addSubview:self.periodTextField];
        [self addSubview:self.multipleTextField];
        [self addSubview:self.periodLabel];
        [self addSubview:self.buyLabel];
        [self addSubview:self.betLabel];
        [self addSubview:self.multipleLabel];
        [self addSubview:self.lineImageView];
        [self addSubview:self.awardBaseView];
        [self.awardBaseView addSubview:self.awardTopLineView];
        [self.awardBaseView addSubview:self.arrowImageView];
        [self.awardBaseView addSubview:self.agreeImageButton];
        [self.awardBaseView addSubview:self.awardButton];
        [self.awardBaseView addSubview:self.questionButton];
        [self addSubview:self.bottomLineView];
        [self addSubview:self.chaseTenButton];
        [self addSubview:self.chaseTwentyButton];
        [self addSubview:self.chaseMoreButton];
        [self addSubview:self.chaseLeftLineView];
        [self addSubview:self.chaseRightLineView];
        [self configConstraint];
        [self addKeyBoardNotification];
    }
    return self;
}
#pragma mark ------ public Mothed ------
- (void)lotteryChaseMultipleViewResignResponse{
    
    [self.periodTextField resignFirstResponder];
    [self.multipleTextField resignFirstResponder];
}
#pragma mark ------ private Mothed ------
- (void)addKeyBoardNotification{
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
#pragma mark - 发送textfield内容改变的通知
- (void)sendTextfieldChangeNotification{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil userInfo:nil];
}
#pragma mark ------ event Response ------
#pragma mark - 键盘出现
- (void)keyboardWillShow:(NSNotification *)noti{
    
    
}
#pragma mark - 键盘消失
- (void)keyboardWillHide:(NSNotification *)noti{
    
    //结束编辑 隐藏所有
    [self hiddenAllSubView];
}
#pragma mark ------ delegate ------
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([textField.text isEqualToString:@""] || [textField.text integerValue] == 1) {
        textField.text = @"";
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //请求最大期次
    [self.maxPeriodRequest start];
    //配置快速追号 和 快速追期 文案
    [self changeChaseButtonTitleIsPeriod:[textField isEqual:self.periodTextField]];
    //开始编辑展示追号按钮
    [self showButtonSubViews];
    //配置中奖后是否停止追期
    [self configStopChaseWhenAeard:[textField isEqual:self.periodTextField]];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([textField.text isEqualToString:@""] || [textField.text integerValue] == 0) {
        textField.text = @"1";
        [self sendTextfieldChangeNotification];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger max = (textField == self.periodTextField) ? self.maxPeriod : self.maxMutiple;
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (toBeString.length == 1 && [toBeString isEqualToString:@"0"]) {
        
        if (textField == self.periodTextField) {
            
            [CLShowHUDManager showInWindowWithText:[NSString stringWithFormat:@"最少1期"] type:CLShowHUDTypeOnlyText delayTime:.5f];
            
        }else{
            
            [CLShowHUDManager showInWindowWithText:[NSString stringWithFormat:@"最小1倍"] type:CLShowHUDTypeOnlyText delayTime:.5f];
        }
    }
    if ([toBeString longLongValue] > max) { //如果输入框内容大于5则弹出警告
        
        if (textField == self.periodTextField) {
            
            [CLShowHUDManager showInWindowWithText:[NSString stringWithFormat:@"最多%zi期", max] type:CLShowHUDTypeOnlyText delayTime:.5f];
            
        }else{
        
            [CLShowHUDManager showInWindowWithText:[NSString stringWithFormat:@"最多%zi倍", max] type:CLShowHUDTypeOnlyText delayTime:.5f];
        }
    }
    
    BOOL res = [textField limitNumberWithMaxNumber:max ShouldChangeCharactersInRange:range replacementString:string];
    return res;
}
#pragma mark ------------ request delegate ------------
- (void)requestFinished:(CLBaseRequest *)request{
    
    if (request.urlResponse.success && request.urlResponse.resp) {
        
        CLLotteryMaxPeriodModel *model = [CLLotteryMaxPeriodModel mj_objectWithKeyValues:request.urlResponse.resp];
        self.maxPeriod = model.periodVos.count;
        if (model.maxBetTimes > 0) {
            self.maxMutiple = model.maxBetTimes;
        }
        if (model.todayPeriods) {
            self.todayPeriods = model.todayPeriods;
            if ([self.periodTextField isFirstResponder]) {
                [self.chaseMoreButton setTitle:[NSString stringWithFormat:@"追%zi期(一天)", self.todayPeriods] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)requestFailed:(CLBaseRequest *)request{
    
    
}
#pragma mark ------ private Mothed ------
- (void)configConstraint{
    
    [self.topLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(.5f);
    }];
    
    [self.buyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(10.f));
        make.centerY.equalTo(self.periodTextField);
    }];
    [self.periodTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.buyLabel.mas_right).offset(__SCALE(5));
        make.top.equalTo(self.topLineImageView.mas_bottom).offset(__SCALE(5.f));
        make.height.mas_equalTo(__SCALE(25.f));
        make.width.mas_equalTo(__SCALE(75.f));
    }];
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.periodTextField.mas_right).offset(__SCALE(6.f));
        make.right.equalTo(self.mas_centerX).offset(__SCALE(-8.f));
        make.centerY.equalTo(self.periodTextField);
    }];
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.topLineImageView).offset(__SCALE(5.f));
        make.bottom.equalTo(self.awardBaseView.mas_top).offset(__SCALE(- 5.f));
        make.width.mas_equalTo(1.f);
        make.height.mas_equalTo(__SCALE(25.f));
    }];
    [self.multipleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).multipliedBy(1.5);
        make.centerY.equalTo(self.periodTextField);
        make.height.width.equalTo(self.periodTextField);
    }];
    [self.betLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.multipleTextField.mas_left).offset(__SCALE(- 10.f));
        make.centerY.equalTo(self.periodTextField);
    }];
    [self.multipleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.multipleTextField.mas_right).offset(__SCALE(10.f));
        make.centerY.equalTo(self.periodTextField);
    }];
    [self.awardTopLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.awardBaseView.mas_top);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(0.5f);
    }];
    [self.awardBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.periodTextField.mas_bottom).offset(__SCALE(5.f));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(0);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.awardBaseView);
        make.centerX.equalTo(self.awardBaseView);
    }];
    [self.agreeImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.awardBaseView).offset(__SCALE(10.f));
        make.centerY.equalTo(self.awardBaseView);
    }];
    [self.awardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.agreeImageButton.mas_right).offset(__SCALE(3.f));
        make.top.equalTo(self.awardBaseView);
        make.bottom.equalTo(self.awardBaseView);
    }];
    [self.questionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.awardButton.mas_right).offset(__SCALE(3.f));
        make.centerY.equalTo(self.awardButton);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.chaseTenButton);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(.5f);
    }];
    
    [self.chaseTenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.awardBaseView.mas_bottom);
        make.height.mas_equalTo(__SCALE(0));
    }];
    [self.chaseTwentyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chaseTenButton.mas_right);
        make.width.equalTo(self.chaseTenButton);
        make.top.bottom.equalTo(self.chaseTenButton);
    }];
    [self.chaseMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chaseTwentyButton.mas_right);
        make.width.equalTo(self.chaseTenButton);
        make.top.bottom.equalTo(self.chaseTenButton);
        make.right.bottom.equalTo(self);
    }];
    [self.chaseLeftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.chaseTenButton.mas_right);
        make.top.bottom.equalTo(self.chaseTenButton);
        make.width.mas_equalTo(0.5f);
    }];
    [self.chaseRightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.chaseTwentyButton.mas_right);
        make.top.bottom.equalTo(self.chaseTwentyButton);
        make.width.mas_equalTo(0.5f);
    }];
}
#pragma mark - 展示快速追号按钮
- (void)showButtonSubViews{
    
    [self.chaseTenButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.awardBaseView.mas_bottom);
        make.height.mas_equalTo(__SCALE(35.f));
    }];
    [UIView animateWithDuration:.1f animations:^{
        [self layoutIfNeeded];
        self.chaseTenButton.hidden = NO;
        self.chaseTwentyButton.hidden = NO;
        self.chaseMoreButton.hidden = NO;
    }];
}
#pragma mark - 展示中奖追号停止View
- (void)showAwardViewSubViews{
    
    [self.awardBaseView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.periodTextField.mas_bottom).offset(__SCALE(5.f));
        make.left.right.equalTo(self);
    }];
    [UIView animateWithDuration:.05f animations:^{
        [self layoutIfNeeded];
        self.awardBaseView.hidden = NO;
    }];
}
#pragma mark - 隐藏中奖追号停止View
- (void)hiddenAwardViewSubViews{
    
    [self.awardBaseView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.periodTextField.mas_bottom).offset(__SCALE(5.f));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(0);
    }];
    [UIView animateWithDuration:.05f animations:^{
        [self layoutIfNeeded];
        self.awardBaseView.hidden = YES;
    }];
}
#pragma mark - 隐藏所有View
- (void)hiddenAllSubView{
    
    [self.awardBaseView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.periodTextField.mas_bottom).offset(__SCALE(5.f));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(0);
    }];
    [self.chaseTenButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.awardBaseView.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    [UIView animateWithDuration:.1f animations:^{
        [self layoutIfNeeded];
        self.chaseTenButton.hidden = YES;
        self.chaseTwentyButton.hidden = YES;
        self.chaseMoreButton.hidden = YES;
        self.awardBaseView.hidden = YES;
    }];
}
#pragma mark - 改变追号title
- (void)changeChaseButtonTitleIsPeriod:(BOOL)isPeriod{
    
    if (isPeriod) {
        [self.chaseTenButton setTitle:@"追10期" forState:UIControlStateNormal];
        [self.chaseTwentyButton setTitle:@"追20期" forState:UIControlStateNormal];
        [self.chaseMoreButton setTitle:[NSString stringWithFormat:@"追%zi期(一天)", self.todayPeriods] forState:UIControlStateNormal];
        
    }else{
        [self.chaseTenButton setTitle:@"投10倍" forState:UIControlStateNormal];
        [self.chaseTwentyButton setTitle:@"投20倍" forState:UIControlStateNormal];
        [self.chaseMoreButton setTitle:@"投50倍" forState:UIControlStateNormal];
    }
    [self configQuickButtonState:isPeriod];
}
#pragma mark - 配置三个快速按钮 的状态
- (void)configQuickButtonState:(BOOL)isPeriod{
    
    self.chaseTenButton.selected = NO;
    self.chaseTwentyButton.selected = NO;
    self.chaseMoreButton.selected = NO;
    if (isPeriod) {
        
        if ([self.periodTextField.text integerValue] == 10) {
            self.chaseTenButton.selected = YES;
        }else if ([self.periodTextField.text integerValue] == 20){
            self.chaseTwentyButton.selected = YES;
        }else if ([self.periodTextField.text integerValue] == self.todayPeriods){
            self.chaseMoreButton.selected = YES;
        }
    }else{
        switch ([self.multipleTextField.text integerValue]) {
            case 10:{
                self.chaseTenButton.selected = YES;
            }
                break;
            case 20:{
                self.chaseTwentyButton.selected = YES;
            }
                break;
            case 50:{
                self.chaseMoreButton.selected = YES;
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark - 配置中奖后停止追号
- (void)configStopChaseWhenAeard:(BOOL)isPeriod{
    
    if (isPeriod) {
        if ([self.periodTextField.text integerValue] > 1) {
            [self showAwardViewSubViews];
            return;
        }
    }
    [self hiddenAwardViewSubViews];
}
#pragma mark ------ event response ------
- (void)agreeButtonOnClick:(UIButton *)btn{
    
    self.agreeImageButton.selected = !self.agreeImageButton.selected;
    self.awardButton.selected = self.agreeImageButton.selected;
}
- (void)questionButtonOnClick:(UIButton *)btn{
    
    [self.periodTextField resignFirstResponder];
    [self.multipleTextField resignFirstResponder];
    [self.alertPromptMsgView showInWindow];
}
- (void)chaseTenButtonOnClick:(UIButton *)btn{
    
    btn.selected = YES;
    self.chaseTwentyButton.selected = NO;
    self.chaseMoreButton.selected = NO;
    //textfield change text
    if (self.periodTextField.isFirstResponder) {
        self.periodTextField.text = @"10";
        [self showAwardViewSubViews];
    }else if (self.multipleTextField.isFirstResponder){
        self.multipleTextField.text = @"10";
    }
    [self sendTextfieldChangeNotification];
}
- (void)chaseTwentyButtonOnClick:(UIButton *)btn{
    
    btn.selected = YES;
    self.chaseTenButton.selected = NO;
    self.chaseMoreButton.selected = NO;
    if (self.periodTextField.isFirstResponder) {
        self.periodTextField.text = @"20";
        [self showAwardViewSubViews];
    }else if (self.multipleTextField.isFirstResponder){
        self.multipleTextField.text = @"20";
    }
    [self sendTextfieldChangeNotification];
}
- (void)chaseMoreButtonOnClick:(UIButton *)btn{
    
    btn.selected = YES;
    self.chaseTwentyButton.selected = NO;
    self.chaseTenButton.selected = NO;
    if (self.periodTextField.isFirstResponder) {
        self.periodTextField.text = [NSString stringWithFormat:@"%zi",self.todayPeriods];
        if ([self.periodTextField.text integerValue] > 1) {
            
            [self showAwardViewSubViews];
        }else{
            
            [self hiddenAwardViewSubViews];
        }
    }else if (self.multipleTextField.isFirstResponder){
        self.multipleTextField.text = @"50";
    }
    [self sendTextfieldChangeNotification];
}
- (void)textFieldChange:(UITextField *)textField{
    
    NSInteger max = (textField == self.periodTextField) ? self.maxPeriod : self.maxMutiple;
    
    if ([textField.text integerValue] > max) {
        
        textField.text = [NSString stringWithFormat:@"%zi", max];
        [self sendTextfieldChangeNotification];
        [CLShowHUDManager showHUDWithView:self.superview text:[NSString stringWithFormat:@"最大输入%zi", max] type:CLShowHUDTypeOnlyText delayTime:1.0f];
    }
    
    if ([textField isEqual:self.periodTextField]) {
        if ([textField.text integerValue] > 1) {
            //追号期次大于1展示中奖后停止
            [self showAwardViewSubViews];
        }else{
            //不大于1 不展示
            [self hiddenAwardViewSubViews];
        }
    }else{
        [self hiddenAwardViewSubViews];
    }
    [self configQuickButtonState:[textField isEqual:self.periodTextField]];
    
}
- (void)additionalButtonOnClick:(UIButton *)btn{
    
    NSLog(@"点击了追加投注");
    self.additionalImageView.hidden = YES;
    !self.additionalImageViewHidden ? : self.additionalImageViewHidden(YES);
    self.additionalButton.selected = !self.additionalButton.selected;
    self.additionalImageButton.selected = self.additionalButton.selected;
    !self.additionalOnClickBlock ? : self.additionalOnClickBlock(self.additionalButton.selected);
}
#pragma mark ------------ setter Mothed ------------
- (void)setIsShowAdditional:(BOOL)isShowAdditional{
    
    _isShowAdditional = isShowAdditional;
    if (!isShowAdditional) {
        return;
    }
    [self addSubview:self.additionalBaseView];
    [self.additionalBaseView addSubview:self.additionalTopLineView];
    [self.additionalBaseView addSubview:self.additionalImageButton];
    [self.additionalBaseView addSubview:self.additionalButton];
    [self.additionalBaseView addSubview:self.additionalInfoLabel];
    [self.additionalBaseView addSubview:self.additionalImageView];
    [self.additionalBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(__SCALE(40.f));
    }];
    
    [self.topLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.additionalBaseView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(.5f);
    }];
    
    [self.additionalTopLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self.additionalBaseView);
        make.height.mas_equalTo(.5f);
        
    }];
    [self.additionalImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.additionalButton);
        make.left.equalTo(self.additionalBaseView).offset(__SCALE(10.f));
    }];
    [self.additionalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.additionalImageButton.mas_right).offset(3.f);
        make.centerY.equalTo(self.additionalBaseView);
        
    }];
    [self.additionalInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.additionalBaseView).offset(__SCALE(- 10.f));
        make.centerY.equalTo(self.additionalImageButton);
    }];
    [self.additionalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.additionalBaseView.mas_top);
        make.left.equalTo(self.additionalBaseView).offset(__SCALE(10.f));
        make.height.mas_equalTo(__SCALE(77.f));
        make.width.mas_equalTo(__SCALE(122.f));
    }];
}
- (void)setSetAdditional:(BOOL)setAdditional{
    
    self.additionalButton.selected = setAdditional;
    self.additionalImageButton.selected = setAdditional;
    if (setAdditional) {
        self.additionalImageView.hidden = YES;
        !self.additionalImageViewHidden ? : self.additionalImageViewHidden(YES);
    }
}
#pragma mark ------ getter Mothed ------
- (UIImageView *)topLineImageView{
    
    if (!_topLineImageView) {
        _topLineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _topLineImageView.backgroundColor = UIColorFromRGB(0xe5e5e5);
        
    }
    return _topLineImageView;
}
- (UITextField *)periodTextField{
    
    if (!_periodTextField) {
        _periodTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _periodTextField.layer.cornerRadius = 2.f;
        _periodTextField.backgroundColor = UIColorFromRGB(0xffffff);
        _periodTextField.textColor = UIColorFromRGB(0x333333);
        _periodTextField.font = FONT_SCALE(15.f);
        _periodTextField.delegate = self;
        _periodTextField.placeholder = @"1";
        _periodTextField.textAlignment = NSTextAlignmentCenter;
        _periodTextField.contentMode = UIViewContentModeCenter;
        _periodTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_periodTextField setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        [_periodTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _periodTextField;
}
- (UITextField *)multipleTextField{
    
    if (!_multipleTextField) {
        _multipleTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _multipleTextField.layer.cornerRadius = 2.f;
        _multipleTextField.backgroundColor = UIColorFromRGB(0xffffff);
        _multipleTextField.textColor = UIColorFromRGB(0x333333);
        _multipleTextField.font = FONT_SCALE(15.f);
        _multipleTextField.delegate = self;
        _multipleTextField.placeholder = @"1";
        _multipleTextField.textAlignment = NSTextAlignmentCenter;
        _multipleTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_multipleTextField setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        [_multipleTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _multipleTextField;
}
- (UILabel *)buyLabel{
    
    if (!_buyLabel) {
        _buyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _buyLabel.text = @"连续买";
        _buyLabel.textColor = UIColorFromRGB(0xffffff);
        _buyLabel.font = FONT_SCALE(14.f);
    }
    return _buyLabel;
}
- (UILabel *)periodLabel{
    
    if (!_periodLabel) {
        _periodLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _periodLabel.text = @"期";
        _periodLabel.textColor = UIColorFromRGB(0xffffff);
        _periodLabel.font = FONT_SCALE(14.f);
    }
    return _periodLabel;
}
- (UILabel *)betLabel{
    
    if (!_betLabel) {
        _betLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _betLabel.text = @"投";
        _betLabel.textColor = UIColorFromRGB(0xffffff);
        _betLabel.font = FONT_SCALE(14.f);
    }
    return _betLabel;
}
- (UILabel *)multipleLabel{
    
    if (!_multipleLabel) {
        _multipleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _multipleLabel.text = @"倍";
        _multipleLabel.textColor = UIColorFromRGB(0xffffff);
        _multipleLabel.font = FONT_SCALE(14.f);
    }
    return _multipleLabel;
}
- (UIImageView *)lineImageView{
    
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _lineImageView.contentMode = UIViewContentModeScaleAspectFit;
        _lineImageView.backgroundColor = UIColorFromRGBandAlpha(0xe5e5e5, 0.3);;
    }
    return _lineImageView;
}
- (UIView *)awardBaseView{
    
    if (!_awardBaseView) {
        _awardBaseView = [[UIView alloc] initWithFrame:CGRectZero];
        _awardBaseView.backgroundColor = CLEARCOLOR;
        _awardBaseView.hidden = YES;
    }
    return _awardBaseView;
}
- (UIView *)awardTopLineView{
    
    if (!_awardTopLineView) {
        _awardTopLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _awardTopLineView.backgroundColor = UIColorFromRGBandAlpha(0xffffff, 0.3);
    }
    return _awardTopLineView;
}
- (UIImageView *)arrowImageView{
    
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _arrowImageView;
}
- (UIButton *)agreeImageButton{
    
    if (!_agreeImageButton) {
        _agreeImageButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_agreeImageButton addTarget:self action:@selector(agreeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_agreeImageButton setImage:[UIImage imageNamed:@"checkRight.png"] forState:UIControlStateSelected];
        [_agreeImageButton setImage:[UIImage imageNamed:@"noCheckRight.png"] forState:UIControlStateNormal];
    }
    return _agreeImageButton;
}
- (UIButton *)awardButton{
    
    if (!_awardButton) {
        _awardButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_awardButton setTitle:@"中奖后停止追号" forState:UIControlStateNormal];
        [_awardButton setTitleColor:UIColorFromRGB(0x71bb99) forState:UIControlStateNormal];
        [_awardButton addTarget:self action:@selector(agreeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _awardButton.titleLabel.font = FONT_SCALE(13);
    }
    return _awardButton;
}
- (UIButton *)questionButton{
    
    if (!_questionButton) {
        _questionButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_questionButton setImage:[UIImage imageNamed:@"lotteryBetDetialPrompt.png"] forState:UIControlStateNormal];
        [_questionButton addTarget:self action:@selector(questionButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _questionButton;
}
- (UIButton *)chaseTenButton{
    
    if (!_chaseTenButton) {
        _chaseTenButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_chaseTenButton setTitle:@"追10期" forState:UIControlStateNormal];
        [_chaseTenButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_chaseTenButton setTitleColor:UIColorFromRGB(0xffff00) forState:UIControlStateSelected];
        _chaseTenButton.titleLabel.font = FONT_SCALE(13.f);
        _chaseTenButton.backgroundColor = CLEARCOLOR;
        _chaseTenButton.hidden = YES;
        [_chaseTenButton addTarget:self action:@selector(chaseTenButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chaseTenButton;
}
- (UIButton *)chaseTwentyButton{
    
    if (!_chaseTwentyButton) {
        _chaseTwentyButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_chaseTwentyButton setTitle:@"追20期" forState:UIControlStateNormal];
        [_chaseTwentyButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_chaseTwentyButton setTitleColor:UIColorFromRGB(0xffff00) forState:UIControlStateSelected];
        _chaseTwentyButton.titleLabel.font = FONT_SCALE(13.f);
        _chaseTwentyButton.hidden = YES;
        _chaseTwentyButton.backgroundColor = CLEARCOLOR;
        [_chaseTwentyButton addTarget:self action:@selector(chaseTwentyButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chaseTwentyButton;
}
- (UIButton *)chaseMoreButton{
    
    if (!_chaseMoreButton) {
        _chaseMoreButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_chaseMoreButton setTitle:[NSString stringWithFormat:@"追%zi期(一天)", self.todayPeriods] forState:UIControlStateNormal];
        [_chaseMoreButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_chaseMoreButton setTitleColor:UIColorFromRGB(0xffff00) forState:UIControlStateSelected];
        _chaseMoreButton.titleLabel.font = FONT_SCALE(13.f);
        _chaseMoreButton.backgroundColor = CLEARCOLOR;
        _chaseMoreButton.hidden = YES;
        [_chaseMoreButton addTarget:self action:@selector(chaseMoreButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chaseMoreButton;
}
- (UIView *)chaseLeftLineView{
    
    if (!_chaseLeftLineView) {
        _chaseLeftLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _chaseLeftLineView.backgroundColor = UIColorFromRGBandAlpha(0xe5e5e5, 0.3);
    }
    return _chaseLeftLineView;
}
- (UIView *)chaseRightLineView{
    
    if (!_chaseRightLineView) {
        _chaseRightLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _chaseRightLineView.backgroundColor = UIColorFromRGBandAlpha(0xe5e5e5, 0.3);
    }
    return _chaseRightLineView;
}
- (UIView *)bottomLineView{
    
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLineView.backgroundColor = UIColorFromRGBandAlpha(0xe5e5e5, 0.3);
    }
    return _bottomLineView;
}
- (CLAlertPromptMessageView *)alertPromptMsgView{
    
    WS(_weakSelf)
    if (!_alertPromptMsgView) {
        _alertPromptMsgView = [[CLAlertPromptMessageView alloc] init];
        _alertPromptMsgView.title = @"什么是中奖后停止追号";
        _alertPromptMsgView.desTitle = allAlertInfo_BonusStopChase;
        _alertPromptMsgView.cancelTitle = @"知道了";
        _alertPromptMsgView.blockWhenHidden = ^(){
            
            [_weakSelf.periodTextField becomeFirstResponder];
        };
    }
    return _alertPromptMsgView;
}
- (CLLotteryMaxPeriodRequest *)maxPeriodRequest{
    
    if (!_maxPeriodRequest) {
        
        _maxPeriodRequest = [[CLLotteryMaxPeriodRequest alloc] init];
        _maxPeriodRequest.delegate = self;
        _maxPeriodRequest.gameEn = self.gameEn;
    }
    return _maxPeriodRequest;
}
- (UIView *)additionalBaseView{
    
    if (!_additionalBaseView) {
        _additionalBaseView = [[UIView alloc] init];
    }
    return _additionalBaseView;
}
- (UIButton *)additionalImageButton{
    
    if (!_additionalImageButton) {
        _additionalImageButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_additionalImageButton addTarget:self action:@selector(additionalButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_additionalImageButton setImage:[UIImage imageNamed:@"checkRight.png"] forState:UIControlStateSelected];
        [_additionalImageButton setImage:[UIImage imageNamed:@"noCheckRight.png"] forState:UIControlStateNormal];
    }
    return _additionalImageButton;
}
- (UIButton *)additionalButton{
    
    if (!_additionalButton) {
        _additionalButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_additionalButton setTitle:@"追加投注" forState:UIControlStateNormal];
        [_additionalButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [_additionalButton addTarget:self action:@selector(additionalButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _additionalButton.titleLabel.font = FONT_SCALE(13);
    }
    return _additionalButton;
}
- (UIView *)additionalTopLineView{
    
    if (!_additionalTopLineView) {
        _additionalTopLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _additionalTopLineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _additionalTopLineView;
}
- (UILabel *)additionalInfoLabel{
    
    if (!_additionalInfoLabel) {
        _additionalInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _additionalInfoLabel.text = @"每注追加1元，最多可中1600万";
        _additionalInfoLabel.textColor = UIColorFromRGB(0x999999);
        _additionalInfoLabel.font = FONT_SCALE(12);
    }
    return _additionalInfoLabel;
}
- (UIImageView *)additionalImageView{
    
    if (!_additionalImageView) {
        _additionalImageView = [[UIImageView alloc] init];
        _additionalImageView.contentMode = UIViewContentModeScaleAspectFit;
//        _additionalImageView.image = [UIImage imageNamed:@"additionalIcon.png"];
    }
    return _additionalImageView;
}
#pragma mark ------ 只读属性 ------
- (NSString *)chasePeriod{
    
    if ([self.periodTextField.text integerValue] > 0) {
        return self.periodTextField.text;
    }else{
        return self.periodTextField.placeholder;
    }
}
- (NSString *)chaseMultiple{
    
    if ([self.multipleTextField.text integerValue] > 0) {
        return self.multipleTextField.text;
    }else{
        return self.multipleTextField.placeholder;
    }
}
- (BOOL)isStopChase{
    
    return self.awardButton.selected;
}
@end
