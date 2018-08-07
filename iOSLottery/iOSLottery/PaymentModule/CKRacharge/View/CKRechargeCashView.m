//
//  CKRechargeCashView.m
//  caiqr
//
//  Created by 任鹏杰 on 2017/4/28.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKRechargeCashView.h"
#import "CKDefinition.h"
#import "UITextField+CKInputLimit.h"
#import "CKRechargeCashModel.h"
#import "CKPayChannelDataSource.h"
#import "Masonry.h"
#import "UIImageView+CkWebImage.h"
#import "CKRechargeLimitModel.h"
#define CKRECHARGE_CASH_BTN_TAG_OFFSET 100
#define CKRECHARGE_CASH_HEIGHT __SCALE(45)
@interface CKRechargeCashView ()<UITextFieldDelegate>

/**
 输入框
 */
@property (nonatomic, strong) CKRechargeTextField* inputTextField;

/**
 输入框左侧label
 */
@property (nonatomic, strong) UILabel *leftLabel;

/**
 遮挡图（用与取消输入框输入）
 */
@property (nonatomic, strong) UIView* markView;

/**
 选项容器视图
 */
@property (nonatomic, strong) UIView* containerView;

/**
 选项内容数组
 */
@property (nonatomic, strong) NSArray* fillArrays;

/**
 vip基层View
 */
@property (nonatomic, strong) UIView *vipBaseView;

/**
 vip内容view
 */
@property (nonatomic, strong) UIView *vipBaseContextView;

/**
 vip图标
 */
@property (nonatomic, strong) UIImageView *vipImageView;

/**
 vip title
 */
@property (nonatomic, strong) UILabel *vipTitleLabel;

/**
 vip 说明label
 */
@property (nonatomic, strong) UILabel *vipDespLabel;

/**
 提现说明label
 */
@property (nonatomic, strong) UILabel *templateLabel;

/**
 当前选中的按钮下标
 */
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) UIColor *normalBackColor;
@property (nonatomic, strong) UIColor *selectedBackColor;
@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *selectedTextColor;

@end


@implementation CKRechargeCashView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = UIColorFromRGB(0xF5F5F5);
        
        [self addSubviews];
        
        [self addConstraints];
    }

    return self;

}

/**
 添加子视图
 */
- (void)addSubviews
{
    [self addSubview:self.inputTextField];
    [self addSubview:self.markView];
    [self addSubview:self.containerView];
    [self addSubview:self.vipBaseView];
    [self.vipBaseContextView addSubview:self.vipImageView];
    [self.vipBaseContextView addSubview:self.vipTitleLabel];
    [self.vipBaseContextView addSubview:self.vipDespLabel];
    [self.vipBaseView addSubview:self.vipBaseContextView];
    [self addSubview:self.templateLabel];
}

/**
 添加约束
 */
- (void)addConstraints
{

    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(CKRECHARGE_CASH_HEIGHT);
    }];
    
    [self.markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.inputTextField);
    }];

    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.top.equalTo(self.inputTextField.mas_bottom);
        make.right.equalTo(self);
        make.height.mas_equalTo(100);
    }];
    
    [self.vipBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.containerView.mas_bottom);
        make.left.equalTo(self).offset(__SCALE(10.f));
        make.right.equalTo(self).offset(__SCALE(- 10.f));
        make.height.mas_equalTo(__SCALE(33));
    }];
    
    [self.vipBaseContextView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.vipBaseView);
        
    }];
    
    [self.vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.vipBaseContextView.mas_left);
        make.centerY.equalTo(self.vipBaseContextView);
        make.width.height.mas_equalTo(__SCALE(20.f));
    }];
    
    [self.vipTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.vipImageView.mas_right).offset(__SCALE(3.f));
        //make.left.equalTo(self.vipImageView.mas_right).offset(__SCALE(5));
        make.centerY.equalTo(self.vipBaseContextView);
    }];
    
    [self.vipDespLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.vipTitleLabel.mas_right).offset(__SCALE(3.f));
        make.right.equalTo(self.vipBaseContextView.mas_right);
        make.centerY.equalTo(self.vipBaseContextView);
    }];
    
    [self.templateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.vipBaseView);
        make.top.equalTo(self.vipBaseView.mas_bottom).offset(__SCALE(9.f));
        //make.bottom.equalTo(self.mas_bottom).offset(__SCALE(-5.f));
    }];
}

