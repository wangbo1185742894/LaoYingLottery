//
//  CLQLCMainBetView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/16.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLQLCMainBetView.h"

#import "CLConfigMessage.h"

#import "UILabel+CLAttributeLabel.h"

#import "CLATBetOptionsView.h"
#import "CLQLCBetOptionsView.h"

#import "CLQLCManager.h"

#import "CLDEBetButton.h"

#import "AppDelegate.h"

#import "CLTools.h"

#import "UIResponder+CLRouter.h"

#import "CLAllJumpManager.h"
@interface CLQLCMainBetView ()<CLQLCBetOptionsViewDelegate>{
    
    
    NSInteger __randomAnimationIndex;
}

/**
 当前玩法
 */
@property (nonatomic, assign) CLQLCPlayMethodType currentPlayMethodType;

@property (nonatomic, strong) UIButton *danTanButton;//什么是胆拖
@property (nonatomic, strong) UIButton *shakeButton;

@property (nonatomic, strong) UILabel *awardInfoLabel;

@property (nonatomic, strong) CLQLCBetOptionsView *firstOptionView;

@property (nonatomic, strong) CLQLCBetOptionsView *secondOptionView;


@property (nonatomic, strong) NSMutableArray *randomArray;

/**
 是否正在执行随机动画
 */
@property (nonatomic, assign) BOOL didRandomAnimation;

@end

@implementation CLQLCMainBetView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self p_addSubviews];
        [self p_addConstraints];
        
        [self p_addNotification];
        
        self.backgroundColor = UIColorFromRGB(0xF7F7EE);
    }
    return self;
}


- (void)p_addSubviews
{
    [self addSubview:self.danTanButton];
    [self addSubview:self.shakeButton];
    
    [self addSubview:self.firstOptionView];
    [self addSubview:self.secondOptionView];
}

- (void)p_addConstraints
{
    
    [self.danTanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(5.f));
        make.top.equalTo(self).offset(__SCALE(10.f));
        make.height.mas_equalTo(CL__SCALE(15));
    }];
    
    [self.shakeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.top.equalTo(self.danTanButton.mas_bottom).offset(CL__SCALE(10.f));
        make.width.mas_equalTo(CL__SCALE(120.f));
        make.height.mas_equalTo(CL__SCALE(34.f));
    }];
      
    [self.firstOptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.top.equalTo(self.shakeButton.mas_bottom).offset(CL__SCALE(20.f));
        make.height.mas_equalTo(CL__SCALE(380.f));
    }];
    
    [self.secondOptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.top.equalTo(self.firstOptionView.mas_bottom).offset(CL__SCALE(25.f));
        make.height.mas_equalTo(CL__SCALE(380.f));
        
    }];
}

- (void)p_addNotification
{
    
    WS(weakSelf);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:qlcShakeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        [weakSelf shakeButtonOnClick:nil];
    }];
}


#pragma mark ------ CLATBetOptionsViewDelegate ------
- (void)didSelectedOptions:(UIButton *)button groupTag:(NSString *)groupTag
{
    
    NSString *selectTag = [NSString stringWithFormat:@"%02zi",button.tag - 100];
    
    if (button.selected == YES) {
        
        [[CLQLCManager shareManager] saveOneOptions:selectTag withGroupTag:groupTag];
        
    }else{
        
        [[CLQLCManager shareManager] removeOneOptions:selectTag withGroupTag:groupTag];
    }
    
    if (self.didRandomAnimation) {
        
        [self routerWithEventName:@"QLCRELOADUI" userInfo:nil];
        
    }else{
    
        [self routerWithEventName:@"OPTIONSBUTTONCLICK" userInfo:nil];

    }
    
}

- (void)dltdanTuoInfoButtonOnClick{
    
    [[CLAllJumpManager shareAllJumpManager] open:@"https://m.caiqr.com/daily/dantuoshuoming-daletou/index.htm"];
}
#pragma mark - 摇一摇 随机选号
- (void)shakeButtonOnClick:(UIButton *)button
{
    //震动
    [CLTools vibrate];
    
    NSArray *arr = [[CLQLCManager shareManager] getRandomNumber];
    
    [self getRandomButtonWithArray:arr];
    
    //[self reloadData];
    [self.firstOptionView restoreOptionStatus];
    
    //self.didRandomAnimation = YES;
    
    [self startRandomAnimation];
    
    //self.didRandomAnimation = NO;
}

#pragma mark - 执行随机动画
- (void)startRandomAnimation{
    WS(_weakSelf)
    for (CLDEBetButton *betBtn in self.randomArray) {
        betBtn.animationStopBlock = ^(){
            
            [_weakSelf preBetViewAnimationStop];
        };
    }
    __randomAnimationIndex = 0;
    if (self.randomArray.count > __randomAnimationIndex) {
        //关闭屏幕点击事件触发
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.userInteractionEnabled = NO;
        
        self.didRandomAnimation = YES;
        
        ((CLDEBetButton *)self.randomArray[__randomAnimationIndex]).randomAnimation = YES;
        ((CLDEBetButton *)self.randomArray[__randomAnimationIndex]).selected = YES;
        __randomAnimationIndex++;
        
    }else{
        self.didRandomAnimation = NO;
    }
}
#pragma mark - 上一次动画执行结束
- (void)preBetViewAnimationStop{
    
    if (self.randomArray.count > __randomAnimationIndex) {
        ((CLDEBetButton *)self.randomArray[__randomAnimationIndex]).randomAnimation = YES;
        ((CLDEBetButton *)self.randomArray[__randomAnimationIndex]).selected = YES;
        __randomAnimationIndex++;
        self.didRandomAnimation = YES;
    }else{
        //打开屏幕点击事件触发
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.userInteractionEnabled = YES;
        self.didRandomAnimation = NO;
    }
}

