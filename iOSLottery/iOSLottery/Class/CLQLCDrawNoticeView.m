//
//  CLQLCDrawNoticeView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/20.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLQLCDrawNoticeView.h"

#import "CLConfigMessage.h"

#import "CLAwardNumberView.h"

#import "CLAwardVoModel.h"

@interface CLQLCDrawNoticeView ()

@property (nonatomic, strong) CLAwardNumberView *redNumbers;

@property (nonatomic, strong) CLAwardNumberView *bullNumber;


@end

@implementation CLQLCDrawNoticeView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self p_addSubviews];
        [self p_addConstraints];
    }
    return self;
}

- (void)p_addSubviews
{
    [self.baseView addSubview:self.redNumbers];
    [self.baseView addSubview:self.bullNumber];
}

- (void)p_addConstraints
{
    
    [self.redNumbers mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView);
        make.top.equalTo(self.baseView).offset(CL__SCALE(18.f));
        make.height.mas_equalTo(CL__SCALE(35.f));
    }];
    
    [self.bullNumber mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.redNumbers.mas_right).offset(CL__SCALE(5.f));
        make.height.centerY.equalTo(self.redNumbers);
    }];
    
}
- (void)setData:(CLAwardVoModel *)data
{
    [super setData:data];
    
    NSArray *arr = [data.winningNumbers componentsSeparatedByString:@":"];
    
    if ([data.gameEn isEqualToString:@"qlc"]) {
        
        self.bullNumber.hidden = NO;
        
        self.redNumbers.showTwoPlaces = YES;
        self.bullNumber.showTwoPlaces = YES;
        
        self.bullNumber.numbers  = [arr[1] componentsSeparatedByString:@""];
                
    }else{
        
        self.bullNumber.hidden = YES;
        
        [self.bullNumber mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(0);
            
        }];
    }
    
    self.redNumbers.numbers = [arr[0] componentsSeparatedByString:@" "];
    
//    [self updateConstraintsIfNeeded];
}

- (void)setOnlyShowNumberText:(BOOL)show
{
    [self.redNumbers setOnlyShowText:show];
    
    [self.bullNumber setOnlyShowText:show];
}

- (void)setShowInCenter:(BOOL)show
{
    
    //默认是不居中显示
    if (show == NO) return;

    [self.redNumbers mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.baseView).offset(CL__SCALE(20.f));
    }];

    [self updateConstraintsIfNeeded];
    
}

#pragma mark ------- lazyLoad -------

- (CLAwardNumberView *)redNumbers
{
    if (_redNumbers == nil) {
        
        _redNumbers =[[CLAwardNumberView alloc] init];
        _redNumbers.ballColor = THEME_COLOR;
        _redNumbers.space = CL__SCALE(5.f);
        _redNumbers.ballWidthHeight = CL__SCALE(35.f);
        
        _redNumbers.showTwoPlaces = NO;
        
    }
    return _redNumbers;
}

- (CLAwardNumberView *)bullNumber
{
    if (_bullNumber == nil) {
        
        _bullNumber =[[CLAwardNumberView alloc] init];
        _bullNumber.ballColor = UIColorFromRGB(0x295FCC);
        _bullNumber.space = CL__SCALE(5.f);
        _bullNumber.ballWidthHeight = CL__SCALE(35.f);
        
        _bullNumber.showTwoPlaces = NO;
        
    }
    return _bullNumber;
}

@end
