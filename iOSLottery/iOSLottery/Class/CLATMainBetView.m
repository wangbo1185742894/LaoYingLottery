//
//  CLATMainBetView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLATMainBetView.h"

#import "CLConfigMessage.h"

#import "UILabel+CLAttributeLabel.h"

#import "CLATBetOptionsView.h"

#import "CLATManager.h"

#import "CLDEBetButton.h"

#import "AppDelegate.h"

#import "CLTools.h"

@interface CLATMainBetView ()<CLATBetOptionsViewDelegate>{


    NSInteger __randomAnimationIndex;
}

/**
 当前玩法
 */
@property (nonatomic, assign) CLATPlayMethodType currentPlayMethodType;

@property (nonatomic, strong) UIButton *shakeButton;

@property (nonatomic, strong) UILabel *awardInfoLabel;

@property (nonatomic, strong) CLATBetOptionsView *firstOptionView;

@property (nonatomic, strong) CLATBetOptionsView *secondOptionView;

@property (nonatomic, strong) CLATBetOptionsView *thirdOptionView;

@property (nonatomic, strong) NSMutableArray *randomArray;

@end

@implementation CLATMainBetView

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
    [self addSubview:self.shakeButton];
    [self addSubview:self.awardInfoLabel];

    [self addSubview:self.firstOptionView];
    [self addSubview:self.secondOptionView];
    [self addSubview:self.thirdOptionView];
}

- (void)p_addConstraints
{
    [self.shakeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.top.equalTo(self).offset(CL__SCALE(16.f));
        make.width.mas_equalTo(CL__SCALE(120.f));
        make.height.mas_equalTo(CL__SCALE(34.f));
    }];
    
    [self.awardInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(CL__SCALE(10.f));
        make.right.equalTo(self).offset(CL__SCALE(-10.f));
        make.top.equalTo(self.shakeButton.mas_bottom).offset(CL__SCALE(20.f));
    }];
    
    [self.firstOptionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self);
        make.top.equalTo(self.awardInfoLabel.mas_bottom).offset(CL__SCALE(15.f));
        make.height.mas_equalTo(CL__SCALE(146.f));
    }];
    
    [self.secondOptionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self);
        make.top.equalTo(self.firstOptionView.mas_bottom);
        make.height.mas_equalTo(CL__SCALE(146.f));
        
    }];
    
    [self.thirdOptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.top.equalTo(self.secondOptionView.mas_bottom);
        make.height.mas_equalTo(CL__SCALE(146.f));
    }];

}

- (void)p_addNotification
{
    
    WS(weakSelf);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:pl3ShakeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        [weakSelf shakeButtonOnClick:nil];
    }];
}


#pragma mark ------ CLATBetOptionsViewDelegate ------
- (void)didSelectedOptions:(UIButton *)button groupTag:(NSString *)groupTag
{
    
    NSString *selectTag = [NSString stringWithFormat:@"%zi",button.tag - 100];
    
    
    if (button.selected == YES) {
        
        [[CLATManager shareManager] saveOneOptions:selectTag withGroupTag:groupTag];
        
        
    }else{
        
        [[CLATManager shareManager] removeOneOptions:selectTag withGroupTag:groupTag];
    }
    
}

#pragma mark - 摇一摇 随机选号
- (void)shakeButtonOnClick:(UIButton *)button
{
    
    //震动
    [CLTools vibrate];
    
    //生成随机号
    [self getRandomButtonWithArray:[[CLATManager shareManager] getRandomNumber]];
    
    //重置UI
    
    switch ([[CLATManager shareManager] getCurrentPlayMethodType]) {
        case CLATPlayMothedTypeOne:{
        
            [self.firstOptionView restoreOptionStatus];
            [self.secondOptionView restoreOptionStatus];
            [self.thirdOptionView restoreOptionStatus];
           
            break;
        }
        case CLATPlayMothedTypeTwo:{
        
            [self.firstOptionView restoreOptionStatus];
            [self.secondOptionView restoreOptionStatus];
            
            break;
        }
        case CLATPlayMothedTypeFour:
        case CLATPlayMothedTypeThree:{
        
            [self.firstOptionView restoreOptionStatus];
            
            break;
        }
            
            
        default:
            break;
    }
    
    ;
    
    //开始动画
    [self startRandomAnimation];
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
        
        ((CLDEBetButton *)self.randomArray[__randomAnimationIndex]).randomAnimation = YES;
        ((CLDEBetButton *)self.randomArray[__randomAnimationIndex]).selected = YES;
        __randomAnimationIndex++;
    }
}
#pragma mark - 上一次动画执行结束
- (void)preBetViewAnimationStop{
    
    if (self.randomArray.count > __randomAnimationIndex) {
        ((CLDEBetButton *)self.randomArray[__randomAnimationIndex]).randomAnimation = YES;
        ((CLDEBetButton *)self.randomArray[__randomAnimationIndex]).selected = YES;
        __randomAnimationIndex++;
    }else{
        //打开屏幕点击事件触发
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.userInteractionEnabled = YES;
    }
}

