//
//  CLLotteryBallView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/1.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryBallView.h"
#import "CLConfigMessage.h"
#import "CLDElevenConfigMessage.h"

@interface CLLotteryBallView ()<CAAnimationDelegate>

@property (nonatomic, strong) UILabel *contentLabel;//文字label
@property (nonatomic, strong) UIImageView *backgroundImageView;//背景图片

@end

@implementation CLLotteryBallView

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.selectColor = UIColorFromRGB(0xd90000);
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.contentLabel];
        [self configConstraint];
        [self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        //touchUpOutside 在外部松手后触发  防止点击button时，下拉页面后松手不触发方法
        [self addTarget:self action:@selector(touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        //touchCancel 点击事件取消  在点击button时，不松手进入下一页面会触发该方法
        [self addTarget:self action:@selector(touchUpCancel:) forControlEvents:UIControlEventTouchCancel];
    }
    return self;
}

//- (void)layoutSubviews
//{
//
//    [super layoutSubviews];
//    
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentLabel.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.contentLabel.bounds.size];
//    
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    
//    maskLayer.frame = self.contentLabel.layer.bounds;
//    
//    maskLayer.path = maskPath.CGPath;
//    
//    self.contentLabel.layer.mask = maskLayer;
//}

#pragma mark ------------ public Mothed ------------

#pragma mark ------------ event Response ------------
- (void)touchDown:(CLLotteryBallView *)betBtn{
    
    self.scaleAnimation = YES;
}
- (void)touchUpInside:(CLLotteryBallView *)betBtn{
    
    self.selected = !self.selected;
    self.scaleAnimation = NO;
}
- (void)touchUpOutside:(CLLotteryBallView *)btn{
    //不做选中改变 只是收起动画
    self.scaleAnimation = NO;
}
- (void)touchUpCancel:(CLLotteryBallView *)btn{
    //不做选中改变 只是收起动画
    self.scaleAnimation = NO;
}
#pragma mark ------------ private Mothed ------------
- (void)configConstraint{
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(__SCALE(34.f));
    }];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self);
        make.height.mas_equalTo(87);
        make.width.mas_equalTo(53);
    }];
}
#pragma mark - 选中时的状态
- (void)selectSelfState{
    
    self.contentLabel.textColor = UIColorFromRGB(0xffffff);
    self.contentLabel.backgroundColor = self.selectColor;
    self.contentLabel.layer.borderWidth = 0;
}
#pragma mark - 未选中时的状态
- (void)noSelectSelfState{
    
    self.contentLabel.textColor = self.selectColor;
    self.contentLabel.backgroundColor = UIColorFromRGB(0xffffff);
    self.contentLabel.layer.borderWidth = 0.5f;
}
#pragma mark - 放大动画
- (void)bigAnimation{
    
    [self selectSelfState];
    CAAnimation *scaleAnimation = [self createScaleAnimateDuration:.05f timingFunction:nil sx:1.1 sy:1.1 sz:1 beginTime:0];
    
    NSValue *value1 = [NSValue valueWithCGPoint:self.contentLabel.layer.position];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(self.contentLabel.layer.position.x, __SCALE(- 17))];
    
    CAAnimation *positionAnimation = [self createPositionAnimateDuration:.05f positionValus:@[value1, value2] timingFunctions:nil beginTime:0];
    CAAnimation *group = [self addAnimateGruopWithanimations:@[positionAnimation, scaleAnimation] duration:.05f];
    [self.contentLabel.layer addAnimation:group forKey:@"big"];
}
#pragma mark - 还原动画
- (void)restoreAnimation{
    
    if (self.selected) {
        [self selectSelfState];
    }else{
        [self noSelectSelfState];
    }
    CAAnimation *scaleAnimation = [self createScaleAnimateDuration:.1f timingFunction:nil sx:(1.0/1.1) sy:(1.0/1.1) sz:1 beginTime:0];
    NSValue *value1 = [NSValue valueWithCGPoint:self.contentLabel.layer.position];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(self.contentLabel.layer.position.x, __SCALE(- 17))];
    
    CAAnimation *positionAnimation = [self createPositionAnimateDuration:.05f positionValus:@[value2, value1] timingFunctions:nil beginTime:0];
    CAAnimation *group = [self addAnimateGruopWithanimations:@[positionAnimation, scaleAnimation] duration:.05f];
    [self.contentLabel.layer addAnimation:group forKey:@"small"];
}
#pragma mark - 随机动画
- (void)startRandomAnimation{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DE_ShakeAnimationStart object:nil];
    
    [self selectSelfState];
    CAAnimation *scaleAnimation = [self createScaleAnimateDuration:.1f timingFunction:nil sx:1.3 sy:1.3 sz:1 beginTime:0];
    scaleAnimation.delegate = self;
    scaleAnimation.removedOnCompletion = YES;
    scaleAnimation.fillMode = kCAFillModeRemoved;
    [self.contentLabel.layer addAnimation:scaleAnimation forKey:@"big"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    self.animationStopBlock ? self.animationStopBlock() : nil;
    
}
#pragma mark ------------ setter Mothed ------------
#pragma mark - 选中状态
- (void)setSelected:(BOOL)selected{
    
    if (self.selected == selected) {
        return;
    }
    [super setSelected:selected];
    
    if (selected) {
        [self selectSelfState];
    }else{
        [self noSelectSelfState];
    }
    
    self.selectBetButtonBlock ? self.selectBetButtonBlock(self) : nil;
}
#pragma mark - 缩放动画
- (void)setScaleAnimation:(BOOL)scaleAnimation{
    
    if (self.scaleAnimation == scaleAnimation) return;
    _scaleAnimation = scaleAnimation;
    self.backgroundImageView.hidden = !scaleAnimation;//背景图是否显示
    if (self.scaleAnimation) {
        [self bigAnimation];
    }else{
        [self restoreAnimation];
    }
}
#pragma mark - 显示文案
- (void)setContentString:(NSString *)contentString{
    
    _contentString = contentString;
    self.contentLabel.text = contentString;
}
#pragma mark - 随机选中时的动画
- (void)setRandomAnimation:(BOOL)randomAnimation{
    
    _randomAnimation = randomAnimation;
    [self startRandomAnimation];
}
- (void)setSelectColor:(UIColor *)selectColor{
    
    _selectColor = selectColor;
    _contentLabel.textColor = selectColor;
}
#pragma mark ------------ getter Mothed ------------
- (UILabel *)contentLabel{
    
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.text = @"03";
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = self.selectColor;
        _contentLabel.font = FONT_SCALE(17);
        _contentLabel.layer.cornerRadius = __SCALE(17);
        _contentLabel.layer.masksToBounds = YES;
        _contentLabel.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
        _contentLabel.layer.borderWidth = .6f;
        _contentLabel.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _contentLabel;
}
- (UIImageView *)backgroundImageView{
    
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroundImageView.image = [UIImage imageNamed:@"de_ClickImage.png"];
        _backgroundImageView.hidden = YES;
    }
    return _backgroundImageView;
}

