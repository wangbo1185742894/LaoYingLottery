//
//  CLAwardK3View.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLAwardK3View : UIView

/**
 彩种名
 */
@property (nonatomic, strong) UILabel* lottNameLbl;

/**
 时间label
 */
@property (nonatomic, strong) UILabel* timeLbl;

/**
 期次label
 */
@property (nonatomic, strong) UILabel *periodLabel;

/**
 投注号的形态
 */
@property (nonatomic, strong) UILabel *ShapeLabel;

@property (nonatomic) BOOL isShowLotteryName;
@property (nonatomic, assign) BOOL isMidCenter;
- (void) setNumbers:(NSArray*)number;

@end
