
//
//  CLAlertPromptMessageView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/6.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLAlertPromptMessageView.h"
#import "CLConfigMessage.h"
#import "Masonry.h"
#import "AppDelegate.h"

@interface CLAlertPromptMessageView ()

@property (nonatomic, strong) UIView *backgroundView;//背景底色
@property (nonatomic, strong) UILabel *titleLabel;//titleLabel
@property (nonatomic, strong) UILabel *desLabel;//描述label
@property (nonatomic, strong) UIView *lineView;//中间线View
@property (nonatomic, strong) UIButton *cancelButton;//取消按钮


@end
@implementation CLAlertPromptMessageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColorFromRGBandAlpha(0x333333, 0.75);
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self addSubview:self.backgroundView];
        
        [self.backgroundView addSubview:self.titleLabel];
        [self.backgroundView addSubview:self.desLabel];
        [self.backgroundView addSubview:self.lineView];
        [self.backgroundView addSubview:self.cancelButton];
        UITapGestureRecognizer *tapSelf = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf:)];
        [self addGestureRecognizer:tapSelf];
        [self configContraint];
    }
    return self;
}
#pragma mark ------------ public Mothed ------------
- (void)showInView:(UIView *)superView{
    
    self.hidden = NO;
    [superView addSubview:self];
    [superView bringSubviewToFront:self];
}

- (void)showInWindow{
    [self showInView:((AppDelegate *)[[UIApplication sharedApplication] delegate]).window];
}
- (void)hide{
    
    self.hidden = YES;
    !self.blockWhenHidden ? : self.blockWhenHidden();
    [self removeFromSuperview];
}


#pragma mark ------------ event Response ------------
- (void)cancelButtonOnClick:(UIButton *)button{
    
    !self.btnOnClickBlock ? : self.btnOnClickBlock();
    [self hide];
}

- (void)tapSelf:(UITapGestureRecognizer *)tap{
    
    
    [self hide];
}
#pragma mark ------------ private Mothed ------------
- (void)configContraint{
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self);
        make.width.mas_equalTo((SCREEN_WIDTH - 40.f));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.backgroundView).offset(__SCALE(10.f));
        make.centerX.equalTo(self.backgroundView);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.backgroundView).offset(__SCALE(20.f));
        make.right.equalTo(self.backgroundView).offset(__SCALE(-20.f));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(__SCALE(10.f));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.desLabel.mas_bottom).offset(__SCALE(10.f));
        make.left.right.equalTo(self.backgroundView);
        make.height.mas_equalTo(.5f);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lineView.mas_bottom);
        make.left.right.equalTo(self.backgroundView);
        make.height.mas_equalTo(__SCALE(40.f));
        make.bottom.equalTo(self.backgroundView);
    }];
    
}
#pragma mark ------------ setter Mothed ------------
- (void)setDesTitle:(NSString *)desTitle{
    
    _desTitle = desTitle;
    self.desLabel.text = desTitle;
}
- (void)setCancelTitle:(NSString *)cancelTitle{
    
    _cancelTitle = cancelTitle;
    [self.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
}
- (void)setTitle:(NSString *)title{
    
    _title = title;
    self.titleLabel.text = title;
}
#pragma mark ------------ getter Mothed ------------
- (UIView *)backgroundView{
    
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        _backgroundView.backgroundColor = UIColorFromRGB(0xffffff);
        _backgroundView.layer.cornerRadius = 4.f;
        _backgroundView.layer.masksToBounds = YES;
    }
    return _backgroundView;
}
- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = FONT_SCALE(15);
        _titleLabel.textColor =  UIColorFromRGB(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UILabel *)desLabel{
    
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _desLabel.font = FONT_SCALE(14);
        _desLabel.numberOfLines = 0;
        _desLabel.textColor =  UIColorFromRGB(0x666666);
        _desLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _desLabel;
}
- (UIView *)lineView{
    
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _lineView;
}
- (UIButton *)cancelButton{
    
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_cancelButton setTitle:@"知道了" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:LINK_COLOR forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = FONT_SCALE(17);
        [_cancelButton addTarget:self action:@selector(cancelButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
@end