#pragma mark - 封装系统动画
//添加位移动画
- (CAAnimation*)createPositionAnimateDuration:(NSTimeInterval)duration
                                positionValus:(NSArray*)valus
                              timingFunctions:(NSArray*)timingFunctions
                                    beginTime:(CFTimeInterval)beginTime
{
    CAKeyframeAnimation* positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = valus;
    positionAnimation.duration = duration;
    positionAnimation.beginTime = beginTime;
    positionAnimation.removedOnCompletion = NO;
    positionAnimation.fillMode = kCAFillModeForwards;
    positionAnimation.repeatCount = 1;
    if (timingFunctions && timingFunctions.count > 0) {
        positionAnimation.timingFunctions = timingFunctions;
    }
    return positionAnimation;
}
//添加形变动画
- (CAAnimation*)createScaleAnimateDuration:(NSTimeInterval)duration
                            timingFunction:(CAMediaTimingFunction*)timingFunction
                                        sx:(CGFloat)x
                                        sy:(CGFloat)y
                                        sz:(CGFloat)z
                                 beginTime:(CFTimeInterval)beginTime{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
    //动画结束值
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(x, y, z)];
    scaleAnimation.duration = duration;
    scaleAnimation.beginTime = beginTime;
    if (timingFunction) {
        scaleAnimation.timingFunction = timingFunction;
    }
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.keyPath = @"transform";
    return scaleAnimation;
}
//添加组动画
- (CAAnimationGroup *)addAnimateGruopWithanimations:(NSArray*)animations
                                           duration:(NSTimeInterval)duration
{
    CAAnimationGroup *animateGroup = [CAAnimationGroup animation];
    animateGroup.animations = animations;
    animateGroup.duration = duration;
    animateGroup.removedOnCompletion = NO;
    animateGroup.fillMode = kCAFillModeForwards;
    return animateGroup;
}

@end
