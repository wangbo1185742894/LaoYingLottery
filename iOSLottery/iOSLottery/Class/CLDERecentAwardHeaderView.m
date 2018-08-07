//
//  CLDERecentAwardHeaderView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/1.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLDERecentAwardHeaderView.h"
#import "Masonry.h"
#import "CLConfigMessage.h"
@interface CLDERecentAwardHeaderView ()

@property (nonatomic, strong) UILabel *periodLabel;//期次label
@property (nonatomic, strong) UILabel *bonusNumberLabel;//开奖号码label
@property (nonatomic, strong) UILabel *sumLabel;//和值label
@property (nonatomic, strong) UIImageView *leftLineView;//左边线的View
@property (nonatomic, strong) UIImageView *rightLineView;//右边线的View

@end
@implementation CLDERecentAwardHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xeeeee5);
        [self addSubview:self.periodLabel];
        [self addSubview:self.bonusNumberLabel];
        [self addSubview:self.sumLabel];
        [self addSubview:self.leftLineView];
        [self addSubview:self.rightLineView];
        //配置约束
        [self configConstraint];

    }
    return self;
}
#pragma mark ------------ private Mothed ------------
- (void)configConstraint{
    
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.height.mas_equalTo(__SCALE(20.f));
        make.width.mas_equalTo(__SCALE(75.f));
    }];
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.periodLabel.mas_right);
        make.width.mas_equalTo(.5f);
        make.top.height.equalTo(self.periodLabel);
    }];
    [self.bonusNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.equalTo(self.periodLabel);
        make.left.equalTo(self.leftLineView.mas_right);
        make.right.equalTo(self.rightLineView.mas_left);
    }];
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self.sumLabel.mas_left);
        make.width.height.equalTo(self.leftLineView);
    }];
    [self.sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.equalTo(self.periodLabel);
    }];
}
#pragma mark ------------ getter Mothed ------------
- (UILabel *)periodLabel{
    
    if (!_periodLabel) {
        _periodLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _periodLabel.text = @"期次";
        _periodLabel.textColor = UIColorFromRGB(0x333333);
        _periodLabel.font = FONT_SCALE(13);
        _periodLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _periodLabel;
}
- (UILabel *)bonusNumberLabel{
    
    if (!_bonusNumberLabel) {
        _bonusNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bonusNumberLabel.text = @"开奖号码";
        _bonusNumberLabel.textColor = UIColorFromRGB(0x333333);
        _bonusNumberLabel.font = FONT_SCALE(13);
        _bonusNumberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bonusNumberLabel;
}
- (UILabel *)sumLabel{
    
    if (!_sumLabel) {
        _sumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _sumLabel.text = @"和值";
        _sumLabel.textColor = UIColorFromRGB(0x333333);
        _sumLabel.font = FONT_SCALE(13);
        _sumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _sumLabel;
}
- (UIImageView *)leftLineView{
    
    if (!_leftLineView) {
        _leftLineView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _leftLineView.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _leftLineView;
}
- (UIImageView *)rightLineView{
    
    if (!_rightLineView) {
        _rightLineView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightLineView.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _rightLineView;
}

@end
