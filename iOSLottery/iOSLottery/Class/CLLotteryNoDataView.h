//
//  CLLotteryNoDataView.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/2/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//  D11 排列3 排列5 投注列表 近期开奖 无数据View

#import <UIKit/UIKit.h>

@interface CLLotteryNoDataView : UIView

@property (nonatomic, copy) void(^emptyBtnBlock)();

@end
