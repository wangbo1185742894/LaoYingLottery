//
//  CLATBetCache.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/23.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLATBetCache.h"

#import "CLDEBetDetailModel.h"

@interface CLATBetCache ()

@property (nonatomic, strong) NSMutableDictionary *cacheDic;

@property (nonatomic, strong) NSMutableDictionary *playMethodDic;

@property (nonatomic, strong) NSMutableDictionary *periodDic;

@property (nonatomic, strong) NSMutableDictionary *timesDic;

@property (nonatomic, strong) NSMutableDictionary *betOptionsDic;

@end

@implementation CLATBetCache

+ (instancetype)shareCache
{
    
    static dispatch_once_t once ;
    static CLATBetCache *manager = nil;
    dispatch_once(&once, ^{
        
        manager = [[CLATBetCache alloc] init];
    });
    return manager;
}

#pragma mark ----- 期次 --------
- (void)setPeriod:(NSInteger)period ofLotteryName:(NSString *)lottery;
{

    [self.periodDic setValue:@(period) forKey:lottery];
}

- (NSInteger)getPeriodWithLotteryName:(NSString *)lottery
{

    NSInteger period = [self.periodDic[lottery] integerValue];
    
    return period == 0 ? 1 : period;
    
}


#pragma mark ----- 倍数 -----
- (NSInteger)getTimesWithLotteryName:(NSString *)lottery
{

    NSInteger times = [self.timesDic[lottery] integerValue];
    
    return times == 0 ? 1 : times;
}

- (void)setTimes:(NSInteger)times ofLotteryName:(NSString *)lottery
{
    
    [self.timesDic setValue:@(times) forKey:lottery];
}

#pragma mark ----- 注数 -------
- (NSInteger)getNoteNumberWithLotteryName:(NSString *)lottery
{

    NSMutableArray *array = self.betOptionsDic[lottery];
    
    NSInteger number = 0;
    
    for (CLDEBetDetailModel *model in array) {
        
        number += [model.betNote integerValue];
    }
    
    return number;
}

#pragma mark ----- 当前玩法 --------
- (void)saveCurrentLottery:(NSString *)lotteryName ofPlayMethod:(NSInteger)playMethod
{

    [self.playMethodDic setValue:@(playMethod) forKey:lotteryName];
}


#pragma mark ----- 获取彩种玩法 -----
- (NSInteger)getPlayMethodOfCurrentLottery:(NSString *)lotteryName
{

    NSNumber *number = self.playMethodDic[lotteryName];
    
    if (number == nil) {
        
        return 0;
    }
    return [number integerValue];
}


#pragma mark ----- 保存 -----
- (void)saveOneGroupBetOptions:(CLDEBetDetailModel *)options ofLotteryName:(NSString *)lotteryName
{

    NSMutableArray *betArray = self.betOptionsDic[lotteryName];
    
    if (betArray == nil) {
        
        betArray = [NSMutableArray array];
        
        [betArray insertObject:options atIndex:0];
        
        [self.betOptionsDic setObject:betArray forKey:lotteryName ? lotteryName : @""];
        
    }else{
    
        [betArray insertObject:options atIndex:0];
        
    }
}

#pragma mark ----- 替换 -----
- (void)replaecOneGroupBetOptions:(CLDEBetDetailModel *)options ofLotteryName:(NSString *)lotteryName atIndex:(NSInteger)index
{

    NSMutableArray *betArray = self.betOptionsDic[lotteryName];
    
    [betArray replaceObjectAtIndex:index withObject:options];
}

#pragma mark ----- 删除 -----
- (void)removeOneGroupBetOptionsWithIndex:(NSInteger)index ofLotteryName:(NSString *)lotteryName
{

    NSMutableArray *betArray = self.betOptionsDic[lotteryName];
    
    [betArray removeObjectAtIndex:index];
    
}

- (void)saveBetOptionsCacheWithLotteryName:(NSString *)lotteryName data:(NSMutableArray *)data
{

    [self.cacheDic setObject:data forKey:lotteryName];
    
}

- (NSMutableArray *)getBetOptionsCacheWithLotteryName:(NSString *)lotteryName
{

    return self.betOptionsDic[lotteryName];
    
    //return self.cacheDic[lotteryName];
}

- (void)deleteBetOptionsCacheWithLotteryName:(NSString *)lotteryName
{

    [self.betOptionsDic removeObjectForKey:lotteryName];
    
    [self.timesDic removeObjectForKey:lotteryName];
    [self.periodDic removeObjectForKey:lotteryName];
}


- (id)getBetModelWithIndex:(NSInteger)index lottery:(NSString *)lotteryGameEn;
{
    
    NSMutableArray *betArray = self.betOptionsDic[lotteryGameEn];
    
    return betArray[index];
    
}


#pragma mark ----- 投注串 -----
- (NSString *)getLotteryNumberWithLotteryName:(NSString *)lotteryName;
{
    
    NSMutableArray *betArray = self.betOptionsDic[lotteryName];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    
    for (CLDEBetDetailModel *model in betArray) {
        
        [tempArray addObject:model.lotteryNumber];
    }
    
    NSString *lotteryNumber = [tempArray componentsJoinedByString:@","];
    
    return lotteryNumber;
}


#pragma mark ----- lazyLoad -----
- (NSMutableDictionary *)cacheDic
{

    if (_cacheDic == nil) {
        
        _cacheDic = [NSMutableDictionary dictionary];
    }
    return _cacheDic;
}

- (NSMutableDictionary *)playMethodDic
{
    
    if (_playMethodDic == nil) {
        
        _playMethodDic = [NSMutableDictionary dictionary];
    }
    return _playMethodDic;
}

- (NSMutableDictionary *)periodDic
{

    if (_periodDic == nil) {
        
        _periodDic = [NSMutableDictionary dictionary];
    }
    return _periodDic;
}

- (NSMutableDictionary *)timesDic
{
    
    if (_timesDic == nil) {
        
        _timesDic = [NSMutableDictionary dictionary];
    }
    return _timesDic;
}

- (NSMutableDictionary *)betOptionsDic
{
    
    if (_betOptionsDic == nil) {
        
        _betOptionsDic = [NSMutableDictionary dictionary];
    }
    return _betOptionsDic;
}



@end