#pragma mark ----- 获取需要执行动画的按钮数组 ------
- (void)getRandomButtonWithArray:(NSArray *)array
{
    [self.randomArray removeAllObjects];

    switch (self.currentPlayMethodType) {
        case CLATPlayMothedTypeOne:{
        
            CLDEBetButton *btn = [self.firstOptionView getRandomOptions:[array[0] integerValue]];
            
            CLDEBetButton *btn2 = [self.secondOptionView getRandomOptions:[array[1] integerValue]];
            
            CLDEBetButton *btn3 = [self.thirdOptionView getRandomOptions:[array[2] integerValue]];
            
            [self.randomArray addObject:btn];
            [self.randomArray addObject:btn2];
            [self.randomArray addObject:btn3];
            
            break;
        
        }
        case CLATPlayMothedTypeTwo:{
        
            CLDEBetButton *btn1 = [self.firstOptionView getRandomOptions:[array[0] integerValue]];
            
            CLDEBetButton *btn2 = [self.secondOptionView getRandomOptions:[array[1] integerValue]];
        
            [self.randomArray addObject:btn1];
            [self.randomArray addObject:btn2];
            
            break;
        }
        case CLATPlayMothedTypeThree:{
        
            CLDEBetButton *btn1 = [self.firstOptionView getRandomOptions:[array[0] integerValue]];
            
            CLDEBetButton *btn2 = [self.firstOptionView getRandomOptions:[array[1] integerValue]];
            
            [self.randomArray addObject:btn1];
            [self.randomArray addObject:btn2];
            
            break;
            
        }
        case CLATPlayMothedTypeFour:{
        
            CLDEBetButton *btn = [self.firstOptionView getRandomOptions:[array[0] integerValue]];
            
            CLDEBetButton *btn2 = [self.firstOptionView getRandomOptions:[array[1] integerValue]];
            
            CLDEBetButton *btn3 = [self.firstOptionView getRandomOptions:[array[2] integerValue]];
            
            [self.randomArray addObject:btn];
            [self.randomArray addObject:btn2];
            [self.randomArray addObject:btn3];
            
            break;
            
        }
            
        default:
            break;
    }
    
}


- (void)reloadData
{

    NSString *text = [[CLATManager shareManager] getCurrentBounsMessage];
    
    [self.awardInfoLabel attributeWithText:text beginTag:@"^" endTag:@"&" color:THEME_COLOR];
    
    self.currentPlayMethodType = [[CLATManager shareManager] getCurrentPlayMethodType];
    
}

