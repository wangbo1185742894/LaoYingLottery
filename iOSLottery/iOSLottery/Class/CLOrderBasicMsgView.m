//
//  CLOrderBasicMsgView.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/15.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLOrderBasicMsgView.h"
#import "CLConfigMessage.h"
#import "CQDefinition.h"
#import "CLTools.h"

@interface CLOrderBasicMsgView ()

@property (nonatomic, strong) CLOrderBasicCashView* orderAmountView;
@property (nonatomic, strong) CLOrderBasicCashView* orderBonusView;
@property (nonatomic, strong) CLOrderBasicCashView* orderStateView;

@property (nonatomic, strong) UIView* leftSeparateLine;
@property (nonatomic, strong) UIView* rightSeparateLine;


@end

@implementation CLOrderBasicMsgView

//两个数据 三个数据

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.orderAmountView];
        [self addSubview:self.orderBonusView];
        [self addSubview:self.leftSeparateLine];
        [self addSubview:self.rightSeparateLine];
        [self addSubview:self.orderStateView];
    }
    return self;
}

- (void)setBasicMsgArray:(NSArray *)basicMsgArray {
    
    
    [self.orderAmountView setUpCashMessage:basicMsgArray[0]];
    [self.orderBonusView setUpCashMessage:basicMsgArray[1]];
    
    if (basicMsgArray.count == 3) {
        
        [self.orderStateView setUpCashMessage:basicMsgArray[2]];
        
        [self.orderAmountView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.right.equalTo(self.orderBonusView.mas_left);
        }];
        
        [self.orderBonusView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderAmountView.mas_right);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.equalTo(self.orderAmountView.mas_width);
            make.right.equalTo(self.orderStateView.mas_left);
        }];
        
        [self.orderStateView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderBonusView.mas_right);
            make.top.equalTo(self);
            make.right.equalTo(self);
            make.width.equalTo(self.orderAmountView.mas_width);
            make.bottom.equalTo(self);
        }];
        
        [self.leftSeparateLine mas_remakeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.orderAmountView.mas_right);
            make.width.mas_equalTo(0.5f);
            make.top.equalTo(self).offset(__SCALE(15.f));
            make.bottom.equalTo(self).offset(__SCALE(- 15.f));
            
        }];
        
        [self.rightSeparateLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.orderBonusView.mas_right);
            make.width.equalTo(self.leftSeparateLine);
            make.top.equalTo(self.leftSeparateLine.mas_top);
            make.bottom.equalTo(self.leftSeparateLine.mas_bottom);
            
        }];
        
        self.orderStateView.hidden = NO;
        self.rightSeparateLine.hidden = NO;
        
    } else if (basicMsgArray.count == 2) {
        
        [self.orderAmountView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.right.equalTo(self.orderBonusView.mas_left);
        }];
        
        [self.orderBonusView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderAmountView.mas_right);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.equalTo(self.orderAmountView.mas_width);
            make.right.equalTo(self);
        }];

        [self.leftSeparateLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.orderAmountView.mas_right);
            make.width.mas_equalTo(0.5f);
            make.top.equalTo(self).offset(__SCALE(15.f));
            make.bottom.equalTo(self).offset(__SCALE(- 15.f));
            
        }];
        
        self.orderStateView.hidden = YES;
        self.rightSeparateLine.hidden = YES;
        
    }
}

- (void) modulesAmountClick {
    
    
}

- (void) modulesBonusClick {
    
    
}

- (void) modulesStateClick {
    
    if ([self.delegate respondsToSelector:@selector(orderBasicMsgEvent)]) {
        [self.delegate orderBasicMsgEvent];
    }
}
#pragma mark getter
- (NSInteger)saleTime{
    
    return self.orderStateView.saleTime;
}

- (CLOrderBasicCashView *)orderAmountView {
    
    if (!_orderAmountView) {
        _orderAmountView = [[CLOrderBasicCashView alloc] init];
        [_orderAmountView addTarget:self sel:@selector(modulesAmountClick)];
    }
    return _orderAmountView;
}

- (CLOrderBasicCashView *)orderBonusView {
    
    if (!_orderBonusView) {
        _orderBonusView = [[CLOrderBasicCashView alloc] init];
        [_orderBonusView addTarget:self sel:@selector(modulesBonusClick)];
    }
    return _orderBonusView;
}

- (CLOrderBasicCashView *)orderStateView {
    
    if (!_orderStateView) {
        _orderStateView = [[CLOrderBasicCashView alloc] init];
        [_orderStateView addTarget:self sel:@selector(modulesStateClick)];
    }
    return _orderStateView;
}

- (UIView *)leftSeparateLine {
    
    if (!_leftSeparateLine) {
        _leftSeparateLine = [[UIView alloc] init];
        _leftSeparateLine.backgroundColor = SEPARATE_COLOR;
    }
    return _leftSeparateLine;
}

- (UIView *)rightSeparateLine {
    
    if (!_rightSeparateLine) {
        _rightSeparateLine = [[UIView alloc] init];
        _rightSeparateLine.backgroundColor = SEPARATE_COLOR;
    }
    return _rightSeparateLine;
}

@end
















@interface CLOrderBasicCashView ()

@property (nonatomic, strong) UILabel* titleLbl;
@property (nonatomic, strong) UILabel* contentLbl;