- (void)configureInputTextColor:(UIColor *)textColor buttonNormalBackgroundColor:(UIColor *)normalBackColor buttonNormalTextColor:(UIColor *)normalTextColor buttonselectedBackgroundColor:(UIColor *)selectedBackColor buttonselectedTextColor:(UIColor *)selectedTextColor
{
    if (textColor) {
        
        self.inputTextField.textColor = textColor;
    }
    
    if (normalBackColor) {
        
        self.normalBackColor = normalBackColor;
    }
    
    if (normalTextColor) {
        
        self.normalTextColor = normalTextColor;
    }
    
    if (selectedBackColor) {
        
        self.selectedBackColor = selectedBackColor;
    }
    
    if (selectedTextColor) {
        
        self.selectedTextColor = selectedTextColor;
    }

}

- (void)configminRechargeMoney:(NSArray *)minRechargeMoney
{

    if (minRechargeMoney && minRechargeMoney.count > 0) {
        
        CKRechargeLimitModel *model = minRechargeMoney[0];
        
        NSInteger limit = [model.fill_limit_amount integerValue];
        
        NSString *str = [NSString stringWithFormat:@"最低%ld元",limit / 100];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
        [attr addAttribute:NSFontAttributeName value:FONT_SCALE(14) range:(NSMakeRange(0, attr.length))];
        
        self.inputTextField.attributedPlaceholder = attr;
        
        if ([self.delegate respondsToSelector:@selector(limitMoney:limit_msg:)]) {
            [self.delegate limitMoney:limit limit_msg:model.fill_limit_msg];
        }
    }
}


- (void)configureFillList:(NSArray *)fillList bigMoney:(NSArray *)bigMoney template:(NSString *)templateValue{
    
    self.fillArrays = fillList;
    // 为该容器添加宫格View
    NSInteger __selectIndex = -1;
    
    for (int i = 0; i < fillList.count; i++) {
        CKRechargeCashModel* model = self.fillArrays[i];
        if (model.is_default) __selectIndex = i;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + CKRECHARGE_CASH_BTN_TAG_OFFSET;
        button.layer.borderWidth = .5f;
        button.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
        button.layer.cornerRadius = 2.f;
        button.titleLabel.font = FONT_SCALE(14);
        [button addTarget:self action:@selector(cashSwitch:) forControlEvents:UIControlEventTouchUpInside];
        if (model) {
            [button setTitle:model.show_name forState:UIControlStateNormal];
        }
        [self.containerView addSubview:button];
    }
    // 执行九宫格布局
    NSInteger num = 3;
    
    for (int i = 0; i < fillList.count / num; i++) {
        [[self.containerView.subviews subarrayWithRange:NSMakeRange(num * i, num)] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:__SCALE(10) leadSpacing:__SCALE(10) tailSpacing:__SCALE(10)];
        
        [[self.containerView.subviews subarrayWithRange:NSMakeRange(num * i, num)] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(__SCALE(15) + (i * __SCALE(40)));
            make.height.mas_equalTo(__SCALE(33));
        }];
    }
    
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.top.equalTo(self.inputTextField.mas_bottom);
        make.right.equalTo(self);
        make.height.mas_equalTo((fillList.count > 3)?__SCALE(95):__SCALE(58));
    }];
    
    [self updateConstraints];
    
    
    if (__selectIndex == -1) {
        __selectIndex = 0;
    }
    
    self.selectIndex = __selectIndex;
    [self updateButtonSelectState];
    [self updateInputCash];
    
    self.frame = __Rect(0, 0, SCREEN_WIDTH, (fillList.count > 3)?__SCALE(220):__SCALE(185));
    self.clipsToBounds = YES;
    
    //修改vip 数据
    [self changeVIPWithBigMoney:bigMoney];
    //修改template数据
    self.templateLabel.text = templateValue;
}


/**
 更新输入金额
 */
- (void)updateInputCash {
    
    if (self.fillArrays.count <= self.selectIndex) {
        return;
    }
    CKRechargeCashModel* cash = self.fillArrays[self.selectIndex];
    self.inputTextField.text = [NSString stringWithFormat:@"%zi",cash.amount_value];
    if ([self.delegate respondsToSelector:@selector(rechargeCashChange:)]) {
        [self.delegate rechargeCashChange:cash.amount_value];
    }
}


/**
 设置vip内容
 */
