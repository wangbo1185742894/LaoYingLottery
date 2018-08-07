//
//  CLRefreshHeaderCustomView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLRefreshHeaderCustomView.h"

#define CQRefreshHW 19.f
#define CQRefreshContentImgHW 19.f

@interface CLRefreshHeaderCustomView ()

@property (nonatomic, strong) UIImageView *contentImgView;
@property (nonatomic, strong) CALayer *refreshLayer;

@end

@implementation CLRefreshHeaderCustomView

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.bounds = CGRectMake(0, 0, CQRefreshHW, CQRefreshHW);
        self.contentImgView.image = [UIImage imageNamed:@"grayloading"];
        //        self.hidden = YES;
        [self addSubview:self.contentImgView];
        [self.layer insertSublayer:self.refreshLayer above:self.contentImgView.layer];
    }
    return self;
}

- (void)setContentTransFormValue:(CGAffineTransform)contentTransFormValue
{
    self.contentImgView.transform = contentTransFormValue;
}
- (void)setCustomViewStyle:(CLRefreshCustomViewStyle)customViewStyle{
    
    self.contentImgView.image = [UIImage imageNamed:(customViewStyle == CLRefreshCustomViewStyleBlue)?@"grayloading":@"grayloading"];
}

- (UIImageView *)contentImgView
{
    if (!_contentImgView) {
        _contentImgView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _contentImgView;
}

- (CALayer *)refreshLayer
{
    if (!_refreshLayer) {
        _refreshLayer = [[CALayer alloc] init];
        CGFloat refreshLayerWH = (CQRefreshHW - CQRefreshContentImgHW) * .5f;
        _refreshLayer.frame = CGRectMake(refreshLayerWH, refreshLayerWH, CQRefreshContentImgHW, CQRefreshContentImgHW);
    }
    return _refreshLayer;
}

- (void)startAnimating
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 22.0 ];
    rotationAnimation.duration = 5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100000;
    
    [self.contentImgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimating
{
    [self.contentImgView.layer removeAnimationForKey:@"rotationAnimation"];
}

@end