#pragma mark ----- 获取需要执行动画的按钮数组 ------
- (void)getRandomButtonWithArray:(NSArray *)array
{
    [self.randomArray removeAllObjects];
    
    switch (self.currentPlayMethodType) {
        case CLQLCPlayMothedTypeNormal:{
            
            for (int i = 0; i < array.count; i++) {
                
               CLDEBetButton *btn = [self.firstOptionView getRandomOptions:[array[i] integerValue] + 1];
                
                [self.randomArray addObject:btn];
            }
            
            break;
            
        }
        case CLQLCPlayMothedTypeDanTuo:{
            
        break;
        }
    }
    
}


#pragma mark ------ 刷新 ------
- (void)reloadData
{
    
    self.currentPlayMethodType = [[CLQLCManager shareManager] getCurrentPlayMethodType];
    
}

#pragma mark ----- 切换方法 -----
- (void)setCurrentPlayMethodType:(CLQLCPlayMethodType)currentPlayMethodType
{
    
    _currentPlayMethodType = currentPlayMethodType;
    
    
    NSArray *dataArray = [[CLQLCManager shareManager] getCurrentPlayMethodSelectedOptions];
    
    NSArray *omissionArray = [[CLQLCManager shareManager] getOmissionMessageOfCurrentPlayMethod];
    
    switch (currentPlayMethodType) {
        case CLQLCPlayMothedTypeNormal:{
            self.danTanButton.hidden = YES;
            self.firstOptionView.hidden = NO;
            self.secondOptionView.hidden = YES;
            
            [self.firstOptionView setPromptText:@"选7-24个号码" andTagText:nil];
            [self.firstOptionView setSelectedOptionsWithData:dataArray];
            
            [self.firstOptionView setOmissionWithData:omissionArray];
            [self.secondOptionView setOmissionWithData:omissionArray];
            
            [self.shakeButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(CL__SCALE(16.f));
                make.height.mas_equalTo(CL__SCALE(34.f));
                
            }];
            
            break;
        }
        case CLQLCPlayMothedTypeDanTuo:{
            
            self.firstOptionView.hidden = NO;
            self.secondOptionView.hidden = NO;
            self.danTanButton.hidden = NO;
            
            [self.firstOptionView setPromptText:@"红球，至少选择1个，最多6个" andTagText:@"胆码"];
            [self.secondOptionView setPromptText:@"红球，至少选择2个" andTagText:@"拖码"];
            
            [self.firstOptionView setSelectedOptionsWithData:dataArray[0]];
            [self.secondOptionView setSelectedOptionsWithData:dataArray[1]];
            
            [self.firstOptionView setOmissionWithData:omissionArray];
            [self.secondOptionView setOmissionWithData:omissionArray];
            
            [self.shakeButton mas_updateConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.danTanButton.mas_bottom).offset(0);
                make.height.mas_equalTo(0);
            }];
            
            break;
        }
            
        default:
            break;
    }
    [self updateConstraints];
}


#pragma mark ------ lazyLoad -----

- (UIButton *)danTanButton{
    
    if (!_danTanButton) {
        _danTanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_danTanButton setTitle:@"什么是胆拖？" forState:UIControlStateNormal];
        [_danTanButton setTitleColor:LINK_COLOR forState:UIControlStateNormal];
        _danTanButton.titleLabel.font = FONT_SCALE(14);
        [_danTanButton addTarget:self action:@selector(dltdanTuoInfoButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _danTanButton;
}

- (UIButton *)shakeButton
{
    
    if (_shakeButton == nil) {
        
        _shakeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        
        [_shakeButton addTarget:self action:@selector(shakeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_shakeButton setBackgroundImage:[UIImage imageNamed:@"DE_shakeImage.png"] forState:UIControlStateNormal];
    }
    return _shakeButton;
}

- (CLQLCBetOptionsView *)firstOptionView
{
    
    if (_firstOptionView == nil) {
        
        _firstOptionView = [[CLQLCBetOptionsView alloc] initWithFrame:(CGRectZero)];
        
        _firstOptionView.groupTag = @"0";
        
        _firstOptionView.delegate = self;
        
    }
    return _firstOptionView;
}

- (CLQLCBetOptionsView *)secondOptionView
{
    
    if (_secondOptionView == nil) {
        
        _secondOptionView = [[CLQLCBetOptionsView alloc] initWithFrame:(CGRectZero)];
        
        _secondOptionView.groupTag = @"1";
        
        _secondOptionView.delegate = self;
    }
    return _secondOptionView;
}

- (NSMutableArray *)randomArray
{
    
    if (_randomArray == nil) {
        
        _randomArray = [NSMutableArray array];
    }
    return _randomArray;
}

@end

