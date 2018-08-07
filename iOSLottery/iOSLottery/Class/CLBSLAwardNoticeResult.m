//
//  CLBSLAwardNoticeResult.m
//  iOSLottery
//
//  Created by 小铭 on 2017/8/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLBSLAwardNoticeResult.h"
#import "CLConfigMessage.h"
@interface CLBSLAwardNoticeResult ()

@property (nonatomic, strong) UIImageView *playImage;

@property (nonatomic, strong) UIView *resultView;

@property (nonatomic, strong) UILabel *leftlabel;

@property (nonatomic, strong) UILabel *scoreLabel;

@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation CLBSLAwardNoticeResult

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
        self.backgroundColor = UIColorFromRGB(0xF5853F);
        self.layer.cornerRadius = __SCALE(18 * 0.85);
    }
    
    return self;
    
}

- (void)addSubviews
{
    [self addSubview:self.playImage];
    [self addSubview:self.resultView];
}

- (void)addConstraints
{
    [self.playImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(__SCALE(4 * 0.85));
        make.width.height.mas_offset(__SCALE(28.f * 0.85));
        
    }];
    
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        
        make.centerX.equalTo(self.mas_left).offset(__SCALE(178.f * 0.85));
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.playImage.mas_centerY);
        make.top.bottom.equalTo(self.resultView);
        make.left.mas_equalTo(self.leftlabel.mas_right).offset(__SCALE(10.f) * .85);
    }];
    
    
    [self.leftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.resultView);
        make.centerY.equalTo(self.playImage.mas_centerY);
        make.top.bottom.mas_equalTo(self.resultView);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.scoreLabel.mas_right).offset(__SCALE(10.f) * .85);
        make.right.mas_equalTo(self.resultView);
        make.centerY.equalTo(self.playImage.mas_centerY);
        make.top.bottom.mas_equalTo(self.resultView);
        
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.frame.size.height / 2;
    
}

- (void)setIsCancel:(NSInteger)isCancel
{
    
    _isCancel = isCancel;
    
    if (isCancel == 1) {
        
        self.scoreLabel.font = FONT_SCALE(12.f * 0.85);
        
    }else{
        
        self.scoreLabel.font = FONT_SCALE(16.f * 0.85);
        
    }
}

- (void)setDateWithString:(NSString *)str
{
    
    NSArray *dataArray = [str componentsSeparatedByString:@"_"];
    
    if (!(dataArray.count == 4)) return;
    NSString *leftString = [NSString stringWithFormat:@"%@",dataArray[0]?:@""];
    NSString *rightString = [NSString stringWithFormat:@"%@",dataArray[3]?:@""];
    self.leftlabel.text = leftString.length > 7 ? [leftString substringToIndex:7]: leftString;
    self.scoreLabel.text = dataArray[2];
    self.rightLabel.text = rightString.length > 7 ? [rightString substringToIndex:7]:rightString;
    
    
}

#pragma mark --- Get Method ---
- (UIImageView *)playImage
{
    
    if (_playImage == nil) {
        
        _playImage = [[UIImageView alloc] initWithFrame:(CGRectZero)];
        _playImage.image = [UIImage imageNamed:@"draw_notice_football"];
    }
    
    return _playImage;
}

- (UIView *)resultView
{
    if (!_resultView) {
        _resultView = [[UIView alloc] init];
        [_resultView addSubview:self.leftlabel];
        [_resultView addSubview:self.scoreLabel];
        [_resultView addSubview:self.rightLabel];
    }
    return _resultView;
}

- (UILabel *)leftlabel
{
    
    if (_leftlabel == nil) {
        
        _leftlabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _leftlabel.text = @"";
        _leftlabel.textColor = UIColorFromRGB(0xFFFFFF);
        _leftlabel.font = FONT_SCALE(14.f * 0.85);
    }
    
    return _leftlabel;
}

- (UILabel *)scoreLabel
{
    
    if (_scoreLabel == nil) {
        
        _scoreLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _scoreLabel.text = @"";
        _scoreLabel.textColor = UIColorFromRGB(0xFFFFFF);
        _scoreLabel.font = FONT_SCALE(16.f * 0.85);
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        
        _scoreLabel.numberOfLines = 2;
    }
    
    return _scoreLabel;
}


- (UILabel *)rightLabel
{
    
    if (_rightLabel == nil) {
        
        _rightLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _rightLabel.text = @"";
        _rightLabel.textColor = UIColorFromRGB(0xFFFFFF);
        _rightLabel.font = FONT_SCALE(14.f * 0.85);
    }
    
    return _rightLabel;
}
@end
