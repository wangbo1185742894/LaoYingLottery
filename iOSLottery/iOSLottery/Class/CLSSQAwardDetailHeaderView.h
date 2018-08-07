//
//  CLSSQAwardDetailHeaderView.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/8.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLSSQAwardNoticeView.h"
@interface CLSSQAwardDetailHeaderView : UIView

@property (nonatomic, strong) NSString* lotteryNameLbl;
@property (nonatomic, strong) NSString *periodLabel;
@property (nonatomic, strong) NSString* timeLbl;
@property (nonatomic, strong) NSString *ShapeLabel;
@property (nonatomic, strong) NSString *periodScaleTxt;
@property (nonatomic, strong) NSString *bonusScaleTxt;
@property (nonatomic, strong) NSArray *numbers;
@property (nonatomic, assign) CLAwardLotteryType type;//需要赋值在numbers 之前

@end
