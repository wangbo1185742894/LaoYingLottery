//
//  CLFTBetViewDelegate.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/24.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLFTBonusInfo;
@protocol CLFTBetViewDelegate <NSObject>
@optional
//投注页面配置默认选项
- (void)assignUIWithData:(id)data;
//投注页面清空数据
- (void)clearAllBetButton;
//刷新奖金信息
- (void)ft_RefreshBonusInfo:(CLFTBonusInfo *)bonusInfo;
//返回是否有投注项
- (BOOL)ft_hasSelectBetButton;
//隐藏或展示遗漏
- (void)hiddenOmission:(BOOL)hidden;
//设置遗漏
- (void)setOmissionWithData:(NSArray *)omission;
//设置默认遗漏
- (void)setDefaultOmission;
//配置活动链接按钮
- (void)assignActicityLink:(id)data;
//配置奖金信息
- (void)assignBonusInfo:(NSArray *)bonusInfo;
@end
