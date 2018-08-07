//
//  CLRechargeCashView.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/15.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLRechargeCashView.h"
#import "CLConfigMessage.h"
#import "CLRechargeCashModel.h"
#import "UITextField+InputLimit.h"
#import "CLRechargeBigMoneyModel.h"
#import "UIImageView+CQWebImage.h"
#define CLRECHARGE_CASH_BTN_TAG_OFFSET 100
#define CLRECHARGE_CASH_HEIGHT __SCALE(45)

@interface CLRechargeCashView () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField* inputTextField;
@property (nonatomic, strong) UIView* markView;
@property (nonatomic, strong) UIView* containerView;

@property (nonatomic, strong) NSArray* fillArrays;

@property (nonatomic, strong) UIView *vipBaseView;//vip基层View
@property (nonatomic, strong) UIImageView *vipImageView;//vip图标
@property (nonatomic, strong) UILabel *vipTitleLabel;//vip title
@property (nonatomic, strong) UILabel *vipDespLabel;//VIP 说明label

@property (nonatomic, strong) UILabel *templateLabel;


@property (nonatomic) NSInteger selectIndex;

@end

@implementation CLRechargeCashView

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorFromRGB(0xF5F5F5);
        
        UILabel* title = [[UILabel alloc] initWithFrame:__Rect(0, 0, __SCALE(50), CLRECHARGE_CASH_HEIGHT)];
        title.text = @"¥";
        title.font = FONT_SCALE(23);
        title.textColor = UIColorFromRGB(0x666666);
        title.textAlignment = NSTextAlignmentCenter;
        
        UILabel* mark = [[UILabel alloc] initWithFrame:__Rect(0, 0, __SCALE(70), CLRECHARGE_CASH_HEIGHT)];
        mark.text = @"(最低50元)";
        mark.font = FONT_FIX(12);
        mark.textColor = UIColorFromRGB(0xbbbbbb);
        mark.textAlignment = NSTextAlignmentCenter;
        
        self.inputTextField = [[UITextField alloc] init];
        self.inputTextField.backgroundColor = [UIColor whiteColor];
        self.inputTextField.textColor = [UIColor redColor];
        self.inputTextField.delegate = self;
        self.inputTextField.leftViewMode = UITextFieldViewModeAlways;
        self.inputTextField.leftView = title;
        self.inputTextField.rightViewMode = UITextFieldViewModeAlways;
        self.inputTextField.rightView = mark;
        [self.inputTextField addTarget:self action:@selector(inputTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
        self.markView = [[UIView alloc] init];
        self.markView.backgroundColor = [UIColor colorWithWhite:1 alpha:.6];
        self.markView.hidden = YES;
        
        [self addSubview:self.vipBaseView];
        [self.vipBaseView addSubview:self.vipTitleLabel];
        [self.vipBaseView addSubview:self.vipDespLabel];
        [self.vipBaseView addSubview:self.vipImageView];
        [self addSubview:self.templateLabel];
        [self addSubview:self.inputTextField];
        [self addSubview:self.markView];
        
        [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.height.mas_equalTo(CLRECHARGE_CASH_HEIGHT);
        }];
        
        [self.markView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.inputTextField);
        }];
        
        self.containerView = [[UIView alloc] init];
        [self addSubview:self.containerView];
        self.containerView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        
        // 给该容器添加布局代码
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self);
            make.top.equalTo(self.inputTextField.mas_bottom);
            make.right.equalTo(self);
            make.height.mas_equalTo(100);
        }];
        
        
        [self.vipBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView.mas_bottom).offset(5.f);
            make.left.equalTo(self).offset(__SCALE(10.f));
            make.right.equalTo(self).offset(__SCALE(- 10.f));
            make.height.mas_equalTo(__SCALE(30));
        }];
        
        [self.vipTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.vipBaseView).multipliedBy(.8f);
            make.centerY.equalTo(self.vipBaseView);
        }];
        
        [self.vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.vipTitleLabel.mas_left).offset(__SCALE(- 3.f));
            make.centerY.equalTo(self.vipTitleLabel);
            make.width.height.mas_equalTo(__SCALE(20.f));
        }];
        [self.vipDespLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.vipTitleLabel.mas_right).offset(__SCALE(3.f));
            make.centerY.equalTo(self.vipTitleLabel);
        }];
        
        [self.templateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(self.vipBaseView);
            make.top.equalTo(self.vipBaseView.mas_bottom).offset(__SCALE(10.f));
            
        }];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *result = [super hitTest:point withEvent:event];
    if (![result isKindOfClass:[UITextField class]]) {
        [result endEditing:YES];
    }
    return result;
}