- (void)changeVIPWithBigMoney:(NSArray *)bigMoney{
    
    if (bigMoney && bigMoney.count > 0) {
        
        CKPayChannelDataSource *model = bigMoney[0];
        [self.vipImageView setImageWithURL:[NSURL URLWithString:model.img_url]];
        self.vipTitleLabel.text = model.memo;
        
        NSString *temp = [NSString stringWithFormat:@"(%@)",model.account_type_nm];
        
        NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:temp];
        [attr1 addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x999999) range:(NSMakeRange(0, attr1.length))];
        [attr1 addAttribute:NSFontAttributeName value:FONT_SCALE(12)range:(NSMakeRange(0, attr1.length))];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@" 400-689-2227"];
        [attr addAttribute:NSFontAttributeName value:FONT_SCALE(12)range:(NSMakeRange(0, attr.length))];
        
        [attr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x5797FC) range:(NSMakeRange(0, attr.length))];
        
        [attr1 insertAttributedString:attr atIndex:attr1.length -1];
        
        self.vipDespLabel.attributedText = attr1;
    }
}

//切换选项
- (void)cashSwitch:(UIButton*)sender {
    
    self.selectIndex = sender.tag - CKRECHARGE_CASH_BTN_TAG_OFFSET;
    [self updateButtonSelectState];
    [self updateInputCash];
}

// 是否限制直接输入
- (void) inputCashContentLimit:(BOOL) isLimit {
    
    self.inputTextField.enabled = !isLimit;
    self.markView.hidden = !isLimit;
    if (isLimit && self.selectIndex == -1) {
        self.selectIndex = 0;
        [self updateButtonSelectState];
        [self updateInputCash];
    }
}

//vip服务
- (void)tapVipBaseView:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(vipService)]) {
        [self.delegate vipService];
    }
}


//获取当前充值金额
- (long long) getRechargeMoney
{
    return [self.inputTextField.text longLongValue];
}


#pragma mark --- Button Click ----

- (void)inputTextFieldChange:(UITextField *)textfield{
    
    if ([self.delegate respondsToSelector:@selector(rechargeCashChange:)]) {
        [self.delegate rechargeCashChange:[textfield.text longLongValue]];
    }
}

#pragma mark --- UITextFieldDelegate ---

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL ret = [textField limitNumberLength:5 ShouldChangeCharactersInRange:range replacementString:string];
    
    if (ret) {
        NSString* resultStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.selectIndex = [self searchCommonCashWith:resultStr];
        [self updateButtonSelectState];
        
    }
    
    return ret;
}

