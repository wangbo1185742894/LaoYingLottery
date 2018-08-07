//
//  CLSFCTopView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/24.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSFCTopView.h"

#import "CLConfigMessage.h"
#import "CLSFCManager.h"

#import "UILabel+CLAttributeLabel.h"

@interface CLSFCTopView ()

@property (nonatomic, copy) CLSFCTopViewBlock endCountDown;

@property (nonatomic, strong) UILabel *periodLabel;

@property (nonatomic, strong) UILabel *countDownLabel;

@property (nonatomic, assign) NSInteger countDownTime;

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation CLSFCTopView


- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = UIColorFromRGB(0xFFFFFF);
        
        [self p_addSubviews];
        [self p_addConstraints];
        [self p_createTagLabels];

    }
    return self;
}

- (void)p_addSubviews
{

    [self addSubview:self.periodLabel];
    [self addSubview:self.countDownLabel];
    [self addSubview:self.bottomLine];
}

- (void)p_addConstraints
{

    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(CL__SCALE(10.f));
        make.top.equalTo(self).offset(CL__SCALE(9.f));
    }];
    
    [self.countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self).offset(CL__SCALE(-10.f));
        make.centerY.equalTo(self.periodLabel);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.51);
    }];
}

- (void)p_createTagLabels
{

    NSArray *tagArray = @[@"赛事/开赛",@"主胜(3)",@"平(1)",@"负(0)",@""];
    
    CGFloat width = CL__SCALE(90.f);
    CGFloat height = CL__SCALE(30.f);
    
    for (int i = 0; i < 5; i ++) {

        UILabel *tagLabel = [self p_createTagLabelWithText:tagArray[i]];
        
        tagLabel.frame = CGRectMake(width * i, CL__SCALE(29.f), width, height);
        
        tagLabel.backgroundColor = UIColorFromRGB(0xF7F7EE);
        
        [self addSubview:tagLabel];
    }
}

- (UILabel *)p_createTagLabelWithText:(NSString *)text
{

    UILabel *label = [[UILabel alloc] initWithFrame:(CGRectZero)];
    
    label.text = text;
    label.textColor = UIColorFromRGB(0x988366);
    label.font = FONT_SCALE(12.f);
    
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

- (void)reloadUI
{
    self.periodLabel.text = [NSString stringWithFormat:@"第%@期",[[CLSFCManager shareManager] getPeriodId]];
 
 
    self.countDownTime = [[CLSFCManager shareManager] getPeriodTime];
    
    NSString *timeStr = [NSString stringWithFormat:@"距截止：%@",[self timeFormatted:self.countDownTime]];
    
    NSRange range = [timeStr rangeOfString:@"："];
    
    AttributedTextParams *params = [AttributedTextParams attributeRange:NSMakeRange(range.location + 1, timeStr.length - range.location - 1) Color:UIColorFromRGB(0xd90000)];
    
    [self.countDownLabel attributeWithText:timeStr controParams:@[params]];
    
    if ([[CLSFCManager shareManager] getIfCountDown] == 1) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeCutDown:) name:GlobalTimerRuning object:nil];
    }
}

- (void)timeCutDown:(NSNotification *)noti
{
    self.countDownTime --;

    if (self.countDownTime <= 0) {
        
        self.countDownTime = 0;
        
        self.endCountDown ? self.endCountDown() : nil;
    }
    
    NSString *timeStr = [NSString stringWithFormat:@"距截止：%@",[self timeFormatted:self.countDownTime]];
    
    NSRange range = [timeStr rangeOfString:@"："];
    
    AttributedTextParams *params = [AttributedTextParams attributeRange:NSMakeRange(range.location + 1, timeStr.length - range.location - 1) Color:UIColorFromRGB(0xd90000)];
    
    [self.countDownLabel attributeWithText:timeStr controParams:@[params]];

    
}

#pragma mark - 将秒数转换成分秒  若大于1小时，则转换成时分秒
- (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    NSInteger day = totalSeconds / (3600 * 24);
    
    if (day > 0) {
        return [NSString stringWithFormat:@"%zi天:%zi分",day, hours];
    }
    
    if (hours > 0) {
        return [NSString stringWithFormat:@"%zi小时:%02zi分",hours, minutes];
    }else{
        return [NSString stringWithFormat:@"%02zi分:%02zi秒",minutes, seconds];
    }
    
}

- (void)returnEndCountDown:(CLSFCTopViewBlock)block
{

    _endCountDown = block;
}


#pragma mark ----- lazyLoad -----

- (UILabel *)periodLabel
{

    if (_periodLabel == nil) {
        
        _periodLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        
        _periodLabel.text = @"";
        
        _periodLabel.font = FONT_SCALE(12.f);
    }
    return _periodLabel;
}

- (UILabel *)countDownLabel
{
    if (_countDownLabel == nil) {
        
        _countDownLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        
        _countDownLabel.text = @"";
        
        _countDownLabel.font = FONT_SCALE(12.f);
    }
    return _countDownLabel;
    
}

- (UIView *)bottomLine
{
    
    if (_bottomLine == nil) {
        
        _bottomLine = [[UIView alloc] initWithFrame:(CGRectZero)];
        
        _bottomLine.backgroundColor = UIColorFromRGB(0xDDDDDD);
    }
    return _bottomLine;
}

@end
