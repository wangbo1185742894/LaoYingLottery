//
//  CLBaseDrawNoticeView.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/28.
//  Copyright © 2017年 caiqr. All rights reserved.
//  开奖公告baseView

#import <UIKit/UIKit.h>

@class CLAwardVoModel;

@interface CLBaseDrawNoticeView : UIView


/**
 彩种名
 */
@property (nonatomic, strong) UILabel* lotteryNameLabel;

/**
 期次
 */
@property (nonatomic, strong) UILabel *periodLabel;

/**
 开奖日期
 */
@property (nonatomic, strong) UILabel* timeLabel;


@property (nonatomic, strong) UIView *baseView;

@property (nonatomic, strong) UIView* bottomLine;


- (void)setData:(CLAwardVoModel *)data;

/**
 是否显示彩种名
 */
- (void)setShowLotteryName:(BOOL)show;

/**
 是否只显示文字
 */
- (void)setOnlyShowNumberText:(BOOL)show;


/**
 是否居中显示
 */
- (void)setShowInCenter:(BOOL)show;

@end
