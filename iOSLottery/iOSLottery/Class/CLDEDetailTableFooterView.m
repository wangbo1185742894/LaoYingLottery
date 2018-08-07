//
//  CLDEDetailTableFooterView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/5.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLDEDetailTableFooterView.h"
#import "CLConfigMessage.h"
#import "CLAllJumpManager.h"
@interface CLDEDetailTableFooterView ()

@property (nonatomic, strong) UIImageView *topImageView;//上方波浪线
@property (nonatomic, strong) UIImageView *agreeImageView;//对号图片
@property (nonatomic, strong) UILabel *agreeLabel;//同意
@property (nonatomic, strong) UIButton *agreementButton;//协议按钮
@property (nonatomic, strong) UIView *baseView;

@end
@implementation CLDEDetailTableFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topImageView];
        [self addSubview:self.baseView];
        [self.baseView addSubview:self.agreeImageView];
        [self.baseView addSubview:self.agreementButton];
        [self.baseView addSubview:self.agreeLabel];
        
        [self configConstraint];
    }
    return self;
}
#pragma mark ------ private Mothed ------
- (void)configConstraint{
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(__SCALE(5.f));
    }];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageView.mas_bottom).offset(__SCALE(5.f));
        make.centerX.equalTo(self);
        //        make.centerY.equalTo(self);
    }];
    [self.agreeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.baseView);
    }];
    [self.agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.agreeImageView.mas_right).offset(__SCALE(3.f));
        make.centerY.equalTo(self.agreeImageView);
        make.top.bottom.equalTo(self.baseView);
    }];
    [self.agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.agreeLabel.mas_right).offset(__SCALE(3.f));
        make.centerY.equalTo(self.agreeImageView);
        make.right.equalTo(self.baseView);
    }];
}
#pragma mark ------ event Response ------
- (void)agreementButtonOnClick:(UIButton *)btn{
    
    [[CLAllJumpManager shareAllJumpManager] open:url_EntrustProtocol];
}

#pragma mark ------ getter Mothed ------
- (UIImageView *)topImageView{
    
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
        _topImageView.image = [UIImage imageNamed:@"lotteryWaveLine.png"];
    }
    return _topImageView;
}
- (UIImageView *)agreeImageView{
    
    if (!_agreeImageView) {
        _agreeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _agreeImageView.contentMode = UIViewContentModeScaleAspectFit;
        _agreeImageView.image = [UIImage imageNamed:@"checkRight.png"];
    }
    return _agreeImageView;
}
- (UILabel *)agreeLabel{
    
    if (!_agreeLabel) {
        _agreeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _agreeLabel.text = @"我已阅读并同意";
        _agreeLabel.textColor = UIColorFromRGB(0x000000);
        _agreeLabel.font = FONT_SCALE(10);
    }
    return _agreeLabel;
}
- (UIButton *)agreementButton{
    
    if (!_agreementButton) {
        _agreementButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_agreementButton setTitle:@"《委托投注协议》" forState:UIControlStateNormal];
        [_agreementButton setTitleColor:LINK_COLOR forState:UIControlStateNormal];
        _agreementButton.titleLabel.font = FONT_SCALE(10);
        [_agreementButton addTarget:self action:@selector(agreementButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreementButton;
}
- (UIView *)baseView{
    
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:CGRectZero];
        _baseView.backgroundColor = CLEARCOLOR;
    }
    return _baseView;
}

@end
