//
//  CLLaunchActivityView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/4/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLaunchActivityView.h"
#import "CLConfigMessage.h"
#import "CQmyproxy.h"
#import "CLNativePushService.h"
#import "CLLaunchActivityManager.h"
#import "CLFirstStartModel.h"
#import "CLNotificationUtils.h"
@interface CLLaunchActivityView ()

@property (nonatomic, strong) UIImageView *activityImageView;
@property (nonatomic, strong) UIImageView *bottomImageView;

@property (nonatomic, strong) UIButton *closeButton;//关闭按钮
@property (nonatomic, strong) UILabel *closeLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) CLLaunchActivityModel *launchModel;

@end


@implementation CLLaunchActivityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        [self addSubview:self.activityImageView];
        [self addSubview:self.bottomImageView];
        [self addSubview:self.closeButton];
        [self.closeButton addSubview:self.closeLabel];
        [self.closeButton addSubview:self.timeLabel];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActivityView:)];
        [self addGestureRecognizer:tap];
        [self configConstraint];
        [self assignData];
        //注册倒计时通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeCutDown:) name:GlobalTimerRuning object:nil];
    }
    return self;
}

#pragma mark ------------ private Mothed ------------
- (void)configConstraint{
    
    [self.activityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.bottomImageView.mas_top);
    }];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(__SCALE(70.f));
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(__SCALE(20.f));
        make.right.equalTo(self).offset(__SCALE(-20.f));
        make.height.mas_equalTo(__SCALE(20.f));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.closeButton).offset(__SCALE(10.f));
        make.centerY.equalTo(self.closeButton);
    }];
    
    [self.closeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.timeLabel.mas_right).offset(__SCALE(3.f));
        make.centerY.equalTo(self.closeButton);
        make.right.equalTo(self.closeButton).offset(__SCALE(-10.f));
    }];
}
- (void)assignData{
    
    self.launchModel = [CLLaunchActivityManager getLaunchActivityImageData];
    if (self.launchModel) {
        self.time = self.launchModel.cutDownTime;
        self.activityImageView.image = self.launchModel.downloadImage;
    }else{
        self.time = 5;
        self.activityImageView.image = [UIImage imageNamed:@"launchImageTop"];
    }
    
}
#pragma mark ------------ event Response ------------
- (void)timeCutDown:(NSNotification *)noti{
    
    self.timeLabel.text = [NSString stringWithFormat:@"%zi", self.time--];
    if (self.time == 0) {
        [self closeSelfWithBlock:nil];
    }
}
- (void)closeButtonOnClick:(UIButton *)btn{
    
    [self closeSelfWithBlock:nil];
}
- (void)tapActivityView:(UITapGestureRecognizer *)tap{
    
    WS(_weakSelf)
    [self closeSelfWithBlock:^{
        if (_weakSelf.launchModel && _weakSelf.launchModel.contentUrl && _weakSelf.launchModel.contentUrl.length > 0) {
            [CLNativePushService pushNativeUrl:_weakSelf.launchModel.contentUrl];
        }
    }];
}

- (void)closeSelfWithBlock:(void (^)())complete{
    
    static BOOL isClose = YES;
    if (isClose) {
        isClose = NO;
        [UIView animateWithDuration:1.f animations:^{
            
            self.alpha = 0;
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
            //发送关闭通知
            [[NSNotificationCenter defaultCenter] postNotificationName:CLLaunchActivityViewClose object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            //[[CQmyproxy dealerProxy] alterClosed:NSStringFromClass([self class])];
            
            !complete ? : complete();
        }];
    }
}

#pragma mark ------------ getter Mothed ------------
- (UIImageView *)activityImageView{
    
    if (!_activityImageView) {
        _activityImageView = [[UIImageView alloc] init];
        _activityImageView.contentMode = UIViewContentModeScaleAspectFill;
        _activityImageView.userInteractionEnabled = YES;
    }
    return _activityImageView;
}
- (UIImageView *)bottomImageView{
    
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] init];
        _bottomImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.image = [UIImage imageNamed:@"launchImageBottom.png"];
    }
    return _bottomImageView;
}

- (UIButton *)closeButton{
    
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        _closeButton.backgroundColor = UIColorFromRGBandAlpha(0x333333, 0.75f);
        _closeButton.layer.cornerRadius = __SCALE(10.f);
        [_closeButton addTarget:self action:@selector(closeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (UILabel *)closeLabel{
    
    if (!_closeLabel) {
        _closeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _closeLabel.text = @"关闭";
        _closeLabel.textColor = UIColorFromRGB(0xffffff);
        _closeLabel.font = FONT_SCALE(13);
    }
    return _closeLabel;
}
- (UILabel *)timeLabel{
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.text = [NSString stringWithFormat:@"%zi", self.time];
        _timeLabel.textColor = UIColorFromRGB(0xffffff);
        _timeLabel.font = FONT_SCALE(13);
    }
    return _timeLabel;
}

@end
