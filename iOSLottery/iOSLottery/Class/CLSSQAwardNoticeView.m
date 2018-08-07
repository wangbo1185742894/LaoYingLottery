//
//  CLSSQAwardNoticeView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/8.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSSQAwardNoticeView.h"
#import "CLAwardNumberView.h"
#import "CLConfigMessage.h"

@interface CLSSQAwardNoticeView ()

@property (nonatomic, strong) UIView *baseView;

@property (nonatomic, strong) CLAwardNumberView* redView;
@property (nonatomic, strong) CLAwardNumberView* blueView;

@end

@implementation CLSSQAwardNoticeView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.isCenter = NO;
        
        self.baseView = [[UIView alloc] init];
        
        self.lotteryNameLbl = [[UILabel alloc] init];
        self.lotteryNameLbl.backgroundColor = [UIColor clearColor];
        self.lotteryNameLbl.font = FONT_SCALE(15);
        self.lotteryNameLbl.textColor = UIColorFromRGB(0x333333);
        
        self.periodLabel = [[UILabel alloc] init];
        self.periodLabel.backgroundColor = [UIColor clearColor];
        self.periodLabel.textColor = UIColorFromRGB(0x999999);
        self.periodLabel.font = FONT_SCALE(12);
        
        self.timeLbl = [[UILabel alloc] init];
        self.timeLbl.backgroundColor = [UIColor clearColor];
        self.timeLbl.font = FONT_SCALE(12);
        self.timeLbl.textColor = UIColorFromRGB(0x999999);
        
        self.ShapeLabel = [[UILabel alloc] init];
        self.ShapeLabel.backgroundColor = [UIColor clearColor];
        self.ShapeLabel.textColor = UIColorFromRGB(0x999999);
        self.ShapeLabel.font = FONT_SCALE(12);
        
        self.redView =[[CLAwardNumberView alloc] init];
        self.redView.ballColor = THEME_COLOR;
        self.redView.space = __SCALE(5.f);
        self.redView.ballWidthHeight = __SCALE(30.f);
        
        self.blueView =[[CLAwardNumberView alloc] init];
        self.blueView.ballColor = UIColorFromRGB(0x295fcc);
        self.blueView.space = __SCALE(5.f);
        self.blueView.ballWidthHeight = __SCALE(30.f);
        
        [self addSubview:self.ShapeLabel];
        [self addSubview:self.lotteryNameLbl];
        [self addSubview:self.timeLbl];
        [self addSubview:self.baseView];
        [self.baseView addSubview:self.redView];
        [self.baseView addSubview:self.blueView];
        [self addSubview:self.periodLabel];
        
        [self.lotteryNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(__SCALE(10));
            make.bottom.equalTo(self.periodLabel);
            make.height.mas_equalTo(__SCALE(30));
        }];
        
        [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.lotteryNameLbl.mas_right).offset(__SCALE(5.f));
            make.centerY.equalTo(self.mas_bottom).multipliedBy(.26f);
            make.height.equalTo(self.lotteryNameLbl);
        }];
        
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.periodLabel.mas_right).offset(__SCALE(5.f));
            make.bottom.equalTo(self.periodLabel);
            make.height.equalTo(self.lotteryNameLbl);
        }];
        
        [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.lotteryNameLbl);
            make.bottom.equalTo(self.mas_bottom).offset(__SCALE(- 15.f));
        }];
        
        [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.baseView);
            make.height.equalTo(self).multipliedBy(.33f);
            make.top.bottom.equalTo(self.baseView.mas_bottom);
        }];
        [self.blueView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.redView.mas_right).offset(self.redView.space);
            make.height.equalTo(self).multipliedBy(.33f);
            make.top.bottom.right.equalTo(self.baseView);
        }];
        
        [self.ShapeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.redView.mas_right).offset(__SCALE(5.f));
            make.centerY.equalTo(self.redView);
        }];
        
    }
    return self;
}

- (void)setIsShowLotteryName:(BOOL)isShowLotteryName {
    
    self.lotteryNameLbl.hidden = !isShowLotteryName;
    if (isShowLotteryName) {
        [self.lotteryNameLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(__SCALE(10));
            make.bottom.equalTo(self.periodLabel);
            make.height.mas_equalTo(__SCALE(30));
        }];
    }else{
        [self.lotteryNameLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(__SCALE(10));
            make.centerY.equalTo(self.mas_bottom).multipliedBy(.25f);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(__SCALE(30));
        }];
    }
    
    
    [self updateConstraints];
}

- (void)setOnlyShowNumberText:(BOOL)show
{

    [self.redView setOnlyShowText:show];
    [self.blueView setOnlyShowText:show];
}

- (void)setIsCenter:(BOOL)isCenter{
    
    if (isCenter) {
        [self.baseView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(__SCALE(- 15.f));
        }];
    }else{
        
        [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lotteryNameLbl);
            make.bottom.equalTo(self.mas_bottom).offset(__SCALE(- 15.f));
        }];
    }
}

- (void)setNumbers:(NSArray *)numbers {
    
    if (self.type == CLAwardLotteryTypeSSQ) {
        self.redView.numbers = [numbers subarrayWithRange:NSMakeRange(0, numbers.count - 1)];
        self.blueView.numbers = [numbers subarrayWithRange:NSMakeRange(numbers.count - 1, 1)];
    }else if (self.type == CLAwardLotteryTypeDLT){
        self.redView.numbers = [numbers subarrayWithRange:NSMakeRange(0, numbers.count - 2)];
        self.blueView.numbers = [numbers subarrayWithRange:NSMakeRange(numbers.count - 2, 2)];
    }
}

@end