- (void)configureFillList:(NSArray *)fillList bigMoney:(NSArray *)bigMoney template:(NSString *)templateValue{
    
    self.fillArrays = fillList;
    // 为该容器添加宫格View
    NSInteger __selectIndex = -1;
    
    for (int i = 0; i < fillList.count; i++) {
        CLRechargeCashModel* model = self.fillArrays[i];
        if (model.is_default) __selectIndex = i;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + CLRECHARGE_CASH_BTN_TAG_OFFSET;
        button.layer.borderWidth = .5f;
        button.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
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
            make.top.mas_equalTo(__SCALE(10) + (i * __SCALE(40)));
            make.height.mas_equalTo(__SCALE(30));
        }];
    }
    
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.top.equalTo(self.inputTextField.mas_bottom);
        make.right.equalTo(self);
        make.height.mas_equalTo((fillList.count > 3)?__SCALE(87):__SCALE(50));
    }];
    
    [self updateConstraints];
    
    
    if (__selectIndex == -1) {
        __selectIndex = 0;
    }
    
    self.selectIndex = __selectIndex;
    [self updateButtonSelectState];
    [self updateInputCash];
    
    self.frame = __Rect(0, 0, SCREEN_SCALE, (fillList.count > 3)?__SCALE(210):__SCALE(175));
    self.clipsToBounds = YES;
    
    //修改vip 数据
    [self changeVIPWithBigMoney:bigMoney];
    //修改template数据
    self.templateLabel.text = templateValue;
}
- (void)changeVIPWithBigMoney:(NSArray *)bigMoney{
    
    if (bigMoney && bigMoney.count > 0) {
        
        CLRechargeBigMoneyModel *model = bigMoney[0];
        
        [self.vipImageView setImageWithURL:[NSURL URLWithString:model.img_url]];
        self.vipTitleLabel.text = model.account_type_nm;
        self.vipDespLabel.text = model.memo;
    }
}
//vip服务
- (void)tapVipBaseView:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(vipService)]) {
        [self.delegate vipService];
    }
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
//切换选项
- (void)cashSwitch:(UIButton*)sender {
    
    self.selectIndex = sender.tag - CLRECHARGE_CASH_BTN_TAG_OFFSET;
    [self updateButtonSelectState];
    [self updateInputCash];
}

//获取当前充值金额
- (long long) getRechargeMoney {
    return [self.inputTextField.text longLongValue];
}

- (void)updateButtonSelectState {
    
    for (int i = 0; i < self.fillArrays.count; i++) {
        UIButton* button = [self.containerView viewWithTag:CLRECHARGE_CASH_BTN_TAG_OFFSET + i];
        BOOL ret = (self.selectIndex == i);
        [button setBackgroundColor:ret?THEME_COLOR:[UIColor whiteColor]];
        [button setTitleColor:ret?[UIColor whiteColor]:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (void)updateInputCash {
    
    if (self.fillArrays.count <= self.selectIndex) {
        return;
    }
    CLRechargeCashModel* cash = self.fillArrays[self.selectIndex];
    self.inputTextField.text = [NSString stringWithFormat:@"%zi",cash.amount_value];
    if ([self.delegate respondsToSelector:@selector(rechargeCashChange:)]) {
        [self.delegate rechargeCashChange:cash.amount_value];
    }
}
- (void)inputTextFieldChange:(UITextField *)textfield{
    
    if ([self.delegate respondsToSelector:@selector(rechargeCashChange:)]) {
        [self.delegate rechargeCashChange:[textfield.text integerValue]];
    }
}
- (NSInteger) searchCommonCashWith:(NSString*)cashStr {
    
    __block NSInteger index = -1;
    [self.fillArrays enumerateObjectsUsingBlock:^(CLRechargeCashModel* cash, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (cash.amount_value == [cashStr integerValue]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}

#pragma mark - UITextFieldDelegate

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL ret = [textField limitNumberLength:5 ShouldChangeCharactersInRange:range replacementString:string];
    
    if (ret) {
        NSString* resultStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.selectIndex = [self searchCommonCashWith:resultStr];
        [self updateButtonSelectState];
        
    }
    
    return ret;
}

#pragma mark ------------ getter Mothed ------------
- (UIView *)vipBaseView{
    
    if (!_vipBaseView) {
        _vipBaseView = [[UIView alloc] initWithFrame:CGRectZero];
        _vipBaseView.backgroundColor = UIColorFromRGB(0xffffff);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVipBaseView:)];
        [_vipBaseView addGestureRecognizer:tap];
    }
    return _vipBaseView;
}
- (UILabel *)vipTitleLabel{
    
    if (!_vipTitleLabel) {
        _vipTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _vipTitleLabel.font = FONT_SCALE(13.f);
        _vipTitleLabel.text = @"VIP";
        _vipTitleLabel.textColor = UIColorFromRGB(0x000000);
        _vipTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _vipTitleLabel;
}

- (UILabel *)vipDespLabel{
    
    if (!_vipDespLabel) {
        _vipDespLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _vipDespLabel.font = FONT_SCALE(13.f);
        _vipDespLabel.text = @"单笔20000元以上";
        _vipDespLabel.textColor = UIColorFromRGB(0x999999);
        _vipDespLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _vipDespLabel;
}
- (UIImageView *)vipImageView{
    
    if (!_vipImageView) {
        _vipImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _vipImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _vipImageView;
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
@end
