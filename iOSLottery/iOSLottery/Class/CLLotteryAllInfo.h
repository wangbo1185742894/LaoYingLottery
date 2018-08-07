//
//  CLLotteryAllInfo.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//
//全局单例  缓存   控制各个彩种页面UI的数据

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class CLLotteryMainBetModel;
@interface CLLotteryAllInfo : NSObject

/**
 快三执行过开奖动画的期次
 */
@property (nonatomic, strong) NSMutableDictionary *ft_animationPeriodDic;


+ (CLLotteryAllInfo *)shareLotteryAllInfo;
#pragma mark ------ 彩种 ------
//存储彩种基本信息
- (void)setMainRequestData:(CLLotteryMainBetModel *)requestData gameEn:(NSString *)lotteryGameEn;
//存储彩种的上一次玩法
- (void)setPlayMothed:(NSInteger)playMothed gameEn:(NSString *)lotteryGameEn;
//获取彩种的基本信息
- (CLLotteryMainBetModel *)getMainRequestDataWithGameEn:(NSString *)lotteryGameEn;
//获取彩种的上一次玩法
- (NSInteger)getPlayMothedWithGameEn:(NSString *)lotteryGameEn;

/**
 设置是否显示遗漏
 */
- (void)setShowOmission:(BOOL)omission gameEn:(NSString *)gameEn;
/**
 是否显示遗漏
 */
- (BOOL)getShowOmissionWithGameEn:(NSString *)gameEn;



@end

