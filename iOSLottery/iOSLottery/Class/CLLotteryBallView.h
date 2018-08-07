//
//  CLLotteryBallView.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/1.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLLotteryBallView : UIButton

@property (nonatomic, copy) void(^selectBetButtonBlock)(CLLotteryBallView *);
@property (nonatomic, copy) void(^animationStopBlock)();
@property (nonatomic, strong) NSString *contentString;
@property (nonatomic, strong) UIColor *selectColor;


@property (nonatomic, assign) BOOL scaleAnimation;//缩放动画
@property (nonatomic, assign) BOOL randomAnimation;//选中动画（随机选中时使用的动画）

@end
