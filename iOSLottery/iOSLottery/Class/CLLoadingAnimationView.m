//
//  CLLoadingAnimationView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLoadingAnimationView.h"
#import "CLConfigMessage.h"
#import "CLTools.h"
@interface CLLoadingAnimationView ()

@property (nonatomic, strong) CALayer *refreshLayer;
@property (nonatomic, assign) CLLoadingAnimationType loadingType;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end
@implementation CLLoadingAnimationView

+ (CLLoadingAnimationView *)shareLoadingAnimationView{
    
    static CLLoadingAnimationView *view = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        view = [[CLLoadingAnimationView alloc] init];
    });
    
    return view;
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        
//        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}
#pragma mark ------------ public Mothed ------------
- (void)showLoadingAnimationWithView:(UIView *)superView type:(CLLoadingAnimationType)loadingType{
    
    [self removeFromSuperview];
    self.frame = superView.bounds;
    self.loadingType = loadingType;
    
    switch (loadingType) {
        case CLLoadingAnimationTypeNormal:{
            //使用系统默认菊花
            [self useSystemActivityView];
        }
            break;
            
        case CLLoadingAnimationTypeGrayCircle:{
            
            self.refreshLayer.position = self.center;
            [self.layer addSublayer:self.refreshLayer];
            self.refreshLayer.contents = (id)[UIImage imageNamed:@"grayloading.png"].CGImage;
            [self startAnimating];
        }
            break;
        default:
            break;
    }
    
    [superView addSubview:self];
    [superView bringSubviewToFront:self];
}
- (void)showLoadingAnimationInCurrentViewControllerWithType:(CLLoadingAnimationType)loadingType{
    
    UIViewController *viewController = [CLTools getCurrentViewController];
    [self showLoadingAnimationWithView:viewController.view type:loadingType];
}
- (void)stop{
    
    switch (self.loadingType) {
        case CLLoadingAnimationTypeNormal:{
            [self.activityView stopAnimating];
            [self removeFromSuperview];
        }
            break;
        case CLLoadingAnimationTypeGrayCircle:{
            [self stopAnimating];
            [self removeFromSuperview];
        }
            break;
        default:
            break;
    }

    
}
#pragma mark ------------ private Mothed ------------
#pragma mark - 使用系统默认菊花
- (void)useSystemActivityView{
    
    [self.activityView startAnimating];
}

#pragma mark ------------ getter Mothed ------------

- (CALayer *)refreshLayer
{
    if (!_refreshLayer) {
        _refreshLayer = [[CALayer alloc] init];
        
        _refreshLayer.frame = CGRectMake(0, 0, 19, 19);
        
    }
    return _refreshLayer;
}

- (UIActivityIndicatorView *)activityView{
    
    if (!_activityView) {
        
        _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //设置菊花的中心点，不能设置菊花的大小，系统自带的有三种样式
        _activityView.center = self.center;
        //添加菊花
        [self addSubview:_activityView];
        
        //菊花 停止时隐藏
        [_activityView setHidesWhenStopped:YES];
    }
    return _activityView;
}
#pragma mark ------------ animtioning ------------
- (void)startAnimating
{
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 22.0 ];
    rotationAnimation.duration = 6.f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100000;
    
    [self.refreshLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimating
{
    [self.refreshLayer removeFromSuperlayer];
    [self.refreshLayer removeAnimationForKey:@"rotationAnimation"];
}

@end
