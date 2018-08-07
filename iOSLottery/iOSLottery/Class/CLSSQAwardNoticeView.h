//
//  CLSSQAwardNoticeView.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/8.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger , CLAwardLotteryType) {
    
    CLAwardLotteryTypeSSQ,
    CLAwardLotteryTypeDLT
};
@interface CLSSQAwardNoticeView : UIView

@property (nonatomic, strong) UILabel* lotteryNameLbl;
@property (nonatomic, strong) UILabel *periodLabel;//期次label
@property (nonatomic, strong) UILabel* timeLbl;
@property (nonatomic, strong) UILabel *ShapeLabel;

@property (nonatomic, assign) BOOL isCenter;
@property (nonatomic) BOOL isShowLotteryName;

@property (nonatomic, copy) NSArray* numbers;
@property (nonatomic, assign) CLAwardLotteryType type;

- (void)setOnlyShowNumberText:(BOOL)show;

@end
