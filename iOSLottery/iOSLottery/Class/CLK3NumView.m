//
//  CLK3NumView.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLK3NumView.h"
#import "CLConfigMessage.h"

@interface CLK3NumView ()

@property (nonatomic, strong) UIImageView* firstImg;
@property (nonatomic, strong) UIImageView* secondImg;
@property (nonatomic, strong) UIImageView* thirdImg;

@end

@implementation CLK3NumView

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
    }
    return self;
}

- (void)addSubviews
{
    [self addSubview:self.firstImg];
    [self addSubview:self.secondImg];
    [self addSubview:self.thirdImg];
}

- (void)addConstraints
{

    [self.secondImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(__SCALE(26.f));
        make.top.bottom.centerX.equalTo(self);
    }];
    
    [self.firstImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
        make.width.height.equalTo(self.secondImg);
        make.right.equalTo(self.secondImg.mas_left).offset(__SCALE(- 5.f));
    }];
    
    [self.thirdImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self);
        make.width.height.equalTo(self.secondImg);
        make.left.equalTo(self.secondImg.mas_right).offset(__SCALE(5.f));
    }];
    
}
- (void)setK3Nums:(NSArray*)nums {
    
//    dice_v1_small
    [self.firstImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"dice_v%zi_small",[nums[0] integerValue]]]];
    [self.secondImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"dice_v%zi_small",[nums[1] integerValue]]]];
    [self.thirdImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"dice_v%zi_small",[nums[2] integerValue]]]];
}

#pragma mark --- Get Method ---
- (UIImageView *)firstImg
{
    if (_firstImg == nil) {
        
        _firstImg = [[UIImageView alloc] init];
        _firstImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _firstImg;
}

- (UIImageView *)secondImg
{
    if (_secondImg == nil) {
        
        _secondImg = [[UIImageView alloc] init];
        _secondImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _secondImg;
}

- (UIImageView *)thirdImg
{

    if (_thirdImg == nil) {
        
        _thirdImg = [[UIImageView alloc] init];
        _thirdImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _thirdImg;
}

@end
