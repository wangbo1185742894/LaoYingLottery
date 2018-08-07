//
//  CLDElevenThreeGroupView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/1.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLDElevenMainBetDelegate.h"
@class CLDEPreThreeDirectBetManager;
@class CLDEPreThreeDirectBetTerm;
@interface CLDElevenThreeGroupView : UIView <CLDElevenMainBetDelegate>

/**
 回调 返回 注数 最小奖金 最大奖金
 */
@property (nonatomic, copy) void(^callBackNoteBonusBlock)(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus);



/**
 随机选号
 */
- (void)randomSelectedNumber;

/**
 投注管理
 */
@property (nonatomic, strong) CLDEPreThreeDirectBetManager *betManager;
//配置默认选中项
- (void)assignSelectBetButtonWithData:(CLDEPreThreeDirectBetTerm *)betTerm;
@end
