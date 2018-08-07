//
//  CLAwardK3View.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLAwardK3View.h"
#import "CLK3NumView.h"
#import "CLConfigMessage.h"

@interface CLAwardK3View ()

@property (nonatomic, strong) UIView* backView;
@property (nonatomic, strong) CLK3NumView* numView;
@property (nonatomic, strong) UILabel* msgLbl;
@property (nonatomic, strong) UIView *baseView;

@end

@implementation CLAwardK3View

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubviews];
        [self addConstraints];
        
        self.isMidCenter = NO;

    }
    return self;
}

- (void)addSubviews
{

    [self addSubview:self.lottNameLbl];
    [self addSubview:self.timeLbl];
    [self addSubview:self.periodLabel];
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.backView];
    [self.backView addSubview:self.numView];
    [self.baseView addSubview:self.msgLbl];
    [self.baseView addSubview:self.ShapeLabel];
    
}

- (void)addConstraints
{

    [self.lottNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(CL__SCALE(15.f));
        make.top.equalTo(self).offset(CL__SCALE(15.f));
    }];
    
    [self.periodLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.lottNameLbl.mas_right).offset(CL__SCALE(5.f));
        make.centerY.equalTo(self.mas_bottom).multipliedBy(.26f);
    }];
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.periodLabel.mas_right).offset(CL__SCALE(5.f));
        make.bottom.equalTo(self.periodLabel);
    }];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(CL__SCALE(10.f));
        make.bottom.equalTo(self).offset(CL__SCALE(- 15.f));
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView);
        make.height.equalTo(self).multipliedBy(.33f);
        make.bottom.equalTo(self.baseView);
        make.width.mas_equalTo(__SCALE(130));
    }];
    
    [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.backView);
        make.width.equalTo(self.backView).multipliedBy(.8f);
        make.height.equalTo(self.backView);
        
    }];
    
    [self.msgLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_right).offset(__SCALE(10));
        make.top.bottom.equalTo(self.backView);
    }];
    
    [self.ShapeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.msgLbl.mas_right).offset(__SCALE(10.f));
        make.centerY.equalTo(self.msgLbl);
        make.right.equalTo(self.baseView);
    }];
    
}

- (void) setNumbers:(NSArray*)number {
    
    [self.numView setK3Nums:number];
    
    NSInteger sum = [number[0] integerValue] + [number[1] integerValue] + [number[2] integerValue];
    self.msgLbl.text = [NSString stringWithFormat:@"和值:%zi",sum];
}

- (void)setIsShowLotteryName:(BOOL)isShowLotteryName {
    
    self.lottNameLbl.hidden = !isShowLotteryName;
    if (isShowLotteryName) {
        [self.lottNameLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(CL__SCALE(10));
            make.bottom.equalTo(self.periodLabel);
        }];
    }else{
        [self.lottNameLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(CL__SCALE(10));
            make.bottom.equalTo(self.periodLabel);
            make.width.mas_equalTo(0);
        }];
    }
    
    [self updateConstraints];
}
- (void)setIsMidCenter:(BOOL)isMidCenter{
    
    if (isMidCenter) {
        [self.baseView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(__SCALE(- 15.f));
        }];
    }else{
        [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self).offset(__SCALE(10.f));
            make.bottom.equalTo(self).offset(__SCALE(- 15.f));
        }];
    }
}
- (void)layoutSublayersOfLayer:(CALayer *)layer {
    
    [super layoutSublayersOfLayer:layer];
    self.backView.layer.cornerRadius = (self.backView.bounds.size.height / 2.f);
}

#pragma mark --- Get Method ---
- (UILabel *)lottNameLbl
{

    if (_lottNameLbl == nil) {
        
        _lottNameLbl = [[UILabel alloc] init];
        _lottNameLbl.backgroundColor = [UIColor clearColor];
        _lottNameLbl.textColor = UIColorFromRGB(0x333333);
        _lottNameLbl.font = FONT_SCALE(15);
    }
    return _lottNameLbl;
}

- (UILabel *)periodLabel
{

    if (_periodLabel == nil) {
        
        _periodLabel = [[UILabel alloc] init];
        _periodLabel.backgroundColor = [UIColor clearColor];
        _periodLabel.textColor = UIColorFromRGB(0x999999);
        _periodLabel.font = FONT_SCALE(12);
        
    }
    return _periodLabel;
}

- (UILabel *)timeLbl
{

    if (_timeLbl == nil) {
        
        _timeLbl = [[UILabel alloc] init];
        _timeLbl.backgroundColor = [UIColor clearColor];
        _timeLbl.textColor = UIColorFromRGB(0x999999);
        _timeLbl.font = FONT_SCALE(12);

    }
    return _timeLbl;
}

- (UILabel *)ShapeLabel
{

    if (_ShapeLabel == nil) {
        
        _ShapeLabel = [[UILabel alloc] init];
        _ShapeLabel.backgroundColor = [UIColor clearColor];
        _ShapeLabel.textColor = UIColorFromRGB(0x333333);
        _ShapeLabel.font = FONT_SCALE(15);
    }
    return _ShapeLabel;
}

- (UIView *)backView
{

    if (_backView == nil) {
        
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColorFromRGB(0x339966);
    }
    return _backView;
}

- (CLK3NumView *)numView
{

    if (_numView == nil) {
        
        _numView = [[CLK3NumView alloc] init];
    }
    return _numView;
}

- (UILabel *)msgLbl
{

    if (_msgLbl == nil) {
        
        _msgLbl = [[UILabel alloc] init];
        _msgLbl.backgroundColor = [UIColor clearColor];
        _msgLbl.textColor = UIColorFromRGB(0x333333);
        _msgLbl.font = FONT_SCALE(15);
    }
    return _msgLbl;
}

- (UIView *)baseView
{

    if (_baseView == nil) {
        
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = CLEARCOLOR;
        
    }
    return _baseView;
}

@end
