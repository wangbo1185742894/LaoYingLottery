//
//  CQMarqueeView.m
//  caiqr
//
//  Created by huangyuchen on 16/9/1.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQMarqueeView.h"
#import "CQDefinition.h"
#import "CQBasicAnimation.h"
#import "CLConfigMessage.h"

#define TimerTime 3.5f
#define AnimationTime .5f
@interface CQMarqueeView ()<CAAnimationDelegate>{
    NSInteger _textCount;//记录现在显示到多少条数据
    NSTimer *_marqueeTimer;
}
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *hornImageView;
@property (nonatomic, strong) UIImageView *arrowsImageView;
@property (nonatomic, strong) CAAnimation *marqueeAnimation;

@end

@implementation CQMarqueeView

+ (instancetype)shareMarqueeViewWithFrame:(CGRect)frame{
    
    static CQMarqueeView *view = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        view = [[CQMarqueeView alloc] initWithFrame:frame];
    });
    return view;
}
#pragma mark - 重载init方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor lightGrayColor];
        _textCount = 0;
        [self addSubview:self.mainView];
        [self.mainView addSubview:self.bottomLabel];
        [self.mainView addSubview:self.topLabel];
        [self addSubview:self.hornImageView];
        [self addSubview:self.arrowsImageView];
        self.textArray = [NSMutableArray new];
        [self addTapGestureRecognizer];
        [self addSubContraint];
    }
    return self;
}

#pragma mark - eventRespone
//定时器响应时间
- (void)marqueeTimerOnChange:(NSTimer *)timer{
    
    //添加动画动画
    NSValue *value1 = [NSValue valueWithCGPoint:self.mainView.layer.position];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(self.mainView.layer.position.x, 0)];
    ((CAKeyframeAnimation *)self.marqueeAnimation).values = @[value1, value2];
    [self.mainView.layer addAnimation:self.marqueeAnimation forKey:@"Marquee"];
    if (_textCount < (self.textArray.count - 1)) {
        self.bottomLabel.text = self.textArray[_textCount + 1];
        _textCount++;
    }else{
        self.bottomLabel.text = self.textArray[0];
        _textCount = 0;
    }
//    NSLog(@"定时依然存在");
}
//点击事件
- (void)tapOnCLick:(UITapGestureRecognizer *)tap{
    
    if (self.tapOnClickBlock) {
        self.tapOnClickBlock(_textCount);
    }
    
}
#pragma mark - privateMothed
//添加约束
- (void)addSubContraint{
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hornImageView.mas_right);
        make.top.equalTo(self);
        make.right.equalTo(self.arrowsImageView.mas_left);
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mainView);
        make.height.equalTo(self);
        make.left.equalTo(self.mainView).offset(__SCALE(6.f));
        make.right.equalTo(self.arrowsImageView.mas_left).priorityHigh();
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topLabel);
        make.height.equalTo(self);
        make.top.equalTo(self.topLabel.mas_bottom);
        make.right.equalTo(self.arrowsImageView.mas_left).priorityHigh();
        make.bottom.equalTo(self.mainView);
        
    }];
    [self.hornImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(CL__SCALE(10.f));
        make.centerY.equalTo(self);
        make.width.mas_equalTo(CL__SCALE(30.f));
        make.height.mas_equalTo(CL__SCALE(15.f));
    }];
    [self.arrowsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(__SCALE(- 9.f));
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(__SCALE(11.f));
        
    }];
    
}
//添加点击手势
- (void)addTapGestureRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnCLick:)];
    [self addGestureRecognizer:tap];
}
#pragma mark - animation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if (_textCount < (self.textArray.count)) {
        self.topLabel.text = self.textArray[_textCount];
    }else{
        self.topLabel.text = self.textArray[0];
    }
    
    [self.mainView.layer removeAllAnimations];
    
//    NSLog(@"动画依然存在");
}

#pragma mark - setterMothed
- (void)setTextArray:(NSMutableArray *)textArray{
    //判断数据是否更新了，若更新则_textCount变成0  未更新，则_textCount 不变
    if (![_textArray isEqualToArray:textArray]) {
        _textCount = 0;
    }
    _textArray = textArray;
    self.marqueeAutoLoop = YES;
    if (_textArray.count < 1) {
        //没有数据
        self.marqueeAutoLoop = NO;
    }else if (_textArray.count == 1){
        //数据只有1条
        self.topLabel.text = _textArray[_textCount];
        self.marqueeAutoLoop = NO;
    }else{
        self.topLabel.text = _textArray[_textCount];
    }
}
- (void)setMarqueeAutoLoop:(BOOL)marqueeAutoLoop{
    
    _marqueeAutoLoop = marqueeAutoLoop;
    if (_marqueeAutoLoop)
    {
        //开启自动滚动
        if (!_marqueeTimer) {
            NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:TimerTime target:self selector:@selector(marqueeTimerOnChange:) userInfo:nil repeats:YES];
            _marqueeTimer = timer;
            timer = nil;
        }
    }
    else
    {
        //关闭自动滚动
        if (_marqueeTimer) {
            [_marqueeTimer invalidate];
            _marqueeTimer = nil;
            
        }
    }
}

- (void)setHiddenRightArrow:(BOOL)hiddenRightArrow
{
    self.arrowsImageView.hidden = hiddenRightArrow;
}

- (void)setMarqueeIMG:(UIImage *)marqueeIMG
{
    self.hornImageView.image = marqueeIMG;
}

#pragma mark - getterMothed
- (UIImageView *)hornImageView{
    if (!_hornImageView) {
        _hornImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _hornImageView.image = [UIImage imageNamed:@"HomeNotice.png"];
    }
    return _hornImageView;
}
- (UIImageView *)arrowsImageView{
    if (!_arrowsImageView) {
        _arrowsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _arrowsImageView.image = [UIImage imageNamed:@"homeNextPage.png"];
    }
    
    return _arrowsImageView;
}
- (UIView *)mainView{
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _mainView;
}
- (UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _topLabel.textAlignment = NSTextAlignmentLeft;
        _topLabel.textColor = UIColorFromRGB(0x666666);
        [_topLabel setContentHuggingPriority:0 forAxis:UILayoutConstraintAxisHorizontal];
        [_topLabel setContentCompressionResistancePriority:0 forAxis:UILayoutConstraintAxisHorizontal];
        _topLabel.font = FONT_SCALE(11);
    }
    return _topLabel;
}
- (UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bottomLabel.textColor = UIColorFromRGB(0x666666);
        _bottomLabel.textAlignment = NSTextAlignmentLeft;
        [_bottomLabel setContentHuggingPriority:0 forAxis:UILayoutConstraintAxisHorizontal];
        [_bottomLabel setContentCompressionResistancePriority:0 forAxis:UILayoutConstraintAxisHorizontal];
        _bottomLabel.font = FONT_SCALE(11);
    }
    return _bottomLabel;
}
- (CAAnimation *)marqueeAnimation{
    
    if (!_marqueeAnimation) {
        NSValue *value1 = [NSValue valueWithCGPoint:self.mainView.layer.position];
        NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(self.mainView.layer.position.x, - self.frame.size.height)];
        _marqueeAnimation = [CQBasicAnimation createPositionAnimateDuration:AnimationTime positionValus:@[value1, value2] timingFunctions:nil beginTime:0];
        _marqueeAnimation.delegate = self;
        _marqueeAnimation.repeatCount = 1;
    }
    return _marqueeAnimation;
}

@end
