//
//  CLDElevenAnySelectView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/29.
//  Copyright © 2016年 caiqr. All rights reserved.
// 任选 View

#import <UIKit/UIKit.h>
#import "CLDElevenMainBetDelegate.h"
@class CLDEAnyBetTerm;
@interface CLDElevenAnySelectView : UIView <CLDElevenMainBetDelegate>

/**
 回调 返回 注数 最小奖金 最大奖金
 */
@property (nonatomic, copy) void(^callBackNoteBonusBlock)(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus);

//随机选号
- (void)randomSelectedNumber;
//获取投注项
@property (nonatomic, strong) CLDEAnyBetTerm *anyBetTerm;//投注项
//配置默认选中项
- (void)assignSelectBetButtonWithData:(CLDEAnyBetTerm *)betTerm;
@end