- (NSInteger)searchCommonCashWith:(NSString*)cashStr {
    
    __block NSInteger index = -1;
    [self.fillArrays enumerateObjectsUsingBlock:^(CKRechargeCashModel* cash, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (cash.amount_value == [cashStr integerValue]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}
/**
 更新选项状态
 */
- (void)updateButtonSelectState {
    
    for (int i = 0; i < self.fillArrays.count; i++) {
        
        UIButton* button = [self.containerView viewWithTag:CKRECHARGE_CASH_BTN_TAG_OFFSET + i];
        //是否是当前选中按钮
        BOOL ret = (self.selectIndex == i);
        //设置当前按钮背景色
        [button setBackgroundColor:ret?self.selectedBackColor:self.normalBackColor];
        //设置当前按钮文字颜色
        [button setTitleColor:ret?self.selectedTextColor:self.normalTextColor forState:UIControlStateNormal];
    }
}

- (void)setDefaultAmount:(NSInteger)defaultAmount{
    
    self.inputTextField.text = [NSString stringWithFormat:@"%zi", defaultAmount];
    self.selectIndex = [self searchCommonCashWith:[NSString stringWithFormat:@"%zi", defaultAmount]];
    [self updateButtonSelectState];
}

#pragma mark --- Get Method ----

- (UITextField *)inputTextField
{

    if (_inputTextField == nil) {
        
        _inputTextField = [[CKRechargeTextField alloc] init];
        _inputTextField.backgroundColor = [UIColor whiteColor];
        _inputTextField.font = [UIFont fontWithName:@"Helvetica-Bold" size:__SCALE(18)];
        _inputTextField.tintColor = UIColorFromRGB(0x666666);
        _inputTextField.textColor = UIColorFromRGB(0xff4747);
        _inputTextField.delegate = self;
        _inputTextField.leftViewMode = UITextFieldViewModeAlways;
        _inputTextField.leftView = self.leftLabel;
        _inputTextField.rightViewMode = UITextFieldViewModeAlways;
        _inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_inputTextField addTarget:self action:@selector(inputTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
    }

    return _inputTextField;
}

- (UILabel *)leftLabel
{

    if (_leftLabel == nil) {
        
        _leftLabel = [[UILabel alloc] initWithFrame:__Rect(0, 0, __SCALE(30), CKRECHARGE_CASH_HEIGHT)];
        _leftLabel.text = @"¥";
        _leftLabel.font = FONT_SCALE(23);
        _leftLabel.textColor = UIColorFromRGB(0x666666);
        _leftLabel.textAlignment = NSTextAlignmentCenter;
    }

    return _leftLabel;
}
- (UIView *)markView
{

    if (_markView == nil) {
        
        _markView = [[UIView alloc] init];
        _markView.backgroundColor = [UIColor colorWithWhite:1 alpha:.6];
        _markView.hidden = YES;
    }

    return _markView;
}

- (UIView *)containerView
{

    if (_containerView == nil) {
        
        _containerView = [[UIView alloc] init];
        //_containerView.backgroundColor = [UIColor blueColor];
    }
    return _containerView;
}

- (UIView *)vipBaseView{
    
    if (!_vipBaseView) {
        _vipBaseView = [[UIView alloc] initWithFrame:CGRectZero];
        _vipBaseView.backgroundColor = UIColorFromRGB(0xffffff);
        _vipBaseView.layer.cornerRadius = 2.f;
        _vipBaseView.layer.borderWidth = .5f;
        _vipBaseView.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVipBaseView:)];
        [_vipBaseView addGestureRecognizer:tap];
    }
    return _vipBaseView;
}

- (UIView *)vipBaseContextView
{

    if (_vipBaseContextView == nil) {
        
        _vipBaseContextView = [[UIView alloc] initWithFrame:(CGRectZero)];
        _vipBaseContextView.backgroundColor = [UIColor clearColor];
    }
    
    return _vipBaseContextView;
}

- (UIImageView *)vipImageView{
    
    if (!_vipImageView) {
        _vipImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _vipImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _vipImageView;
}

- (UILabel *)vipTitleLabel{
    
    if (!_vipTitleLabel) {
        _vipTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _vipTitleLabel.font = FONT_SCALE(13.f);
        _vipTitleLabel.text = @"VIP";
        _vipTitleLabel.textColor = UIColorFromRGB(0x666666);
        _vipTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _vipTitleLabel;
}

- (UILabel *)vipDespLabel{
    
    if (!_vipDespLabel) {
        _vipDespLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _vipDespLabel.font = FONT_SCALE(13.f);
        _vipDespLabel.text = @"VIP专属客服400-689-227";
        _vipDespLabel.textAlignment = NSTextAlignmentCenter;
        //_vipDespLabel.backgroundColor = [UIColor redColor];
    }
    return _vipDespLabel;
}

- (UILabel *)templateLabel{
    
    if (!_templateLabel) {
        _templateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _templateLabel.font = FONT_SCALE(13.f);
        _templateLabel.text = @"根据国家相关规定，每笔充值金额的50%可提现，剩下的50%只可用于购买彩票或兑换红包。";
        _templateLabel.textColor = UIColorFromRGB(0x999999);
        _templateLabel.numberOfLines = 0;
        _templateLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _templateLabel;
}

- (UIColor *)normalBackColor
{

    if (_normalBackColor == nil) {
        
        _normalBackColor = UIColorFromRGB(0xffffff);
    }
    
    return _normalBackColor;
}

- (UIColor *)normalTextColor
{

    if (_normalTextColor == nil) {
        
        _normalTextColor = UIColorFromRGB(0x666666);
    }

    return _normalTextColor;
}

- (UIColor *)selectedBackColor
{

    if (_selectedBackColor == nil) {
        
        _selectedBackColor = UIColorFromRGB(0xff4747);
    }
    
    return _selectedBackColor;
}

- (UIColor *)selectedTextColor
{

    if (_selectedTextColor == nil) {
        
        _selectedTextColor = UIColorFromRGB(0xffffff);
    }
    return _selectedTextColor;
}

@end

@implementation CKRechargeTextField

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    if (IOS_VERSION >= 11) {
        return CGRectMake(__SCALE(33), (CKRECHARGE_CASH_HEIGHT - __SCALE(13)) / 2, __SCALE(150), __SCALE(13));
    }else{
        return CGRectMake(__SCALE(33), __SCALE(2.5), __SCALE(150), __SCALE(13));
    }
}

@end
