//
//  CLDLTNormalBetView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLDLTNormalBetView.h"
#import "CLOneGroupBallView.h"
#import "CLConfigMessage.h"
#import "CLShowHUDManager.h"

#import "CLLotteryBallView.h"
#import "AppDelegate.h"
#import "CLTools.h"

#import "CLTwoImageButton.h"
#import "CLLotteryActivitiesModel.h"
#import "CLNativePushService.h"
#import "UIImageView+CQWebImage.h"

@interface CLDLTNormalBetView ()
{
    NSInteger __randomAnimationIndex;
}

@property (nonatomic, strong) CLOneGroupBallView *redBallView;//红球
@property (nonatomic, strong) CLOneGroupBallView *blueBallView;//蓝球
@property (nonatomic, strong) UIButton *shakeButton;//摇一摇
@property (nonatomic, strong) CLTwoImageButton *activityButton;
@property (nonatomic, strong) NSString *activityUrl;
@property (nonatomic, strong) UILabel *infoLabel;//说明label
@property (nonatomic, strong) NSMutableArray *randomAnimationArray;
@end

@implementation CLDLTNormalBetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.shakeButton];
        [self addSubview:self.activityButton];
        [self addSubview:self.infoLabel];
        [self addSubview:self.redBallView];
        [self addSubview:self.blueBallView];
        [self configConstraint];
    }
    return self;
}

