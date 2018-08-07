//
//  CLHomeQuickGameView.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLHomeQuickGameView.h"
#import "CLK3NumView.h"
#import "CLAwardNumberView.h"
#import "CLConfigMessage.h"
#import "CLHomeQuickBetService.h"
#import "CLLotteryBaseBetTerm.h"
@interface CLHomeQuickGameView ()

/**
 和值label
 */
@property (nonatomic, strong) UILabel* gameMessageLbl;

/**
 等号labal
 */
@property (nonatomic, strong) UILabel *equalLabel;

/**
 快3_view
 */
@property (nonatomic, strong) CLK3NumView* kuai3View;

/**
 11选5_view
 */
@property (nonatomic, strong) CLAwardNumberView* d11View;

/**
 大乐透-双色球_view
 */
@property (nonatomic, strong) UIView *baseView;

/**
 红球view
 */
@property (nonatomic, strong) CLAwardNumberView *redBallView;

/**
 蓝球view
 */
@property (nonatomic, strong) CLAwardNumberView *blueBallView;


@property (nonatomic, strong) CLHomeQuickBetService *quickBetService;//

@end

@implementation CLHomeQuickGameView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self addSubview:self.gameMessageLbl];
        
        [self addSubview:self.equalLabel];
        
        [self addSubview:self.kuai3View];
        
        [self addSubview:self.d11View];
        
        [self addSubview:self.baseView];
        
        [self.baseView addSubview:self.redBallView];
        
        [self.baseView addSubview:self.blueBallView];
        
        [self.kuai3View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self);
            make.width.mas_equalTo(__SCALE(100));
        }];
        
        [self.d11View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self);
            make.height.mas_equalTo(__SCALE(40));
        }];
        
        [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self);
            make.centerX.equalTo(self).offset(__SCALE(- 10.f));
        }];
        
        [self.redBallView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.bottom.equalTo(self.baseView);
            make.height.mas_equalTo(__SCALE(40.f));
        }];
        
        [self.blueBallView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.redBallView.mas_right).offset(self.redBallView.space);
            make.top.bottom.equalTo(self.baseView);
            make.right.equalTo(self.baseView);
        }];
        [self.equalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.kuai3View.mas_right).offset(10.f);
            make.centerY.equalTo(self.kuai3View);
        }];
        [self.gameMessageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.equalLabel.mas_right).offset(10.f);
            make.centerY.equalTo(self.kuai3View);
            make.right.equalTo(self.mas_right);
        }];
    }
    return self;
}


- (void) switchNumberWithArray:(NSArray *)numArray {
    
    if (!(numArray && numArray.count > 0)) return;
    if ([[self.gameEn lowercaseString] hasSuffix:@"d11"]) {
        [self.d11View setNumbers:numArray];
        self.equalLabel.text = @"";
        self.gameMessageLbl.text = @"";
    } else if ([[self.gameEn lowercaseString] hasSuffix:@"kuai3"]) {
        NSInteger sum = 0;
        for (NSString *number in numArray) {
            sum += [number integerValue];
        }
        [self.kuai3View setK3Nums:numArray];
        self.equalLabel.text = @"=";
        self.gameMessageLbl.text = [NSString stringWithFormat:@"和值 %zi",sum];
    } else if ([[self.gameEn lowercaseString] hasSuffix:@"ssq"]){
        
        [self.redBallView setNumbers:[numArray subarrayWithRange:NSMakeRange(0, 6)]];
        [self.blueBallView setNumbers:[numArray subarrayWithRange:NSMakeRange(6, 1)]];
        self.equalLabel.text = @"";
        self.gameMessageLbl.text = @"";
    } else if ([[self.gameEn lowercaseString] hasSuffix:@"dlt"]){
        
        [self.redBallView setNumbers:[numArray subarrayWithRange:NSMakeRange(0, 5)]];
        [self.blueBallView setNumbers:[numArray subarrayWithRange:NSMakeRange(5, 2)]];
        self.equalLabel.text = @"";
        self.gameMessageLbl.text = @"";
    }
}

- (void)setGameEn:(NSString *)gameEn {
    
    _gameEn = gameEn;
    self.kuai3View.hidden = ![[_gameEn lowercaseString] hasSuffix:@"kuai3"];
    self.d11View.hidden = ![[_gameEn lowercaseString] hasSuffix:@"d11"];
    self.baseView.hidden = !([[_gameEn lowercaseString] hasSuffix:@"ssq"] || [[_gameEn lowercaseString] hasSuffix:@"dlt"]);
}

- (CLHomeQuickBetService *)quickBetService{
    
    if (!_quickBetService) {
        _quickBetService = [[CLHomeQuickBetService alloc] init];
    }
    return _quickBetService;
}

#pragma mark --- lazyLoad ---
- (UILabel *)gameMessageLbl
{

    if (_gameMessageLbl == nil) {
        
        _gameMessageLbl = [[UILabel alloc] init];
        _gameMessageLbl.backgroundColor = [UIColor clearColor];
        _gameMessageLbl.textColor = THEME_COLOR;
        _gameMessageLbl.font = FONT_SCALE(15);
    }

    return _gameMessageLbl;
}

- (UILabel *)equalLabel
{

    if (_equalLabel == nil) {
        
        _equalLabel = [[UILabel alloc] init];
        _equalLabel.backgroundColor = [UIColor clearColor];
        _equalLabel.textColor = UIColorFromRGB(0x333333);
        _equalLabel.font = FONT_SCALE(15);
    }

    return _equalLabel;

}

- (CLK3NumView *)kuai3View
{

    if (_kuai3View == nil) {
        
        _kuai3View = [[CLK3NumView alloc] init];
    }
    
    return _kuai3View;
}

- (CLAwardNumberView *)d11View
{

    if (_d11View == nil) {
        
        _d11View = [[CLAwardNumberView alloc] init];
        _d11View.ballColor = THEME_COLOR;
    }

    return _d11View;
}

- (UIView *)baseView
{

    if (_baseView == nil) {
        
        _baseView = [[UIView alloc] init];        
    }

    return _baseView;
}

- (CLAwardNumberView *)redBallView
{

    if (_redBallView == nil) {
        
        _redBallView = [[CLAwardNumberView alloc] init];
        _redBallView.ballColor = THEME_COLOR;
        _redBallView.space = __SCALE(5.f);
    }
    
    return _redBallView;
}

- (CLAwardNumberView *)blueBallView
{

    if (_blueBallView == nil) {
        
        _blueBallView = [[CLAwardNumberView alloc] init];
        _blueBallView.ballColor = UIColorFromRGB(0x295fcc);
        _blueBallView.space = __SCALE(5.f);
    }

    return _blueBallView;
}


@end



