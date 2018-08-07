//
//  CQBetODHeaderMoneySubView.m
//  caiqr
//
//  Created by huangyuchen on 16/7/22.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "SLBetODHeaderMoneySubView.h"
#import "CQDefinition.h"
#import "SLBODAllModel.h"
#import "SLConfigMessage.h"
#import "CQTransitionAnimationView.h"
#import "UIImage+SLImage.h"

#import "UILabel+SLCountDown.h"

@interface SLBetODHeaderMoneySubView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIImageView *awardImageView; //中奖显示图片
@property (nonatomic, strong) CQTransitionAnimationView *notWinImageView; //未中奖显示图片
@property (nonatomic, strong) UIImageView *awardBackgroundView; //中奖显示图片背景彩带
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) CALayer *verticalLine;
@property (nonatomic, strong) SLBODHeaderMoneyModel *moneyModel;

@end

@implementation SLBetODHeaderMoneySubView

#pragma mark - 传数据配置UI
- (void)assignHeaderMoneyWithData:(id)data HeaderType:(SLBODHeaderMoneyType)type{
    self.moneyModel = data;
    if (type == SLBODHeaderMoneyTypeDefault) {
        //普通样式
        [self assignForDefaultWithData:(id)data];
    }
    if (type == SLBODHeaderMoneyTypeImage) {
        //图片样式
        [self assignForImageWithData:(id)data];
    }
    if (type == SLBODHeaderMoneyTypeButton) {
        //按钮样式
        [self assignForTimerWithData:(id)data];
    }
}
#pragma mark - 普通样式
- (void)assignForDefaultWithData:(id)data{
    
    //首先移除无用子控件
    [self.awardImageView removeFromSuperview];
    [self.awardBackgroundView removeFromSuperview];
    [self.notWinImageView removeFromSuperview];
    [self.payButton removeFromSuperview];
    //添加需要控件
    [self addSubview:self.titleLabel];
    [self addSubview:self.moneyLabel];
    //配置需要的控件
    self.titleLabel.text = self.moneyModel.title;
    self.titleLabel.textColor = SL_UIColorFromRGB(0x999999);
    self.moneyLabel.text = self.moneyModel.content;

    self.titleLabel.frame = SL__Rect(0, CGRectGetHeight(self.bounds) / 2 - SL__SCALE(20.f), CGRectGetWidth(self.bounds), SL__SCALE(14.f));
    self.titleLabel.font = SL_FONT_SCALE(12.f);
    
    //self.titleLabel.backgroundColor = [UIColor redColor];
    
    if (self.moneyModel.is_ChangeColor == 1) {
        //文字需要变色
        self.moneyLabel.textColor = [UIColor redColor];
    }else{
        self.moneyLabel.textColor = SL_UIColorFromRGB(0x333333);
    }
}
#pragma mark - 图片样式
- (void)assignForImageWithData:(id)data{
    //移除无用控件
    [self.titleLabel removeFromSuperview];
    [self.moneyLabel removeFromSuperview];
    [self.payButton removeFromSuperview];

    //添加需要控件
    [self addSubview:self.awardBackgroundView];
    [self addSubview:self.awardImageView];
    
    //配置需要控件
    self.awardImageView.image = [UIImage imageNamed:self.moneyModel.title];
    self.awardBackgroundView.image = [UIImage imageNamed:self.moneyModel.backtitle];
    self.awardImageView.hidden = NO;
    if (self.moneyModel.status == 1 && self.isFirstAllocView && self.moneyModel.backtitle) {
        CGRect frame = self.awardImageView.frame;
        frame.origin.x = self.bounds.size.width;
        self.awardImageView.frame = frame;
        [self starAnimationWithAward];
    }else{
        //未中奖情况下 用 transitionView覆盖原有图片
        self.awardImageView.hidden = YES;
        self.notWinImageView = [CQTransitionAnimationView creatTransitionAnimationViewWithFrame:self.awardImageView.frame];
        self.notWinImageView.userInteractionEnabled = YES;
        WS(weakself)
        if ([self.moneyModel activity_status].click_status) {
            self.notWinImageView.btnclick = ^(){
                [weakself notWinImageViewClick:nil];
            };
        }
        [self addSubview:self.notWinImageView];
        self.notWinImageView.topImageView.image = [UIImage imageNamed:self.moneyModel.title];

//        [CQTools cq_setImageSetWith:self.notWinImageView.topImageView Url:[NSURL URLWithString:self.moneyModel.activity_status.activity_dy_url] placeholder:nil];
//        [CQTools cq_setImageSetWith:self.notWinImageView.topImageView Url:[NSURL URLWithString:self.moneyModel.activity_status.activity_dy_url] withComlete:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            if (image == nil) {
//                self.notWinImageView.topImageView.image = [UIImage imageNamed:self.moneyModel.title];
//            }
//        }];
//        [CQTools cq_setImageSetWith:self.notWinImageView.bottomImageView Url:[NSURL URLWithString:self.moneyModel.activity_status.activity_bg_url] withComlete:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            if (image == nil) {
//                self.notWinImageView.bottomImageView.image = [UIImage imageNamed:@"背景漂浮物"];
//            }
//        }];
        self.awardBackgroundView.alpha = 1;
        
    }
}