#pragma mark ------------ public Mothed ------------
#pragma mark - 配置默认数据
- (void)assignDefaultData:(CLDLTNormalBetTerm *)betTerm{
    
    for (NSString *tag in betTerm.redArray) {
        [self.redBallView selectBetButtonWithTag:[tag integerValue]];
    }
    
    for (NSString *tag in betTerm.blueArray) {
        [self.blueBallView selectBetButtonWithTag:[tag integerValue]];
    }
}
#pragma mark - 清空所有
- (void)ssq_normalClearAll{
    
    [self.redBallView clearAllBet];
    [self.blueBallView clearAllBet];
}
#pragma mark - 机选
- (void)ssq_randomSelectBall{
    
    
    [self.randomAnimationArray removeAllObjects];
    [self.randomAnimationArray addObjectsFromArray:[self.redBallView randomSelectNumberWithArray:[CLTools randomArrayWithCount:5 maxNumber:35]]];
    [self.randomAnimationArray addObjectsFromArray:[self.blueBallView randomSelectNumberWithArray:[CLTools randomArrayWithCount:2 maxNumber:12]]];
    [self startRandomAnimation];
}
#pragma mark - 刷新注数
- (void)refreshNote{
    
    self.ssq_normalCallBackNoteBonusBlock ? self.ssq_normalCallBackNoteBonusBlock(self.betTerm.minBetBonus, self.betTerm.MaxBetBonus, self.betTerm.betNote, (self.betTerm.redArray.count > 0 || self.betTerm.blueArray.count > 0)) : nil;
}
#pragma mark - 配置遗漏
- (void)assignOmissionDataWithRed:(NSArray *)redArray blue:(NSArray *)blueArray{
    
    [self.redBallView assignOmissionData:redArray];
    [self.blueBallView assignOmissionData:blueArray];
}
#pragma mark - 隐藏遗漏
- (void)hiddenOmission:(BOOL)hidden{
    
    [self.redBallView hiddenOmissionView:hidden];
    [self.blueBallView hiddenOmissionView:hidden];
    [self.redBallView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.infoLabel.mas_bottom).offset(__SCALE(20.f));
        make.left.right.equalTo(self);
        make.height.mas_equalTo([self.redBallView getOneGroupBallVeiwHeightWithCount:35]);
    }];
    
    [self.blueBallView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.infoLabel.mas_bottom).offset(__SCALE(20.f) + __SCALE(25.f) + [self.redBallView getOneGroupBallVeiwHeightWithCount:35]);
        make.left.right.equalTo(self);
        make.height.mas_equalTo([self.blueBallView getOneGroupBallVeiwHeightWithCount:12]);
        make.bottom.lessThanOrEqualTo(self).offset(__SCALE(-10.f));
    }];
}
#pragma mark - 配置活动链接
- (void)assignActicityLink:(id)data{
    
    CLLotteryActivitiesModel *model = data;
    if (model.activityImgUrl && model.activityImgUrl.length > 0) {
        
        if ([model.activityImgUrl hasPrefix:@"http"]) {
            
            [self.activityButton.mainImageView setImageWithURL:[NSURL URLWithString:model.activityImgUrl]];
            [self.activityButton setTitle:@"" forState:UIControlStateNormal];
            [self.activityButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self).offset(__SCALE(0.f));
                make.right.equalTo(self);
                make.height.equalTo(self.activityButton.mas_width).multipliedBy(11.0 / 26);
                make.width.mas_equalTo(__SCALE(130.f));
            }];
            [self.activityButton assignMianImageViewHidden:NO];
        }else{
            [self.activityButton setTitle:model.activityImgUrl forState:UIControlStateNormal];
            
            [self.activityButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.equalTo(self.shakeButton);
                make.right.equalTo(self).offset(__SCALE(-20.f));
            }];
            [self.activityButton assignMianImageViewHidden:YES];
        }
        self.activityUrl = model.activityUrl;
        self.activityButton.hidden = NO;
    }else{
        self.activityButton.hidden = YES;
    }
}
#pragma mark ------------ private Mothed ------------
- (void)configConstraint{
    
    [self.shakeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.top.equalTo(self).offset(__SCALE(14.f));
        make.width.mas_equalTo(__SCALE(101));
        make.height.mas_equalTo(__SCALE(30));
    }];
    
    [self.activityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(__SCALE(- 20.f));
        make.centerY.equalTo(self.shakeButton);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(10.f));
        make.top.equalTo(self.shakeButton.mas_bottom).offset(__SCALE(15.f));
    }];
    
    [self.redBallView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.infoLabel.mas_bottom).offset(__SCALE(20.f));
        make.left.right.equalTo(self);
        make.height.mas_equalTo([self.redBallView getOneGroupBallVeiwHeightWithCount:35]);
    }];
    
    [self.blueBallView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.infoLabel.mas_bottom).offset(__SCALE(20.f) + __SCALE(25.f) + [self.redBallView getOneGroupBallVeiwHeightWithCount:35]);
        make.left.right.equalTo(self);
        make.height.mas_equalTo([self.blueBallView getOneGroupBallVeiwHeightWithCount:12]);
        make.bottom.lessThanOrEqualTo(self).offset(__SCALE(-10.f));
    }];
}
#pragma mark - 执行随机动画
- (void)startRandomAnimation{
    WS(_weakSelf)
    for (CLLotteryBallView *betBtn in self.randomAnimationArray) {
        betBtn.animationStopBlock = ^(){
            
            [_weakSelf preBetViewAnimationStop];
        };
    }
    __randomAnimationIndex = 0;
    if (self.randomAnimationArray.count > __randomAnimationIndex) {
        //关闭屏幕点击事件触发
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.userInteractionEnabled = NO;
        
        ((CLLotteryBallView *)self.randomAnimationArray[__randomAnimationIndex]).randomAnimation = YES;
        ((CLLotteryBallView *)self.randomAnimationArray[__randomAnimationIndex]).selected = YES;
        __randomAnimationIndex++;
    }
}
#pragma mark - 上一次动画执行结束
- (void)preBetViewAnimationStop{
    
    if (self.randomAnimationArray.count > __randomAnimationIndex) {
        ((CLLotteryBallView *)self.randomAnimationArray[__randomAnimationIndex]).randomAnimation = YES;
        ((CLLotteryBallView *)self.randomAnimationArray[__randomAnimationIndex]).selected = YES;
        __randomAnimationIndex++;
    }else{
        //打开屏幕点击事件触发
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.userInteractionEnabled = YES;
    }
}
#pragma mark ------------ event Response ------------
- (void)shakeButtonOnClick:(UIButton *)button{
    
    [self ssq_randomSelectBall];
}
- (void)selectRedBall:(CLLotteryBallView *)button{
    
    NSString *betStr = [NSString stringWithFormat:@"%02zi", button.tag];
    if (button.selected) {
        
        if ([self.betTerm.redArray indexOfObject:betStr] == NSNotFound) {
            [self.betTerm.redArray addObject:betStr];
        }
    }else{
        
        if ([self.betTerm.redArray indexOfObject:betStr] != NSNotFound) {
            [self.betTerm.redArray removeObject:betStr];
        }
    }
    
    self.ssq_normalCallBackNoteBonusBlock ? self.ssq_normalCallBackNoteBonusBlock(self.betTerm.minBetBonus, self.betTerm.MaxBetBonus, self.betTerm.betNote, (self.betTerm.redArray.count > 0 || self.betTerm.blueArray.count > 0)) : nil;
}
- (void)selectBlueBall:(CLLotteryBallView *)button{
    
    NSString *betStr = [NSString stringWithFormat:@"%02zi", button.tag];
    if (button.selected) {
        
        if ([self.betTerm.blueArray indexOfObject:betStr] == NSNotFound) {
            [self.betTerm.blueArray addObject:betStr];
        }
    }else{
        
        if ([self.betTerm.blueArray indexOfObject:betStr] != NSNotFound) {
            [self.betTerm.blueArray removeObject:betStr];
        }
    }
    self.ssq_normalCallBackNoteBonusBlock ? self.ssq_normalCallBackNoteBonusBlock( self.betTerm.minBetBonus, self.betTerm.MaxBetBonus,self.betTerm.betNote,(self.betTerm.redArray.count > 0 || self.betTerm.blueArray.count > 0)) : nil;
}
- (void)activityButtonOnClick:(UIButton *)btn{
    
    [CLNativePushService pushNativeUrl:self.activityUrl];
}
#pragma mark ------------ getter Mothed ------------
- (UIButton *)shakeButton{
    
    if (!_shakeButton) {
        _shakeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_shakeButton addTarget:self action:@selector(shakeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_shakeButton setBackgroundImage:[UIImage imageNamed:@"DE_shakeImage.png"] forState:UIControlStateNormal];
    }
    return _shakeButton;
}
- (CLTwoImageButton *)activityButton{
    
    if (!_activityButton) {
        _activityButton = [[CLTwoImageButton alloc] init];
        _activityButton.hidden = YES;
//        [_activityButton setTitle:@"史无前例大加奖" forState:UIControlStateNormal];
        [_activityButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        _activityButton.titleLabel.font = FONT_SCALE(14);
        _activityButton.leftImage = [UIImage imageNamed:@"de_star.png"];
        _activityButton.rightImage = [UIImage imageNamed:@"de_arrow.png"];
        [_activityButton addTarget:self action:@selector(activityButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _activityButton;
}
- (UILabel *)infoLabel{
    
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabel.textColor = UIColorFromRGB(0x333333);
        _infoLabel.font = FONT_SCALE(14);
        _infoLabel.text = @"请至少选择5个红球和2个蓝球";
    }
    return _infoLabel;
}
- (CLOneGroupBallView *)redBallView{
    
    WS(_weakSelf)
    if (!_redBallView) {
        _redBallView = [[CLOneGroupBallView alloc] initWithFrame:CGRectZero ballCount:35 ballColor:UIColorFromRGB(0xd90000)];
        _redBallView.selectStateChangeBlock = ^(CLLotteryBallView *button){
            
            [_weakSelf selectRedBall:button];
        };
    }
    return _redBallView;
}
- (CLOneGroupBallView *)blueBallView{
    
    WS(_weakSelf)
    if (!_blueBallView) {
        _blueBallView = [[CLOneGroupBallView alloc] initWithFrame:CGRectZero ballCount:12 ballColor:UIColorFromRGB(0x295fcc)];
        _blueBallView.selectStateChangeBlock = ^(CLLotteryBallView *button){
            
            [_weakSelf selectBlueBall:button];
        };
    }
    return _blueBallView;
}

- (CLDLTNormalBetTerm *)betTerm{
    
    if (!_betTerm) {
        _betTerm = [[CLDLTNormalBetTerm alloc] init];
    }
    return _betTerm;
}
- (NSMutableArray *)randomAnimationArray{
    
    if (!_randomAnimationArray) {
        _randomAnimationArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _randomAnimationArray;
}

@end
