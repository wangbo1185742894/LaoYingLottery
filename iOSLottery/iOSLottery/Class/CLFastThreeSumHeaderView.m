//
//  CLFastThreeSumHeaderView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/11.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFastThreeSumHeaderView.h"
#import "CLConfigMessage.h"
#import "CQDefinition.h"
#import "Masonry.h"
@interface CLFastThreeSumHeaderView ()
@property (nonatomic, strong) UILabel *periodLabel;//期次
@property (nonatomic, strong) UILabel *awardLabel;//开奖号码的View
@property (nonatomic, strong) UILabel *sumLabel;//和值label
@property (nonatomic, strong) UILabel *sizeLabel;//大小
@property (nonatomic, strong) UILabel *singleLabel;//单双
@property (nonatomic, strong) CALayer *bottomLineLayer;//底线

@end
@implementation CLFastThreeSumHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.periodLabel];
        [self addSubview:self.awardLabel];
        [self addSubview:self.sumLabel];
        [self addSubview:self.sizeLabel];
        [self addSubview:self.singleLabel];
        [self.layer addSublayer:self.bottomLineLayer];
        [self configConstraints];
    }
    return self;
}
#pragma mark ------ private Mothed ------
- (void)configConstraints{
    
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(10.f));
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(__SCALE(45.f));
    }];
    [self.awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.periodLabel.mas_right);
        make.centerY.equalTo(self);
    }];
    [self.sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.awardLabel.mas_right);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(__SCALE(45.f));
    }];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sumLabel.mas_right);
        make.width.centerY.equalTo(self.sumLabel);
    }];
    [self.singleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sizeLabel.mas_right);
        make.width.centerY.equalTo(self.sizeLabel);
        make.right.equalTo(self).offset(__SCALE(- 10.f));
    }];
    
}
#pragma mark ------ getter Mothed ------
- (UILabel *)periodLabel{
    
    if (!_periodLabel) {
        _periodLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _periodLabel.text = @"期次";
        _periodLabel.textAlignment = NSTextAlignmentCenter;
        _periodLabel.textColor = UIColorFromRGB(0xffffff);
        _periodLabel.font = FONT_SCALE(14);
    }
    return _periodLabel;
}
- (UILabel *)awardLabel{
    
    if (!_awardLabel) {
        _awardLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _awardLabel.text = @"开奖号码";
        _awardLabel.textAlignment = NSTextAlignmentCenter;
        _awardLabel.textColor = UIColorFromRGB(0xffffff);
        _awardLabel.font = FONT_SCALE(14);
        [_awardLabel setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _awardLabel;
}
- (UILabel *)sumLabel{
    
    if (!_sumLabel) {
        _sumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _sumLabel.text = @"和值";
        _sumLabel.textAlignment = NSTextAlignmentCenter;
        _sumLabel.textColor = UIColorFromRGB(0xffffff);
        _sumLabel.font = FONT_SCALE(14);
    }
    return _sumLabel;
}
- (UILabel *)sizeLabel{
    
    if (!_sizeLabel) {
        _sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _sizeLabel.text = @"大小";
        _sizeLabel.textAlignment = NSTextAlignmentCenter;
        _sizeLabel.textColor = UIColorFromRGB(0xffffff);
        _sizeLabel.font = FONT_SCALE(14);
    }
    return _sizeLabel;
}
- (UILabel *)singleLabel{
    
    if (!_singleLabel) {
        _singleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _singleLabel.text = @"单双";
        _singleLabel.textAlignment = NSTextAlignmentCenter;
        _singleLabel.textColor = UIColorFromRGB(0xffffff);
        _singleLabel.font = FONT_SCALE(14);
    }
    return _singleLabel;
}
- (CALayer *)bottomLineLayer{
    
    if (!_bottomLineLayer) {
        _bottomLineLayer = [[CALayer alloc] init];
        _bottomLineLayer.frame = __Rect(0, self.frame.size.height - .5, self.frame.size.width, .5f);
        _bottomLineLayer.backgroundColor = UIColorFromRGB(0x063d27).CGColor;
    }
    return _bottomLineLayer;
}
@end