#pragma mark - 3.9.85

- (void)resetImageAndStatus:(NSString *)dyImage bgImage:(NSString *)bgImage{
    self.notWinImageViewClick = nil;
//    [CQTools cq_setImageSetWith:self.notWinImageView.topImageView Url:[NSURL URLWithString:dyImage] withComlete:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        if (image == nil) {
//            self.notWinImageView.topImageView.image = [UIImage imageNamed:self.moneyModel.title];
//        }
//    }];
//    [CQTools cq_setImageSetWith:self.notWinImageView.bottomImageView Url:[NSURL URLWithString:bgImage] withComlete:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        if (image == nil) {
//            self.notWinImageView.bottomImageView.image = [UIImage imageNamed:@"背景漂浮物"];
//        }
//    }];

    [self.notWinImageView.topImageView stopAllAnimation];
    [self.notWinImageView.bottomImageView stopAllAnimation];
}

- (void)startShowAnimation{
    [self.notWinImageView.topImageView startAnimationWithTransitionWithStyle:CQTransitionAnimationTypeTransition];
    [self.notWinImageView.bottomImageView startAnimationWithTransitionWithStyle:CQTransitionAnimationTypeTwinkle];
//    [self.notWinImageView performSelector:@selector(startAnimationWithTransitionWithStyle:) withObject:@(CQTransitionAnimationTypeTransition)];
}
#pragma mark - 3.9.5 洪利添加奖杯飞入效果
- (void)starAnimationWithAward{
    [UIView animateWithDuration:0.6 animations:^{
        self.awardImageView.frame = __Rect(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.awardBackgroundView.alpha = 1;
        }];
    }];
}
#pragma mark - 中奖图标点击
- (void)awardImageViewClick:(id)ges{
    self.awardImageView.userInteractionEnabled = NO;
    if (_awardImageViewClick && self.moneyModel.status == 1) {
        _awardImageViewClick();
    }
    if (self.notWinImageView && self.notWinImageViewClick) {
        _notWinImageViewClick();
    }
    self.awardImageView.userInteractionEnabled = YES;
}
- (void)notWinImageViewClick:(id)sender{
    self.notWinImageView.userInteractionEnabled = NO;
    if (self.notWinImageView && self.notWinImageViewClick) {
        _notWinImageViewClick();
    }
    self.notWinImageView.userInteractionEnabled = YES;
}
#pragma mark - 倒计时样式
- (void)assignForTimerWithData:(id)data{
    //移除无用控件
    [self.awardImageView removeFromSuperview];
    [self.moneyLabel removeFromSuperview];
    [self.notWinImageView removeFromSuperview];
    [self.awardBackgroundView removeFromSuperview];
    //添加需要控件
    [self addSubview:self.titleLabel];
    [self addSubview:self.payButton];
    //配置需要控件
    
    if (self.moneyModel.ifCountdown == 1) {
        
        [self.titleLabel setCountDownText:self.moneyModel.title];
    }else{
    
        self.titleLabel.text = [self getMMSSFromSS:[self.moneyModel.title integerValue]];
    }
    
    self.titleLabel.frame = __Rect(0, CGRectGetHeight(self.bounds) / 2 - __SCALE(21.f), CGRectGetWidth(self.bounds), __SCALE(15.f));
    self.titleLabel.textColor = SL_UIColorFromRGB(0xff4747);
    self.titleLabel.font = FONT_FIX(10);
    self.payButton.enabled = YES;
    [self.payButton setTitle:(self.moneyModel.is_Rebuy) ? @"重下此单" : @"继续支付" forState:UIControlStateNormal];
}

- (void)stopTimer{
    
    [self.titleLabel stopCountDown];
}

