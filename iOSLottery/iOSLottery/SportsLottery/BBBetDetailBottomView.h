//
//  BBBetDetailBottomView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//  篮球投注详情 底部View(选串关 付款)

#import <UIKit/UIKit.h>

@interface BBBetDetailBottomView : UIView

@property (nonatomic, copy) void(^payBlock)();
@property (nonatomic, copy) void(^chuanGuanShowBlock)(BOOL);
/**
 2串1是什么意思
 */
@property (nonatomic, copy) void(^twoChuanOneBlock)();

- (void)hiddenKeyBoard;

- (void)hiddenChuanGuanSelectView;

- (void)reloadBetDetailBottonViewUI;

@end
