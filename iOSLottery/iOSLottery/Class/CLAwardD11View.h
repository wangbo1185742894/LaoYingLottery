//
//  CLAwardD11View.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLAwardD11View : UIView

@property (nonatomic, strong) UILabel* lotteryNameLbl;
@property (nonatomic, strong) UILabel *periodLabel;//期次label
@property (nonatomic, strong) UILabel* timeLbl;
@property (nonatomic, strong) UILabel *ShapeLabel;

@property (nonatomic, assign) BOOL isCenter;
@property (nonatomic) BOOL isShowLotteryName;

@property (nonatomic, copy) NSArray* numbers;

@end
