//
//  CLSSQHeaderView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/1.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSSQHeaderView.h"
#import "CLConfigMessage.h"
@interface CLSSQHeaderView ()

@property (nonatomic, strong) UILabel *periodLabel;//期次label
@property (nonatomic, strong) UILabel *timeLabel;//倒计时label
@property (nonatomic, strong) UIImageView *arrowImageView;//箭头图片
@property (nonatomic, strong) UIImageView *bottomLineImageView;//底部线条View

@end

@implementation CLSSQHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        [self addSubview:self.periodLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.arrowImageView];
        [self addSubview:self.bottomLineImageView];
        [self configConstraint];
        //添加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
#pragma mark ------------ public Mothed ------------
- (void)ssq_assigBetHeaderCurrentPeriodWithData:(NSString *)period endTime:(NSString *)endTime{
    
    if (period && period.length > 0) {
        self.periodLabel.text = [NSString stringWithFormat:@"第%@期",period];
        self.timeLabel.text = endTime;
    }
}
- (void)ssq_assignWaitAwardWithPeriod:(NSString *)period{
    
    self.periodLabel.text = [NSString stringWithFormat:@"%@期等待开奖", period];
    self.timeLabel.text = @"";
}
#pragma mark - 向下箭头的旋转
- (void)ssq_arrowImageViewIsRotation:(BOOL)isRotation{
    
    
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    if (isRotation) {
        animation.fromValue = [NSNumber numberWithFloat:0.f];
        animation.toValue =  [NSNumber numberWithFloat: M_PI];
    }else{
        animation.fromValue = [NSNumber numberWithFloat:M_PI];
        animation.toValue =  [NSNumber numberWithFloat: M_PI * 2];
    }
    animation.duration  = .5f;
    animation.repeatCount = 1;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [self.arrowImageView.layer addAnimation:animation forKey:nil];
    
}
#pragma mark ------------ event Response ------------
- (void)tapSelf:(UITapGestureRecognizer *)tap{
    
    self.rotationAnimation = !self.rotationAnimation;
    self.ssq_headViewOnClickBlock ? self.ssq_headViewOnClickBlock() : nil;
}
#pragma mark ------------ private Mothed ------------
#pragma mark - 配置约束
- (void)configConstraint{
    
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(__SCALE(5.f));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.periodLabel.mas_right).offset(__SCALE(5.f));
        make.centerY.equalTo(self.periodLabel);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel);
        make.height.mas_equalTo(__SCALE(5));
        make.width.mas_equalTo(__SCALE(9));
        make.right.equalTo(self).offset(__SCALE(-10.f));
    }];
    [self.bottomLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(.5f);
    }];
    
    [self.bottomLineImageView layoutIfNeeded];
}
#pragma mark ------------ setter Mothed ------------
- (void)setSsq_headerArrowImage:(UIImage *)ssq_headerArrowImage{
    
    self.arrowImageView.image = ssq_headerArrowImage;
}
- (void)esetRotationAnimation:(BOOL)rotationAnimation{
    
    _rotationAnimation = rotationAnimation;
    [self ssq_arrowImageViewIsRotation:rotationAnimation];
}
#pragma mark ------------ getter Mothed ------------
- (UILabel *)periodLabel{
    
    if (!_periodLabel) {
        _periodLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _periodLabel.text = @"未能获取彩期";
        _periodLabel.textColor = UIColorFromRGB(0x333333);
        _periodLabel.font = FONT_SCALE(13);
    }
    return _periodLabel;
}
- (UILabel *)timeLabel{
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.text = @"";
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = FONT_SCALE(13);
        _timeLabel.textColor = UIColorFromRGB(0x333333);
    }
    return _timeLabel;
}
- (UIImageView *)arrowImageView{
    
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _arrowImageView.image = [UIImage imageNamed:@"order_downArrow.png"];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _arrowImageView;
}
- (UIImageView *)bottomLineImageView{
    
    if (!_bottomLineImageView) {
        _bottomLineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bottomLineImageView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _bottomLineImageView;
}

@end
