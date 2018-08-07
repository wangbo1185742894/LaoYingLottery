//
//  CLDElevenTwoGroupView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/1.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLDElevenMainBetDelegate.h"
@class CLPreTwoDirectBetManager;
@class CLDETwoGroupBetTerm;
@interface CLDElevenTwoGroupView : UIView <CLDElevenMainBetDelegate>
/**
 回调 返回 注数 最小奖金 最大奖金
 */
@property (nonatomic, copy) void(^callBackNoteBonusBlock)(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus);


- (void)randomSelectedNumber;
//获取投注项
@property (nonatomic, strong) CLPreTwoDirectBetManager *betManager;//投注项 控制

//配置默认选中项
- (void)assignSelectBetButtonWithData:(CLDETwoGroupBetTerm *)betTerm;
@end
