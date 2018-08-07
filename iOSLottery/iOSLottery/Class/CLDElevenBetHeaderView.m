//
//  CLDElevenBetHeaderView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLDElevenBetHeaderView.h"
#import "CLConfigMessage.h"
#import "CLLotteryPeriodModel.h"
#import "CLLotteryMainBetModel.h"
#import "CLLotteryDataManager.h"
@interface CLDElevenBetHeaderView ()

@property (nonatomic, strong) UIView *baseView;//为了居中的View
@property (nonatomic, strong) UILabel *periodLabel;//期次label
@property (nonatomic, strong) UILabel *timeLabel;//倒计时label
@property (nonatomic, strong) UIImageView *arrowImageView;//箭头图片
@property (nonatomic, strong) UIImageView *bottomLineImageView;//底部线条View

@end
@implementation CLDElevenBetHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        [self addSubview:self.baseView];
        [self.baseView addSubview:self.periodLabel];
        [self.baseView addSubview:self.timeLabel];
        [self.baseView addSubview:self.arrowImageView];
        [self addSubview:self.bottomLineImageView];
        [self configConstraint];
        //添加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
#pragma mark ------------ public Mothed ------------
- (void)reloadDataForBetHeaderView{
    
    [self assigBetHeaderCurrentPeriodWithData:[CLLotteryDataManager getAllInfoDataGameEn:self.gameEn]];
}
#pragma mark - 向下箭头的旋转
- (void)arrowImageViewIsRotation:(BOOL)isRotation{
    
    
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
    
    self.de_headViewOnClickBlock ? self.de_headViewOnClickBlock() : nil;
}
#pragma mark ------------ private Mothed ------------
#pragma mark - 配置约束
- (void)configConstraint{
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.centerY.top.bottom.left.equalTo(self.baseView);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.periodLabel.mas_right);
        make.width.mas_greaterThanOrEqualTo(__SCALE(37.f));
        make.centerY.equalTo(self.periodLabel);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).offset(1.f);
        make.centerY.equalTo(self.timeLabel);
        make.height.mas_equalTo(__SCALE(5));
        make.width.mas_equalTo(__SCALE(9));
        make.right.equalTo(self.baseView);
    }];
    [self.bottomLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(.5f);
    }];
    
    [self.bottomLineImageView layoutIfNeeded];
}
#pragma mark - 将秒数转换成分秒  若大于1小时，则转换成时分秒
- (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    if (hours > 0) {
        return [NSString stringWithFormat:@"%zi:%02zi:%02zi",hours, minutes, seconds];
    }else{
        return [NSString stringWithFormat:@"%02zi:%02zi",minutes, seconds];
    }
    
}
- (void)assigBetHeaderCurrentPeriodWithData:(id)data{
    
    CLLotteryMainBetModel *model = data;
    if (model && model.currentSubPeriod && model.currentSubPeriod.length > 0) {
        
        if (model.currentPeriod.saleEndTime == 0) {
            
            [self assignWaitAwardWithPeriod:model.currentSubPeriod];
            return;
        }

        
        if (self.isShowAllPeriod == YES) {
            
            self.periodLabel.text = [NSString stringWithFormat:@"距%@期截止：", model.currentPeriod.periodId];
        }else{
        
            self.periodLabel.text = [NSString stringWithFormat:@"距%@期截止：", model.currentSubPeriod];
        }
        
        self.timeLabel.text = [self timeFormatted:model.currentPeriod.saleEndTime];
        self.timeLabel.textColor = UIColorFromRGB(0xd90000);
    }else{
        self.periodLabel.text = @"";
        self.timeLabel.text = @"未能获取彩期";
        self.timeLabel.textColor = UIColorFromRGB(0x333333);
    }
}
- (void)assignWaitAwardWithPeriod:(NSString *)period{
    
    self.periodLabel.text = [NSString stringWithFormat:@"%@期等待开奖", period];
    self.timeLabel.text = @"";
}
#pragma mark ------------ setter Mothed ------------
- (void)setArrowImage:(UIImage *)arrowImage{
    
    self.arrowImageView.image = arrowImage;
}

#pragma mark ------------ getter Mothed ------------
- (UIView *)baseView{
    
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:CGRectZero];
        _baseView.backgroundColor = CLEARCOLOR;
    }
    return _baseView;
}
- (UILabel *)periodLabel{
    
    if (!_periodLabel) {
        _periodLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _periodLabel.text = @"";
        _periodLabel.textColor = UIColorFromRGB(0x000000);
        _periodLabel.font = FONT_SCALE(13);
    }
    return _periodLabel;
}
- (UILabel *)timeLabel{
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.text = @"未能获取彩期";
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
