//
//  CLDiceAnimation.m
//  animationKuaiSan
//
//  Created by huangyuchen on 2016/11/4.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLDiceAnimationView.h"
#import "AppDelegate.h"
#import "CLConfigMessage.h"
#import "CLTools.h"
@interface CLDiceAnimationView ()<CAAnimationDelegate>

@property (nonatomic, strong) NSMutableArray *diceImageViewArray;//骰子imageView的数组

@end
@implementation CLDiceAnimationView

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 开启摇骰子的动画
- (void)startShakeDiceAnimation{
    NSCAssert([self verifyDataIsRight], @"配置摇骰子的参数不正确");
    if ([self verifyDataIsRight]) {
        //手机振动
        [CLTools vibrate];
        //关闭屏幕点击事件触发
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.userInteractionEnabled = NO;
        //发送动画开启的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:FT_ShakeAnimationStart object:nil userInfo:nil];
        [self.diceImageViewArray removeAllObjects];
        [self configImageView];
        [self addFastThreeAnimation];
    }
}
#pragma mark - 校验数据正确性
- (BOOL)verifyDataIsRight{
    //点数数组是否存在
    if (!(self.diceNumberArray && self.diceNumberArray.count > 0)) {
        return NO;
    }
    if (!(self.diceFinishPointArray && self.diceFinishPointArray.count > 0)) {
        return NO;
    }
    //点数数组个数是否是3
    if (self.diceNumberArray.count != self.diceFinishPointArray.count) {
        return NO;
    }
    if (self.diceNumberArray.count > 4) {
        return NO;
    }
    if (self.diceFinishPointArray.count > 4) {
        return NO;
    }
    return YES;
}
#pragma mark - 实例化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
#pragma mark ------ 开始配置骰子的图片组（模拟骰子转动） ------
#pragma mark - 配置骰子的图片组
- (void)configImageView{
    for (NSInteger i = 0; i < self.diceFinishPointArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 83, 83)];
        imageView.animationImages = [self getImageViewRandomImageArray];
        [self addSubview:imageView];
        [self.diceImageViewArray addObject:imageView];
    }
}
#pragma mark - 返回一组随机图片 （模拟骰子转动）
- (NSArray *)getImageViewRandomImageArray{
    
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 4; i++) {
        NSInteger index = arc4random() % 4 + 1;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_f%zi.png", index]];
        if ([imageArr indexOfObject:image] != NSNotFound) {
            i = i-1;
        }else{
            [imageArr addObject:image];
        }
    }
    NSMutableArray *array = [NSMutableArray arrayWithArray:imageArr];
    [array addObjectsFromArray:imageArr];
    [array addObjectsFromArray:imageArr];
    [array addObjectsFromArray:imageArr];
    return array;
}
#pragma mark ------ 开始配置骰子动画 ------
#pragma mark - 添加摇骰子动画
- (void)addFastThreeAnimation{
    NSArray *endPointValueArray = [self getEndPointValueWithDiceNumber:self.diceImageViewArray.count];
    for (NSInteger i = 0; i < self.diceImageViewArray.count; i++) {
        UIImageView *imageView = self.diceImageViewArray[i];
        //开启imageView自带动画
        [self starImageViewAnimationWithImageView:imageView];
        //位移动画
        NSValue *endValue = endPointValueArray[i];
        NSValue *finishValue = self.diceFinishPointArray[i];
        [self addOneGroupAnimationWithImageView:imageView endPoint:endValue finishValue:finishValue];
    }
}
#pragma mark - 开启imageView的帧动画
- (void)starImageViewAnimationWithImageView:(UIImageView *)imageView{
    imageView.animationDuration = .5f;
    imageView.animationRepeatCount = 0;
    [imageView startAnimating];
}
#pragma mark - 给一个imageView添加一组动画
- (void)addOneGroupAnimationWithImageView:(UIImageView *)imageView endPoint:(NSValue *)endPointValue finishValue:(NSValue *)finishPointValue{
    
    NSMutableArray *animationArray = [[NSMutableArray alloc] initWithArray:[self getRandomPointValue]];
    [animationArray addObject:endPointValue];
    CAAnimation *shakeAnimation = [self createPositionAnimateDuration:1.f positionValus:animationArray timingFunctions:nil beginTime:0];
    shakeAnimation.delegate = self;
    [imageView.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
    CAAnimation *positionAnimtation = [self createPositionAnimateDuration:.5f positionValus:@[endPointValue, finishPointValue] timingFunctions:nil beginTime:1.5f];
    CAAnimation *scaleAnimation = [self createScaleAnimateDuration:0.5f timingFunction:nil sx:0.5 sy:0.5 sz:1 beginTime:1.5];
    CAAnimation *animationGroup = [self addAnimateGruopWithanimations:@[positionAnimtation, scaleAnimation] duration:2.0f];
    animationGroup.delegate = self;
    [imageView.layer addAnimation:animationGroup forKey:@"animationGroup"];
    
}
#pragma mark - 返回随机 动画移动点
- (NSArray *)getRandomPointValue{
    
    NSMutableArray *pointValueArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 4; i++) {
        [pointValueArray addObject:[NSValue valueWithCGPoint:CGPointMake(arc4random() % 200 + 100, arc4random() % 200 + 100)]];
    }
    return pointValueArray;
}
#pragma mark - 获取imageView摇骰子停止后的endPoint（缩放动画之前的定点）
- (NSArray *)getEndPointValueWithDiceNumber:(NSInteger)diceNumber{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    switch (diceNumber) {
        case 3:
            [array addObjectsFromArray:@[[NSValue valueWithCGPoint:CGPointMake(120, 280)], [NSValue valueWithCGPoint:CGPointMake(200, 220)],[NSValue valueWithCGPoint:CGPointMake(280, 280)]]];
            break;
        case 2:
            [array addObjectsFromArray:@[[NSValue valueWithCGPoint:CGPointMake(100, 200)], [NSValue valueWithCGPoint:CGPointMake(300, 200)]]];
            break;
        case 1:
            [array addObjectsFromArray:@[[NSValue valueWithCGPoint:CGPointMake(100, 200)]]];
            break;
        case 4:
            [array addObjectsFromArray:@[[NSValue valueWithCGPoint:CGPointMake(100, 200)], [NSValue valueWithCGPoint:CGPointMake(200, 200)], [NSValue valueWithCGPoint:CGPointMake(100, 400)], [NSValue valueWithCGPoint:CGPointMake(200, 400)]]];
            break;
        default:
            break;
    }
    return array;
}
#pragma mark - 动画结束  CAAnimationDeleagte
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (self.diceImageViewArray.count == 0) {
        return;
    }
    if ([((UIImageView *)self.diceImageViewArray[0]).layer animationForKey:@"shakeAnimation"] == anim) {
        //动画结束
        for (NSInteger i = 0; i < self.diceImageViewArray.count; i++) {
            UIImageView *imageView = self.diceImageViewArray[i];
            [imageView stopAnimating];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice%@", self.diceNumberArray[i]]];
        }
    }
    if ([((UIImageView *)self.diceImageViewArray[0]).layer animationForKey:@"animationGroup"] == anim) {
        for (UIImageView *imageView in self.diceImageViewArray) {
            [imageView.layer removeAllAnimations];
            [imageView removeFromSuperview];
        }
        //打开屏幕点击事件触发
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.userInteractionEnabled = YES;
        if ([self.delegate respondsToSelector:@selector(diceAnimationDidStop)]) {
            [self.delegate diceAnimationDidStop];
        }
    }
}

#pragma mark - getterMothed
- (NSMutableArray *)diceImageViewArray{
    if (!_diceImageViewArray) {
        _diceImageViewArray = [[NSMutableArray alloc] init];
    }
    return _diceImageViewArray;
}
- (NSMutableArray<NSString *> *)diceNumberArray{
    
    if (!_diceNumberArray) {
        _diceNumberArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _diceNumberArray;
}
- (NSMutableArray<NSValue *> *)diceFinishPointArray{
    
    if (!_diceFinishPointArray) {
        _diceFinishPointArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _diceFinishPointArray;
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
