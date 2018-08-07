//
//  CLFastThreeOtherHeaderView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/11.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFastThreeOtherHeaderView.h"
#import "CLConfigMessage.h"
#import "CQDefinition.h"
#import "Masonry.h"
@interface CLFastThreeOtherHeaderView ()

@property (nonatomic, strong) UILabel *periodLabel;//期次
@property (nonatomic, strong) UILabel *awardLabel;//开奖号码
@property (nonatomic, strong) UILabel *shapeLabel;//形态label
@property (nonatomic, strong) CALayer *bottomLineLayer;//底线

@end
@implementation CLFastThreeOtherHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.periodLabel];
        [self addSubview:self.awardLabel];
        [self addSubview:self.shapeLabel];
        [self.layer addSublayer:self.bottomLineLayer];
        [self configConstraints];
    }
    return self;
}
#pragma mark ------ private Mothed ------
- (void)configConstraints{
    
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(10.f));
        make.width.mas_equalTo(__SCALE(45.f));
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    [self.awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.periodLabel.mas_right);
        make.centerY.equalTo(self);
    }];
    [self.shapeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.awardLabel.mas_right);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(__SCALE(90.f));
        make.right.mas_equalTo(__SCALE(- 20));
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
- (UILabel *)shapeLabel{
    
    if (!_shapeLabel) {
        _shapeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _shapeLabel.text = @"形态";
        _shapeLabel.textAlignment = NSTextAlignmentCenter;
        _shapeLabel.textColor = UIColorFromRGB(0xffffff);
        _shapeLabel.font = FONT_SCALE(14);
    }
    return _shapeLabel;
}
- (CALayer *)bottomLineLayer{
    
    if (!_bottomLineLayer) {
        _bottomLineLayer = [[CALayer alloc] init];
        _bottomLineLayer.frame = __Rect(0, self.frame.size.height - .5, self.frame.size.width, .5f);
        _bottomLineLayer.backgroundColor = UIColorFromRGB(0x063d27).CGColor;
    }
    return _bottomLineLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
