//
//  CLFTBetHeaderView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/15.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTBetHeaderView.h"
#import "CLConfigMessage.h"
#import "CLLotteryDataManager.h"
#import "CLLotteryBonusNumModel.h"
#import "CLLotteryPeriodModel.h"
#import "CLLotteryMainBetModel.h"
#import "CLTools.h"
#import "CLLotteryAllInfo.h"
@interface CLFTBetHeaderView ()

@property (nonatomic, strong) CLFTBetHeaderLeftView *leftView;
@property (nonatomic, strong) CLFTBetHeaderRightView *rightView;
@property (nonatomic, strong) UIImageView *midLineImageView;
@property (nonatomic, strong) UIImageView *bottomLineImageView;

@end
@implementation CLFTBetHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftView];
        [self addSubview:self.rightView];
        [self addSubview:self.midLineImageView];
        [self addSubview:self.bottomLineImageView];
        //给自身添加点击事件
        UITapGestureRecognizer *tapSelf = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelfOnClick:)];
        [self addGestureRecognizer:tapSelf];
        [self configConstraint];
    }
    return self;
}
- (void)configConstraint{
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self.mas_centerX);
        make.top.bottom.equalTo(self);
    }];
    [self.midLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(1.f);
    }];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX);
        make.right.equalTo(self);
        make.top.bottom.equalTo(self);
    }];
    [self.bottomLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark ------------ public Mothed ------------
- (void)reloadDataForFTBetHeaderView{
    
    [self assigFTBetHeaderWithData:[CLLotteryDataManager getAllInfoDataGameEn:self.gameEn]];
}
- (void)assigFTBetHeaderWithData:(CLLotteryMainBetModel *)data{
    
    CLLotteryMainBetModel *model = data;
    
    CLLotteryPeriodModel *periodModel = model.currentPeriod;
    if (!periodModel) {
        return;
    }
    if (periodModel.periodId && periodModel.periodId.length > 2) {
        self.rightView.peroid = model.currentSubPeriod;
    }
    if (periodModel.saleEndTime >= 0) {
        self.rightView.allTime = model.periodAllTime;
        self.rightView.timeNumber = periodModel.saleEndTime;
    }
    
    CLLotteryBonusNumModel *bonusModel = model.lastAwardInfo;
    if (bonusModel.awardStatus == CLLotteryAwardStatusTypeAward) {
        if ((bonusModel.winningNumbers && bonusModel.winningNumbers.length > 0) && (bonusModel.periodId && bonusModel.periodId.length > 0)) {
            [self.leftView showAwardAnimationWithAwardNumber:bonusModel.winningNumbers period:model.lastSubPeriod];
        }
        return;
    }
    //如果 未开中奖号 或请求的数据不正确 显示等待开奖
    [self.leftView showWaitAwardWithPeriod:model.lastSubPeriod];
}
- (void)arrowImageViewIsRotation:(BOOL)isRotation{
    
    [self.leftView arrowImageViewIsRotation:isRotation];
}
#pragma mark ------ event Response ------
- (void)tapSelfOnClick:(UITapGestureRecognizer *)tap{
    
    self.tapHeadViewBlock ? self.tapHeadViewBlock() : nil;
}
#pragma mark ------ getter Mothed ------
- (CLFTBetHeaderLeftView *)leftView{
    
    if (!_leftView) {
        _leftView = [[CLFTBetHeaderLeftView alloc] initWithFrame:CGRectZero];
    }
    return _leftView;
}
- (CLFTBetHeaderRightView *)rightView{
    
    if (!_rightView) {
        _rightView = [[CLFTBetHeaderRightView alloc] initWithFrame:CGRectZero];
    }
    return _rightView;
}
- (UIImageView *)midLineImageView{
    
    if (!_midLineImageView) {
        _midLineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _midLineImageView.backgroundColor = UIColorFromRGB(0x0a633f);
    }
    return _midLineImageView;
}
- (UIImageView *)bottomLineImageView{
    
    if (!_bottomLineImageView) {
        _bottomLineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bottomLineImageView.backgroundColor = UIColorFromRGB(0x063d27);
    }
    return _bottomLineImageView;
}
@end

//头部视图的左侧部分
@interface CLFTBetHeaderLeftView ()

@property (nonatomic, strong) UILabel *awardPeriodLabel;//期次label
@property (nonatomic, strong) UIImageView *waitAwardImageView;//等待开奖的图片
@property (nonatomic, strong) UILabel *waitAwardLabel;//等待开奖label
@property (nonatomic, strong) UIImageView *firstDiceImageView;//第一个骰子
@property (nonatomic, strong) UIImageView *secondDiceImageView;//第二个骰子
@property (nonatomic, strong) UIImageView *thirdDiceImageView;//第三个骰子
@property (nonatomic, strong) UIImageView *animationArrows;//动画的箭头
@property (nonatomic, strong) UIView *diceBaseView;//放三个骰子的View

@end

@implementation CLFTBetHeaderLeftView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.awardPeriodLabel];
        [self addSubview:self.waitAwardImageView];
        [self addSubview:self.waitAwardLabel];
        [self addSubview:self.diceBaseView];
        [self.diceBaseView addSubview:self.firstDiceImageView];
        [self.diceBaseView addSubview:self.secondDiceImageView];
        [self.diceBaseView addSubview:self.thirdDiceImageView];
        [self addSubview:self.animationArrows];
        [self configConstraint];
    }
    return self;
}
#pragma mark ------ public Mothed ------
- (void)showWaitAwardWithPeriod:(NSString *)period{
    
    self.awardPeriodLabel.text = [NSString stringWithFormat:@"%@期开奖中...", period];
    self.waitAwardLabel.hidden = NO;
    self.waitAwardImageView.hidden = NO;
    self.firstDiceImageView.hidden = YES;
    self.secondDiceImageView.hidden = YES;
    self.thirdDiceImageView.hidden = YES;
}
- (void)showAwardAnimationWithAwardNumber:(NSString *)awardNumber period:(NSString *)period{
    
    NSArray *array = [awardNumber componentsSeparatedByString:@" "];
    if (array.count == 3) {
        self.waitAwardLabel.hidden = YES;
        self.waitAwardImageView.hidden = YES;
        self.firstDiceImageView.hidden = NO;
        self.secondDiceImageView.hidden = NO;
        self.thirdDiceImageView.hidden = NO;
        
        self.firstDiceImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_v%@_small.png", array[0]]];
        self.secondDiceImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_v%@_small.png", array[1]]];
        self.thirdDiceImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_v%@_small.png", array[2]]];
        
        //当 imageView.image 存在时， 并且期次未执行过动画的时候  执行动画
        if (self.firstDiceImageView.image &&
            self.secondDiceImageView.image &&
            self.thirdDiceImageView.image &&
            ![CLLotteryAllInfo shareLotteryAllInfo].ft_animationPeriodDic[period]) {
            self.firstDiceImageView.animationImages = [self getImageViewRandomImageArray];
            self.firstDiceImageView.animationRepeatCount = 1;
            self.firstDiceImageView.animationDuration = .5f;
            
            
            self.secondDiceImageView.animationImages = [self getImageViewRandomImageArray];
            self.secondDiceImageView.animationRepeatCount = 2;
            self.secondDiceImageView.animationDuration = .5f;
            
            
            self.thirdDiceImageView.animationImages = [self getImageViewRandomImageArray];
            self.thirdDiceImageView.animationRepeatCount = 3;
            self.thirdDiceImageView.animationDuration = .5f;
            
            [self.firstDiceImageView startAnimating];
            [self.secondDiceImageView startAnimating];
            [self.thirdDiceImageView startAnimating];
            //执行过动画后 存储该期次已经执行过动画
            [[CLLotteryAllInfo shareLotteryAllInfo].ft_animationPeriodDic setObject:@(YES) forKey:period];
        }
        self.awardPeriodLabel.text = [NSString stringWithFormat:@"%@期开奖：%@", period, awardNumber];
    }else{
        [self showWaitAwardWithPeriod:period];
    } 
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
    [self.animationArrows.layer addAnimation:animation forKey:nil];
    
}
#pragma mark ------ private Mothed ------
- (void)configConstraint{
    
    [self.awardPeriodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(__SCALE(3.f));
    }];
    [self.waitAwardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.waitAwardLabel.mas_left).offset(__SCALE(-5.f));
        make.centerY.equalTo(self.waitAwardLabel);
    }];
    [self.waitAwardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.awardPeriodLabel.mas_bottom).offset(__SCALE(5.f));
        make.centerX.equalTo(self).offset(__SCALE(3.f));
    }];
    
    [self.diceBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.awardPeriodLabel);
        make.top.equalTo(self.awardPeriodLabel.mas_bottom).offset(3.f);
    }];
    [self.firstDiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.diceBaseView);
        make.top.equalTo(self.diceBaseView);
        make.height.width.mas_equalTo(__SCALE(28.f));
        make.bottom.equalTo(self.diceBaseView);
    }];
    [self.secondDiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstDiceImageView.mas_right).offset(__SCALE(3.f));
        make.centerY.height.width.equalTo(self.firstDiceImageView);
    }];
    [self.thirdDiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondDiceImageView.mas_right).offset(__SCALE(3.f));
        make.centerY.height.width.equalTo(self.firstDiceImageView);
        make.right.equalTo(self.diceBaseView);
    }];
    [self.animationArrows mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.diceBaseView.mas_right).offset(__SCALE(5));
        make.centerY.equalTo(self.waitAwardLabel);
    }];
    
}
#pragma mark - 返回一组随机图片 （模拟骰子转动）
- (NSArray *)getImageViewRandomImageArray{
    
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 6; i++) {
        NSInteger index = arc4random() % 6 + 1;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_v%zi_small.png", index]];
        if ([imageArr indexOfObject:image] != NSNotFound) {
            i = i-1;
        }else{
            [imageArr addObject:image];
        }
    }
    return imageArr;
}
#pragma mark ------ getter Mothed ------
- (UILabel *)awardPeriodLabel{
    
    if (!_awardPeriodLabel) {
        _awardPeriodLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _awardPeriodLabel.text = @"暂无数据";
        _awardPeriodLabel.textAlignment = NSTextAlignmentCenter;
        _awardPeriodLabel.textColor = UIColorFromRGB(0x8eeacc);
        _awardPeriodLabel.font = FONT_SCALE(12.f);
    }
    return _awardPeriodLabel;
}
- (UIImageView *)waitAwardImageView{
    
    if (!_waitAwardImageView) {
        _waitAwardImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _waitAwardImageView.contentMode = UIViewContentModeScaleAspectFit;
        _waitAwardImageView.image = [UIImage imageNamed:@"ft_Hourglass.png"];
        _waitAwardImageView.hidden = YES;
    }
    return _waitAwardImageView;
}
- (UILabel *)waitAwardLabel{
    
    if (!_waitAwardLabel) {
        _waitAwardLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _waitAwardLabel.text = @"等待开奖";
        _waitAwardLabel.textColor = UIColorFromRGB(0xffffff);
        _waitAwardLabel.font = FONT_SCALE(17.f);
        _waitAwardLabel.hidden = YES;
    }
    return _waitAwardLabel;
}
- (UIView *)diceBaseView{
    
    if (!_diceBaseView) {
        _diceBaseView = [[UIView alloc] initWithFrame:CGRectZero];
        _diceBaseView.backgroundColor = CLEARCOLOR;
    }
    return _diceBaseView;
}
- (UIImageView *)firstDiceImageView{
    
    if (!_firstDiceImageView) {
        _firstDiceImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _firstDiceImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _firstDiceImageView;
}
- (UIImageView *)secondDiceImageView{
    
    if (!_secondDiceImageView) {
        _secondDiceImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _secondDiceImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _secondDiceImageView;
}
- (UIImageView *)thirdDiceImageView{
    
    if (!_thirdDiceImageView) {
        _thirdDiceImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _thirdDiceImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _thirdDiceImageView;
}
- (UIImageView *)animationArrows{
    
    if (!_animationArrows) {
        _animationArrows = [[UIImageView alloc] initWithFrame:CGRectZero];
        _animationArrows.contentMode = UIViewContentModeScaleAspectFit;
        _animationArrows.image = [UIImage imageNamed:@"ft_recentAwardDown.png"];
    }
    return _animationArrows;
}
@end

//头部视图的右侧部分
@interface CLFTBetHeaderRightView ()

@property (nonatomic, strong) UILabel *currentPeriodLable;//当前期
@property (nonatomic, strong) UILabel *timeLabel;//倒计时
@property (nonatomic, strong) UIView *progressBarView;//进度条
@property (nonatomic, strong) CAGradientLayer *colorLayer;//渐变颜色条
@property (nonatomic, strong) CALayer *coverLayer;//遮挡渐变条的layer
@end

@implementation CLFTBetHeaderRightView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.allTime = 600;
        [self addSubview:self.currentPeriodLable];
        [self addSubview:self.timeLabel];
        [self addSubview:self.progressBarView];
        [self.progressBarView.layer addSublayer:self.colorLayer];
        [self.progressBarView.layer addSublayer:self.coverLayer];
        [self configConstraint];
    }
    return self;
}
#pragma mark ------ private Mothed ------
- (void)configConstraint{
    
    [self.currentPeriodLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(__SCALE(3.f));
        make.centerX.equalTo(self);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.currentPeriodLable.mas_bottom).offset(__SCALE(5.f));
        make.centerX.equalTo(self);
    }];
    [self.progressBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(__SCALE(5.f));
    }];
}
#pragma mark ------ setter Mothed ------
- (void)setPeroid:(NSString *)peroid{
    
    _peroid = peroid;
    self.currentPeriodLable.text = [NSString stringWithFormat:@"距%@期截止", peroid];
}
- (void)setTimeNumber:(NSInteger)timeNumber{
    
    _timeNumber = timeNumber;
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:@"iconfont" size:__SCALE_HALE(20.f)],
                          NSParagraphStyleAttributeName:paraStyle,
                          NSKernAttributeName:@(-5.f)
                          };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:[CLTools getLEDTimeWithTime:timeNumber] attributes:dic];
    self.timeLabel.attributedText = attributeStr;
    //控制进度条长度(默认总长度10分钟)
    CGFloat width = (SCREEN_WIDTH / 2.f) * (timeNumber / ((CGFloat)self.allTime));
    self.coverLayer.frame = __Rect(width, 0, (SCREEN_WIDTH / 2) - width, __SCALE(5.f));//注 这里宽度和X反着写是因为这里改变的上层覆盖的Layer，而不是真正的下层进度条
    if (timeNumber == 0) {
        self.currentPeriodLable.text = [NSString stringWithFormat:@"%@期已截止", self.peroid];
    }
}
#pragma mark ------ getter Mothed ------
- (UILabel *)currentPeriodLable{
    
    if (!_currentPeriodLable) {
        _currentPeriodLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _currentPeriodLable.text = @"暂无信息";
        _currentPeriodLable.textColor = UIColorFromRGB(0x8eeacc);
        _currentPeriodLable.font = FONT_SCALE(12.f);
    }
    return _currentPeriodLable;
}
- (UILabel *)timeLabel{
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.text = @"00:00";
//        _timeLabel.font = [UIFont fontWithName:@"DBLCDTempBlack" size:__SCALE_HALE(25.f)];
        
        _timeLabel.font = [UIFont fontWithName:@"iconfont" size:__SCALE_HALE(20.f)];
        
        _timeLabel.textColor = UIColorFromRGB(0xffffff);
    }
    return _timeLabel;
}
- (UIView *)progressBarView{
    
    if (!_progressBarView) {
        _progressBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, __SCALE(5.f))];
    }
    return _progressBarView;
}
- (CAGradientLayer *)colorLayer{
    
    if (!_colorLayer) {
        _colorLayer = [CAGradientLayer layer];
        //    设置颜色梯度
        UIColor *colorOne = UIColorFromRGB(0x33dd66);
//        UIColor *colorTwo = UIColorFromRGB(0x5cc3ff);
        UIColor *colorThree = UIColorFromRGB(0xb4ff00);
        NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorThree.CGColor,nil];
        //梯度次序
        NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
//        NSNumber *stopTwo = [NSNumber numberWithFloat:0.5];
        NSNumber *stopthree = [NSNumber numberWithFloat:1.0];
        NSArray *locations = [NSArray arrayWithObjects:stopOne, stopthree,nil];
        _colorLayer.colors = colors;
        _colorLayer.locations = locations;
        _colorLayer.startPoint = CGPointMake(0, 0);//起始点左侧
        _colorLayer.endPoint = CGPointMake(1, 0);//终点右侧
        _colorLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH / 2, __SCALE(5.f));
    }
    return _colorLayer;
}
- (CALayer *)coverLayer{
    
    if (!_coverLayer) {
        _coverLayer = [[CALayer alloc] init];
        _coverLayer.backgroundColor = UIColorFromRGB(0x004244).CGColor;
        _coverLayer.frame = CGRectMake(SCREEN_WIDTH / 2 - 98, 0, 100, __SCALE(5.f));
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_progressBarView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(__SCALE(5.f), __SCALE(5.f))];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        //设置大小
        maskLayer.frame = _coverLayer.bounds;
        //设置图形样子
        maskLayer.path = maskPath.CGPath;
        _coverLayer.mask = maskLayer;
    }
    return _coverLayer;
}
@end
