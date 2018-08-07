//
//  CLAFMainBetView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/26.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLAFMainBetView.h"

#import "CLConfigMessage.h"

#import "UILabel+CLAttributeLabel.h"

#import "CLATBetOptionsView.h"

#import "CLAFManager.h"

#import "CLDEBetButton.h"

#import "AppDelegate.h"

#import "CLTools.h"

@interface CLAFMainBetView ()<CLATBetOptionsViewDelegate>{
    
    
    NSInteger __randomAnimationIndex;
}

/**
 摇一摇按钮
 */
@property (nonatomic, strong) UIButton *shakeButton;

/**
 奖金label
 */
@property (nonatomic, strong) UILabel *awardInfoLabel;

/**
 存储随机选项
 */
@property (nonatomic, strong) NSMutableArray *randomArray;

/**
 存储选项
 */
@property (nonatomic, strong) NSMutableArray *optionsArray;

@end

@implementation CLAFMainBetView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self p_addSubviews];
        [self p_addConstraints];
        [self p_createOptions];
        
        [self p_addNotification];
        
        self.backgroundColor = UIColorFromRGB(0xF7F7EE);
    }
    return self;
}


- (void)p_addSubviews
{
    [self addSubview:self.shakeButton];
    [self addSubview:self.awardInfoLabel];
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
    
}


//创建选项
- (void)p_createOptions
{
    NSArray *tagArray = @[@"万位",@"千位",@"百位",@"十位",@"个位"];

    
    __block CLATBetOptionsView *lastOption;
    
    for (int i = 0; i < 5; i++) {
        
        CLATBetOptionsView *option = [[CLATBetOptionsView alloc] initWithFrame:(CGRectZero)];
        
        option.groupTag = [NSString stringWithFormat:@"%d",i];
        
        [option setTagText:tagArray[i]];
        
        option.delegate = self;
        
        [self addSubview:option];
        [self.optionsArray addObject:option];
        
        [option mas_makeConstraints:^(MASConstraintMaker *make) {
           
            if (lastOption == nil) {
                
                make.top.equalTo(self.awardInfoLabel.mas_bottom).offset(CL__SCALE(15.f));
            }else{
            
                make.top.equalTo(lastOption.mas_bottom);
            }
            
            make.left.right.equalTo(self);
            make.height.mas_equalTo(CL__SCALE(146.f));
        }];
        
        lastOption = option;
    }
}

- (void)p_addNotification
{

    WS(weakSelf);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:pl5ShakeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
       
        [weakSelf shakeButtonOnClick:nil];
    }];
}

#pragma mark ------ CLATBetOptionsViewDelegate ------
- (void)didSelectedOptions:(UIButton *)button groupTag:(NSString *)groupTag
{
    
    NSString *selectTag = [NSString stringWithFormat:@"%zi",button.tag - 100];
    
    
    if (button.selected == YES) {
        
        [[CLAFManager shareManager] saveOneOptions:selectTag withGroupTag:groupTag];

        
    }else{
        
        [[CLAFManager shareManager] removeOneOptions:selectTag withGroupTag:groupTag];
    }

}

#pragma mark - 摇一摇 随机选号
- (void)shakeButtonOnClick:(UIButton *)button
{
    //震动
    [CLTools vibrate];
    
    //生成随机号
    [self getRandomButtonWithArray:[[CLAFManager shareManager] getRandomNumber]];
    
    //重置UI
    [self.optionsArray enumerateObjectsUsingBlock:^(CLATBetOptionsView *option, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [option restoreOptionStatus];
    }];
    
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
    
    for (int i = 0; i < array.count; i++) {
        
        CLDEBetButton *btn = [self.optionsArray[i] getRandomOptions:[array[i] integerValue]];
        
        [self.randomArray addObject:btn];
    }
}


- (void)reloadData
{
    
    NSString *text = [[CLAFManager shareManager] getCurrentBounsMessage];
    
    [self.awardInfoLabel attributeWithText:text beginTag:@"^" endTag:@"&" color:THEME_COLOR];
    
    NSArray *dataArray = [[CLAFManager shareManager] getCurrentPlayMethodSelectedOptions];
    
    NSArray *omissionArray = [[CLAFManager shareManager] getOmissionMessageOfCurrentPlayMethod];
    
    [self.optionsArray enumerateObjectsUsingBlock:^(CLATBetOptionsView  *option, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [option setSelectedOptionsWithData:dataArray[idx]];
        [option setOmissionWithData:omissionArray[idx]];
    }];
    
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

- (NSMutableArray *)randomArray
{
    
    if (_randomArray == nil) {
        
        _randomArray = [NSMutableArray array];
    }
    return _randomArray;
}

- (NSMutableArray *)optionsArray
{
    
    if (_optionsArray == nil) {
        
        _optionsArray = [NSMutableArray array];
    }
    return _optionsArray;
}

@end

