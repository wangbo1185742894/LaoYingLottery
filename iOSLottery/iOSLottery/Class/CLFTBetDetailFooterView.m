//
//  CLFTBetDetailFooterView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/21.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTBetDetailFooterView.h"
#import "CLConfigMessage.h"
#import "UILabel+CLAttributeLabel.h"
@interface CLFTBetDetailFooterView ()

@property (nonatomic, strong) UIButton *leftButton;//左侧 清空 按钮
@property (nonatomic, strong) UIButton *rightButton;//右侧 确定 按钮
@property (nonatomic, strong) UILabel *moneyLabel;//中间 说明label
@property (nonatomic, strong) UILabel *betInfoLabel;//投注说明label
@property (nonatomic, strong) UIImageView *backgroundImageView;//背景图

@end
@implementation CLFTBetDetailFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0x333333);
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.moneyLabel];
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        [self addSubview:self.betInfoLabel];
        
        [self configContraint];
    }
    return self;
}
#pragma mark ------ public Mothed ------
- (void)assignBetNote:(NSInteger)note period:(NSInteger)periodCount multiple:(NSInteger)multiple{
    
    self.moneyLabel.text = [NSString stringWithFormat:@"共%zi元", 2 * note * periodCount * multiple];
    self.betInfoLabel.text = [NSString stringWithFormat:@"%zi注%zi期%zi倍", note, periodCount, multiple];
    
    if (note == 0) {
        [self.leftButton setTitle:@"机选" forState:UIControlStateNormal];
        [self.leftButton removeTarget:self action:@selector(clearButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.leftButton addTarget:self action:@selector(randomButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.leftButton setTitle:@"清空" forState:UIControlStateNormal];
        [self.leftButton removeTarget:self action:@selector(randomButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.leftButton addTarget:self action:@selector(clearButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
#pragma mark ------ private Mothed ------
- (void)configContraint{
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10.f);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(__SCALE(65.f));
        make.height.mas_equalTo(__SCALE(34.f));
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(- 10.f);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(__SCALE(65.f));
        make.height.mas_equalTo(__SCALE(34.f));
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY);
        make.centerX.equalTo(self);
    }];
    [self.betInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).offset(5.f);
        make.centerX.equalTo(self);
    }];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}
#pragma mark ------ event Response ------
- (void)clearButtonOnClick:(UIButton *)btn{
    
    self.clearButtonClickBlock ? self.clearButtonClickBlock() : nil;
}
- (void)randomButtonOnClick:(UIButton *)btn{
    
    self.chaseButtonClickBlock ? self.chaseButtonClickBlock() : nil;
}
- (void)rightButtonOnClick:(UIButton *)btn{
    
    self.payButtonClickBlock ? self.payButtonClickBlock() : nil;
}
#pragma mark ------ getter Mothed ------
- (UIButton *)leftButton{
    
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_leftButton setTitle:@"清空" forState:UIControlStateNormal];
        [_leftButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _leftButton.backgroundColor = UIColorFromRGB(0x999999);
        _leftButton.titleLabel.font = FONT_SCALE(15);
        _leftButton.layer.cornerRadius = 2.f;
        [_leftButton addTarget:self action:@selector(randomButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
- (UIButton *)rightButton{
    
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_rightButton setTitle:@"确认" forState:UIControlStateNormal];
        [_rightButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _rightButton.backgroundColor = UIColorFromRGB(0xff4747);
        _rightButton.titleLabel.font = FONT_SCALE(15);
        _rightButton.layer.cornerRadius = 2.f;
        [_rightButton addTarget:self action:@selector(rightButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
- (UILabel *)moneyLabel{
    
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _moneyLabel.textColor = UIColorFromRGB(0xffff00);
        _moneyLabel.font = FONT_SCALE(15.f);
    }
    return _moneyLabel;
}
- (UILabel *)betInfoLabel{
    
    if (!_betInfoLabel) {
        _betInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _betInfoLabel.textColor = UIColorFromRGB(0xffffff);
        _betInfoLabel.font = FONT_SCALE(11);
    }
    return _betInfoLabel;
}
- (UIImageView *)backgroundImageView{
    
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroundImageView.backgroundColor = UIColorFromRGB(0x000000);
    }
    return _backgroundImageView;
}


@end