@property (nonatomic, strong) UIImageView* imgView;

@property (nonatomic, strong) UILabel* timeLbl;
@property (nonatomic, strong) UIButton* btn;

@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic) long long totalSecound;

@end

@implementation CLOrderBasicCashView

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setContentType:(CLOrderBasicCashType)type {
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    switch (type) {
        case CLOrderBasicCashTypeText:
            [self setMsgTypeConstraint];
            break;
        case CLOrderBasicCashTypeImg:
            [self setImgTypeConstraint];
            break;
        case CLOrderBasicCashTypeBtn:
            [self setPayTypeConstraint];
            break;
        default:
            break;
    }
}

- (void) addTarget:(id)target sel:(SEL)sel {
    
    [self.btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpCashMessage:(CLOrderBasicCashViewModel*)msg {
    
    [self setContentType:msg.type];
    
    if (msg.type == CLOrderBasicCashTypeText) {
        self.titleLbl.text = msg.title;
        (msg.titleColor)?self.titleLbl.textColor = msg.titleColor:nil;
        self.contentLbl.text = msg.content;
        (msg.contentColor)?self.contentLbl.textColor = msg.contentColor:nil;
    } else if (msg.type == CLOrderBasicCashTypeBtn) {
        
        
        self.totalSecound = msg.payEndTime;
        self.saleTime = self.totalSecound;
        [self configDownCountAndPayBtn:self.totalSecound];
        
        if (msg.ifCountdown == 1) {
          
           self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timeDownCount:) userInfo:nil repeats:YES];
            
        }
    } else if (msg.type == CLOrderBasicCashTypeImg) {
        
        self.imgView.image = msg.image;
    }
}

- (void)timeDownCount:(NSTimer*)ti {
    
    self.totalSecound--;
    self.saleTime = self.totalSecound;
    [self configDownCountAndPayBtn:self.totalSecound];
    
    if (self.totalSecound <= 0) {
        [ti invalidate];
    }
}

- (void) configDownCountAndPayBtn:(long long)time {
    
    if (time > 0) {
        self.timeLbl.text = [NSString stringWithFormat:@"倒计时 %@",[CLTools timeFormatted:self.totalSecound]];
        self.btn.backgroundColor = THEME_COLOR;
        self.btn.enabled = YES;
        [self.btn setTitle:@"继续支付" forState:UIControlStateNormal];
    } else {
        self.timeLbl.text = @"";
        self.btn.backgroundColor = UNABLE_COLOR;
        self.btn.enabled = NO;
        [self.btn setTitle:@"已截止" forState:UIControlStateNormal];
    }
}

#pragma mark - Constraint

- (void)setMsgTypeConstraint {
    
    [self addSubview:self.titleLbl];
    [self addSubview:self.contentLbl];
    
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self).offset(__SCALE(5.f));
        make.height.mas_equalTo(__SCALE(25.f));
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(__SCALE(25.f));
        make.bottom.equalTo(self).offset(__SCALE(- 5.f));
    }];
}


- (void)setImgTypeConstraint {
    
    [self addSubview:self.imgView];
    

    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self);
        make.height.equalTo(self.mas_height).offset(__SCALE(-8.5));
        make.width.equalTo(self.imgView.mas_height).multipliedBy(6/5.0);
    }];
}

- (void)setPayTypeConstraint {
    
    [self addSubview:self.btn];
    [self addSubview:self.timeLbl];
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btn.mas_left);
        make.right.equalTo(self.btn.mas_right);
        make.top.equalTo(self).offset(__SCALE(5.f));
        make.height.mas_equalTo(__SCALE(25.f));
    }];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.width.equalTo(self.mas_width).multipliedBy(0.8);
        make.height.mas_equalTo(__SCALE(25.f));
        make.bottom.equalTo(self).offset(__SCALE(-5.f));
    }];
    
    
    
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    
    [super layoutSublayersOfLayer:layer];
    self.btn.layer.cornerRadius = 2.f;
}

#pragma mark-getter

- (UILabel *)titleLbl {
    
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = FONT_SCALE(12);
        _titleLbl.textColor = UIColorFromRGB(0x999999);
        _titleLbl.textAlignment = NSTextAlignmentCenter;

    }
    return _titleLbl;
}

- (UILabel *)contentLbl {
    
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] init];
        _contentLbl.font = FONT_SCALE(16);
        _contentLbl.textColor = UIColorFromRGB(0x333333);
        _contentLbl.font = [UIFont systemFontOfSize:15];
        _contentLbl.textAlignment = NSTextAlignmentCenter;

    }
    return _contentLbl;
}

- (UIButton *)btn {
    
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.layer.cornerRadius = 2.f;
        _btn.layer.masksToBounds = YES;
        _btn.titleLabel.font = FONT_SCALE(13);
    }
    return _btn;
}

- (UILabel *)timeLbl {
    
    if (!_timeLbl) {
        _timeLbl = [[UILabel alloc] init];
        _timeLbl.textAlignment = NSTextAlignmentCenter;
        _timeLbl.textColor = THEME_COLOR;
        _timeLbl.font = FONT_SCALE(11);
    }
    return _timeLbl;
}

- (UIImageView *)imgView {
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

@end






