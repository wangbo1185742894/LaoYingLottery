//
//  CLAwardBottomBetView.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLAwardBottomBetView.h"
#import "CLConfigMessage.h"

@interface CLAwardBottomBetView ()

@property (nonatomic, strong) UIButton* leftButton;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UIView* lineView;

@property (nonatomic, assign) CLAwardBottomType type;

@end

@implementation CLAwardBottomBetView

+ (instancetype)awardBottomWithType:(CLAwardBottomType)type
{

    return [[CLAwardBottomBetView alloc] initWithType:type];
}


- (instancetype)initWithType:(CLAwardBottomType)type
{
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.type = type;
        
        [self p_addSubviews];
        [self p_addConstraints];

    }
    return self;
}

- (void)p_addSubviews
{

    [self addSubview:self.leftButton];
    
    if (self.type == CLAwardBottomTypeSFC) {
        
        [self addSubview:self.rightButton];
    }
    [self addSubview:self.lineView];
}

- (void)p_addConstraints
{

    if (self.type == CLAwardBottomTypeNormal) {
    
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(__SCALE(240.f));
            make.height.mas_equalTo(__SCALE(35.f));
            make.center.equalTo(self);
        }];

    }else{
    
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self).offset(CL__SCALE(15.f));
            make.height.mas_offset(CL__SCALE(35.f));
            make.right.equalTo(self.mas_centerX).offset(CL__SCALE(-7.5));
            make.centerY.equalTo(self);
        }];
        
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_centerX).offset(CL__SCALE(7.5));
            make.right.equalTo(self).offset(CL__SCALE(-15.f));
            make.height.equalTo(self.leftButton);
            make.centerY.equalTo(self);
        }];
    }
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(.5f);
    }];
    
}

- (void)returnLeftButtonBlock:(CLAwardBottomBlock)leftBlock
{

    _leftBlock = leftBlock;
}

- (void)returnRightButtonBlock:(CLAwardBottomBlock)rightBlock
{

    _rightBlock = rightBlock;
}


- (void)buttonClick:(UIButton *)btn
{

    if (self.leftButton == btn) {
        
        self.leftBlock ? self.leftBlock() : nil;
        
    }else{
    
        self.rightBlock ? self.rightBlock() : nil;
    }
}

#pragma mark ----- lazyLoad ------
- (UIButton *)leftButton
{

    if (_leftButton == nil) {
        
        _leftButton = [self createButton];
        
        if (self.type == CLAwardBottomTypeNormal) {
            
            [_leftButton setTitle:@"立即投注" forState:(UIControlStateNormal)];
        }else{
        
            [_leftButton setTitle:@"投注胜负彩" forState:(UIControlStateNormal)];
        }
    }
    return _leftButton;
}

- (UIButton *)rightButton
{

    if (_rightButton == nil) {
        
        _rightButton = [self createButton];
        
        [_rightButton setTitle:@"投注任选九" forState:(UIControlStateNormal)];
    }
    return _rightButton;
}

- (UIButton *)createButton
{

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = FONT_SCALE(16);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:THEME_COLOR];
    
    btn.layer.cornerRadius = 4.f;
    
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    return btn;
}

- (UIView *)lineView
{

    if (_lineView == nil) {
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _lineView;
}


@end
