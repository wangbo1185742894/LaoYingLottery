//
//  SLOddsButton.m
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLOddsButton.h"
#import "SLConfigMessage.h"
#import "UIImage+SLImage.h"
@interface SLOddsButton ()

@property (nonatomic, strong) UIView *baseView;

@property (nonatomic, assign) SLOddsButtonType type;

@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UIView *rightLineView;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;



@end

@implementation SLOddsButton

- (instancetype)initWithType:(SLOddsButtonType)type{
    
    self = [super init];
    if (self) {
        [self addSubview:self.baseView];
        [self addSubview:self.leftLineView];
        [self addSubview:self.rightLineView];
        [self addSubview:self.topLineView];
        [self addSubview:self.bottomLineView];
        [self.baseView addSubview:self.playMothedLabel];
        [self.baseView addSubview:self.oddsLabel];
//        [self addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        self.type = type;
        [self setBackgroundImage:[UIImage sl_imageWithColor:SL_UIColorFromRGB(0xffffff)] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage sl_imageWithColor:SL_UIColorFromRGB(0xe63222)] forState:UIControlStateSelected];
        
        [self configConstrain];
    }
    return self;
}

//- (void)onClick:(UIButton *)btn{
//    
//    self.selected = !self.selected;
//}

- (void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    self.playMothedLabel.textColor = selected ? SL_UIColorFromRGB(0xffffff) : SL_UIColorFromRGB(0x333333);
    self.oddsLabel.textColor = selected ? SL_UIColorFromRGB(0xffffff) : SL_UIColorFromRGB(0x999999);
}

- (void)configConstrain{
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self);
    }];
    
    if (self.type == SLOddsButtonTypeHorizontal) {
        //横向
        [self.playMothedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.baseView);
            make.centerY.equalTo(self.baseView);
            
        }];
        [self.oddsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.playMothedLabel.mas_right).offset(SL__SCALE(3.f));
            make.centerY.equalTo(self.playMothedLabel);
            make.right.equalTo(self.baseView);
        }];
    }else if (self.type == SLOddsButtonTypeVertical){
        
        //纵向
        [self.playMothedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.baseView);
            make.centerX.equalTo(self.baseView);
            
        }];
        [self.oddsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.playMothedLabel.mas_bottom).offset(SL__SCALE(3.f));
            make.centerX.equalTo(self.playMothedLabel);
            make.bottom.equalTo(self.baseView);
        }];
    }
    
    
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(0.51f);
    }];
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.top.bottom.equalTo(self);
        make.width.mas_equalTo(0.51f);
    }];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(0.51f);
    }];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.51f);
    }];
    
}



- (void)setShowLeftLine:(BOOL)showLeftLine{
    
    self.leftLineView.hidden = !showLeftLine;
}

- (void)setShowRightLine:(BOOL)showRightLine{
    
    self.rightLineView.hidden = !showRightLine;
}
- (void)setShowTopLine:(BOOL)showTopLine{
    
    self.topLineView.hidden = !showTopLine;
}

- (void)setShowBottomLine:(BOOL)showBottomLine{
    
    self.bottomLineView.hidden = !showBottomLine;
}

#pragma mark ------------ getter Mothed ------------
- (UIView *)baseView{
    
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:CGRectZero];
        _baseView.backgroundColor = [UIColor clearColor];
    }
    return _baseView;
}
- (UILabel *)playMothedLabel{
    
    if (!_playMothedLabel) {
        _playMothedLabel = [[UILabel alloc] init];
        _playMothedLabel.text = @"主胜";
        _playMothedLabel.font = SL_FONT_SCALE(13.f);
        _playMothedLabel.textColor = SL_UIColorFromRGB(0x333333);
    }
    return _playMothedLabel;
}

- (UILabel *)oddsLabel{
    
    if (!_oddsLabel) {
        _oddsLabel = [[UILabel alloc] init];
        _oddsLabel.text = @"11.11";
        _oddsLabel.font = SL_FONT_SCALE(11.f);
        _oddsLabel.textColor = SL_UIColorFromRGB(0x999999);
    }
    return _oddsLabel;
}

- (UIView *)leftLineView{
    
    if (!_leftLineView) {
        _leftLineView = [[UIView alloc] init];
        _leftLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
        _leftLineView.hidden = YES;
    }
    return _leftLineView;
}
- (UIView *)rightLineView{
    
    if (!_rightLineView) {
        _rightLineView = [[UIView alloc] init];
        _rightLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
        _rightLineView.hidden = YES;
    }
    return _rightLineView;
}
- (UIView *)topLineView{
    
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
        _topLineView.hidden = YES;
    }
    return _topLineView;
}
- (UIView *)bottomLineView{
    
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
        _bottomLineView.hidden = YES;
    }
    return _bottomLineView;
}
@end