//传入 秒  得到  xx分钟xx秒
- (NSString *)getMMSSFromSS:(NSInteger )totalTime
{
    
    NSInteger seconds = totalTime;
    //format of day
    NSString *str_day = [NSString stringWithFormat:@"%02ld",seconds/(3600 * 24)];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    //NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@天%@时",str_day,str_hour];

    
    //NSLog(@"format_time : %@",format_time);
    
    return format_time;
    
}


#pragma mark - 支付btn触发事件
- (void)payBtnOnClick:(UIButton *)btn{
    
    //结束倒计时
    [self.titleLabel stopCountDown];
    
    btn.enabled = NO;
    if (self.continuePayBlock) {
        self.continuePayBlock(btn);
    }
}

#pragma mark - setterMothed
//set 是否存在竖线
- (void)setHeaderMoneyLineType:(CQBODHeaderMoneyLineType)headerMoneyLineType{
    _headerMoneyLineType = headerMoneyLineType;
    if (_headerMoneyLineType == CQBODHeaderMoneyLineTypeNone) {
        [self.verticalLine removeFromSuperlayer];
    }
    if (_headerMoneyLineType == CQBODHeaderMoneyLineTypeLine) {
        [self.layer addSublayer:self.verticalLine];
    }
}

- (void)setNotWinImageViewClick:(void (^)())notWinImageViewClick{
    _notWinImageViewClick = notWinImageViewClick;
    if (_notWinImageViewClick && [self.moneyModel activity_status].click_status) {
        [self startShowAnimation];
    }
}
#pragma mark - getterMothed
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:__Rect(0, CGRectGetHeight(self.bounds) / 2 - __SCALE(20.f), CGRectGetWidth(self.bounds), __SCALE(15.f))];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = SL_UIColorFromRGB(0x999999);
        _titleLabel.font = FONT_FIX(11);
    }
    return _titleLabel;
}
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] initWithFrame:__Rect(0, CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.titleLabel.frame) - SL__SCALE(19.f))];
        _moneyLabel.numberOfLines = 0;
        _moneyLabel.textColor = SL_UIColorFromRGB(0x333333);
        _moneyLabel.font = SL_FONT_SCALE(16.f);
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLabel;
}
- (UIImageView *)awardImageView{
    if (!_awardImageView) {
        _awardImageView = [[UIImageView alloc] initWithFrame:__Rect(__SCALE(10.f),__SCALE(10.f), CGRectGetWidth(self.frame) - __SCALE(20), CGRectGetHeight(self.frame) - __SCALE(20))];
        
        _awardImageView.backgroundColor = [UIColor clearColor];
        
        _awardImageView.contentMode = UIViewContentModeScaleAspectFit;
        _awardImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(awardImageViewClick:)];
        [_awardImageView addGestureRecognizer:tap];
    }
    return _awardImageView;
}
- (UIImageView *)awardBackgroundView{
    if (!_awardBackgroundView) {
        _awardBackgroundView = [[UIImageView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _awardBackgroundView.alpha = 0;
        _awardBackgroundView.backgroundColor = [UIColor clearColor];
        _awardBackgroundView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _awardBackgroundView;
}
- (UIButton *)payButton{
    if (!_payButton) {
        _payButton = [[UIButton alloc] initWithFrame:__Rect(__SCALE(20), CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.bounds) - __SCALE(20) * 2, __SCALE(23.f))];
        [_payButton setTitle:@"继续支付" forState:UIControlStateNormal];
        _payButton.titleLabel.font = FONT(13);
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_payButton setBackgroundImage:[UIImage sl_imageWithColor:SL_UIColorFromRGB(0xE63222)] forState:UIControlStateNormal];
        [_payButton setBackgroundImage:[UIImage sl_imageWithColor:SL_UIColorFromRGB(0xc34040)] forState:UIControlStateHighlighted];
        
        _payButton.layer.cornerRadius = 3.f;
        _payButton.layer.masksToBounds = YES;
        [_payButton addTarget:self action:@selector(payBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}
- (CALayer *)verticalLine{
    if (!_verticalLine) {
        _verticalLine = [[CALayer alloc] init];
        _verticalLine.frame = __Rect(0, 0, .5f, __SCALE(30));
        _verticalLine.position = CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) / 2);
        _verticalLine.backgroundColor = SL_UIColorFromRGB(0xdcdcdc).CGColor;
    }
    return _verticalLine;
}
@end