#pragma mark ----- 切换方法 -----
- (void)setCurrentPlayMethodType:(CLATPlayMethodType)currentPlayMethodType
{

    _currentPlayMethodType = currentPlayMethodType;
    
    
    NSArray *dataArray = [[CLATManager shareManager] getCurrentPlayMethodSelectedOptions];
    
    NSArray *omissionArray = [[CLATManager shareManager] getOmissionMessageOfCurrentPlayMethod];
    
    switch (currentPlayMethodType) {
        case CLATPlayMothedTypeOne:{
        
            self.firstOptionView.hidden = NO;
            self.secondOptionView.hidden = NO;
            self.thirdOptionView.hidden = NO;
        
            [self.firstOptionView setTagText:@"百位"];
            [self.secondOptionView setTagText:@"十位"];
            [self.thirdOptionView setTagText:@"个位"];
            
            [self.firstOptionView setSelectedOptionsWithData:dataArray[0]];
            [self.secondOptionView setSelectedOptionsWithData:dataArray[1]];
            [self.thirdOptionView setSelectedOptionsWithData:dataArray[2]];
            
            [self.firstOptionView setOmissionWithData:omissionArray[0]];
            [self.secondOptionView setOmissionWithData:omissionArray[1]];
            [self.thirdOptionView setOmissionWithData:omissionArray[2]];
            
            break;
        }
        case CLATPlayMothedTypeTwo:{
        
            self.firstOptionView.hidden = NO;
            self.secondOptionView.hidden = NO;
            self.thirdOptionView.hidden = YES;
            
            [self.firstOptionView setTagText:@"重号"];
            [self.secondOptionView setTagText:@"单号"];
            
            [self.firstOptionView setSelectedOptionsWithData:dataArray[0]];
            [self.secondOptionView setSelectedOptionsWithData:dataArray[1]];
            
            [self.firstOptionView setOmissionWithData:omissionArray[0]];
            [self.secondOptionView setOmissionWithData:omissionArray[1]];
            
            break;
        }
         
        case CLATPlayMothedTypeThree:
        case CLATPlayMothedTypeFour:{
            
            self.firstOptionView.hidden = NO;
            self.secondOptionView.hidden = YES;
            self.thirdOptionView.hidden = YES;
            
            [self.firstOptionView setTagText:@"选号"];
            
            [self.firstOptionView setSelectedOptionsWithData:dataArray];
            
            [self.firstOptionView setOmissionWithData:omissionArray[0]];
            
            break;
        }
            
        default:
            break;
    }
}


#pragma mark ------ lazyLoad -----

- (UIButton *)shakeButton
{
    
    if (_shakeButton == nil) {
        
        _shakeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        
        [_shakeButton addTarget:self action:@selector(shakeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_shakeButton setBackgroundImage:[UIImage imageNamed:@"DE_shakeImage.png"] forState:UIControlStateNormal];
    }
    return _shakeButton;
}

- (UILabel *)awardInfoLabel
{
    
    if (!_awardInfoLabel) {
        _awardInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _awardInfoLabel.textColor = UIColorFromRGB(0x333333);
        _awardInfoLabel.font = FONT_SCALE(14);
        _awardInfoLabel.numberOfLines = 0;
        NSString *text = @"至少选2个号， 猜对任意2个开奖号即中6元";
        AttributedTextParams *params = [AttributedTextParams attributeRange:NSMakeRange(text.length - 2, 1) Color:UIColorFromRGB(0xd90000)];
        [_awardInfoLabel attributeWithText:text controParams:@[params]];
        //_awardInfoLabel.backgroundColor = [UIColor redColor];
    }
    return _awardInfoLabel;
}

- (CLATBetOptionsView *)firstOptionView
{

    if (_firstOptionView == nil) {
        
        _firstOptionView = [[CLATBetOptionsView alloc] initWithFrame:(CGRectZero)];
        
        _firstOptionView.groupTag = @"0";
        
        _firstOptionView.delegate = self;
        
    }
    return _firstOptionView;
}

- (CLATBetOptionsView *)secondOptionView
{

    if (_secondOptionView == nil) {
        
        _secondOptionView = [[CLATBetOptionsView alloc] initWithFrame:(CGRectZero)];
        
        _secondOptionView.groupTag = @"1";
        
        _secondOptionView.delegate = self;
    }
    return _secondOptionView;
}

- (CLATBetOptionsView *)thirdOptionView
{

    if (_thirdOptionView == nil) {
        
        _thirdOptionView = [[CLATBetOptionsView alloc] initWithFrame:(CGRectZero)];
        
        _thirdOptionView.groupTag = @"2";
        
        _thirdOptionView.delegate = self;
    }
    return _thirdOptionView;
}

- (NSMutableArray *)randomArray
{

    if (_randomArray == nil) {
        
        _randomArray = [NSMutableArray array];
    }
    return _randomArray;
}

@end
