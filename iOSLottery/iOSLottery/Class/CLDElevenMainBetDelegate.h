//
//  CLDElevenMainBetDelegate.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/29.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLDElevenConfigMessage.h"
@class CLDEBonusInfo;
@protocol CLDElevenMainBetDelegate <NSObject>

@property (nonatomic, assign) CLDElevenPlayMothedType playMothedType;
//是否有选中项
- (BOOL)de_hasSelectedBetButton;
//投注页面清空数据
- (void)clearAllBetButton;
//配置遗漏信息
- (void)de_setOmissionData:(NSArray *)omission;
//配置活动链接
- (void)assignActicityLink:(id)data;
//配置奖金信息
- (void)assignBonusInfo:(NSString *)bonusInfo;
//配置奖级
- (void)assignAward:(CLDEBonusInfo *)awardInfo;
@end
