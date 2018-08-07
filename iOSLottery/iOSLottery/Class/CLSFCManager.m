//
//  CLSFCManager.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/26.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSFCManager.h"

#import "CLSFCBetModel.h"
#import "CLSFCSelectedModel.h"

@interface CLSFCManager ()

/**
 当前玩法
 */
@property (nonatomic, assign) CLSFCPlayMethod currentPlayMethod;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) NSInteger defaultBetTimes;

@property (nonatomic, assign) NSInteger gameId;

@property (nonatomic, strong) NSString *periodId;

@property (nonatomic, assign) NSInteger betTime;

@property (nonatomic, assign) NSInteger maxBetTimes;

@property (nonatomic, assign) long saleEndTime;

@property (nonatomic, assign) NSInteger ifCountdown;

/**
 存储选中项的字典
 */
@property (nonatomic, strong) NSMutableDictionary *selectedDic;

@end

@implementation CLSFCManager

+ (instancetype)shareManager
{
    
    static dispatch_once_t once ;
    static CLSFCManager *manager = nil;
    dispatch_once(&once, ^{
        
        manager = [[CLSFCManager alloc] init];
    });
    return manager;
}


- (void)disposeData:(id)data
{
    
    if (data == nil || ![data isKindOfClass:[NSDictionary class]]) return;
    
    self.defaultBetTimes = [data[@"defaultBetTimes"] integerValue];
    self.maxBetTimes = [data[@"maxBetTimes"] integerValue];
    self.periodId = data[@"periodId"];
    self.gameId = [data[@"gameId"] integerValue];
    self.saleEndTime = [data[@"saleEndTime"] longLongValue];
    self.ifCountdown = [data[@"ifCountdown"] integerValue];
    
    [self setCurrentPlayMethodWithLotteryName:data[@"gameEn"]];
    
    self.dataArray = [CLSFCBetModel mj_objectArrayWithKeyValuesArray:data[@"sfcMatch"]];
}

- (void)setCurrentPlayMethodWithLotteryName:(NSString *)lotteryName
{

    if ([lotteryName.lowercaseString isEqualToString:@"sfc"]) {
        
        self.currentPlayMethod = CLSFCPlayMethodNormal;
    }else{
    
        self.currentPlayMethod = CLSFCPlayMethodRx9;
    }
    
}

- (NSArray *)getListData;
{

    return self.dataArray;
}

- (NSString *)getPeriodId
{

    return self.periodId;
    
}

- (NSString *)getGameId
{

    return [NSString stringWithFormat:@"%ld",self.gameId];
}

- (void)setBetTimes:(NSInteger)times
{

    self.betTime = times;
}

- (NSInteger)getBetTimes
{
    if (self.betTime == 0) {
        
        self.betTime = 1;
    }
    
    return self.betTime;
}

- (NSInteger)getDefaultBetTims
{

    return self.defaultBetTimes;
}

- (NSInteger)getMaxBetTimes
{

    return self.maxBetTimes;
}

- (long)getPeriodTime
{

    return self.saleEndTime;
}

- (NSInteger)getIfCountDown
{

    return self.ifCountdown;
}

#pragma mark ----- 获取投注字符串 -----
- (NSString *)getLotteryNumber
{

    switch (self.currentPlayMethod) {
        case CLSFCPlayMethodNormal:{
            return [self getNormalLotteryNumber];
            break;
        }
        case CLSFCPlayMethodRx9:{
        
            return [self getRx9LotteryNumber];
            break;
        }
    }
}

#pragma mark ----- 获取胜负彩投注字符串 -----
- (NSString *)getNormalLotteryNumber
{

    NSMutableString *number = [NSMutableString new];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"matchId" ascending:YES];
    
    NSArray *dataArray = [self.selectedDic.allValues sortedArrayUsingDescriptors:@[sort]];
    
    for (CLSFCSelectedModel *model in dataArray) {
        
        for (NSString *option in model.optionsArray) {
            
            [number appendString:option];
        }
        
        [number appendString:@" "];
    }
    
    return [number stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
}

#pragma mark ----- 获取任选9投注字符串 -----
- (NSString *)getRx9LotteryNumber
{

    NSMutableString *number = [NSMutableString new];
    
    [self.dataArray enumerateObjectsUsingBlock:^(CLSFCBetModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
       
        CLSFCSelectedModel *selectModel = self.selectedDic[model.serialNumber];
        
        if (selectModel == nil) {
            
            [number appendString:@"-"];
            
        }else{
        
            for (NSString *option in selectModel.optionsArray) {
                
                [number appendString:option];
            }
        }
        
        [number appendString:@" "];
        
    }];
    
    NSString *ext = [number stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return ext;
}


#pragma mark ----- 保存选型 -----
- (void)saveOneOption:(NSString *)options matchId:(NSString *)matchId
{
    if (matchId == nil || matchId.length < 1) return;

    CLSFCSelectedModel *selectedModel = self.selectedDic[matchId];
    
    if (selectedModel) {
        
        if (![selectedModel.optionsArray containsObject:options]) {
            
            [selectedModel.optionsArray addObject:options];
        }
        return;
    }
    
    selectedModel = [[CLSFCSelectedModel alloc] init];
    
    [selectedModel.optionsArray addObject:options];
    
    [self.selectedDic setObject:selectedModel forKey:matchId];
    
}

#pragma mark ----- 删除选项 -----
- (void)removeOneOptions:(NSString *)options matchId:(NSString *)matchId
{

    if (matchId == nil || matchId.length < 1) return;
    
    CLSFCSelectedModel *selectedModel = self.selectedDic[matchId];
    
    if (selectedModel == nil) return;
        
    if ([selectedModel.optionsArray containsObject:options]) {
        
        [selectedModel.optionsArray removeObject:options];
    }
    
    //没有选项时，移除
    if (selectedModel.optionsArray.count == 0) {
        
        [self.selectedDic removeObjectForKey:matchId];
    }
}

- (CLSFCSelectedModel *)getSelectedModelWithMatchId:(NSString *)matchId
{

    return self.selectedDic[matchId];
}

#pragma mark ----- 计算注数 -----
- (NSInteger)getNoteNumber
{
    switch (self.currentPlayMethod) {
        case CLSFCPlayMethodNormal:{
        
            return [self getNormalNoteNumber];
        
            break;
        }
            
        case CLSFCPlayMethodRx9:{
        
            return [self getRx9NoteNumber];
        }

    }

}

#pragma mark ----- 计算胜负彩注数 -----
- (NSInteger)getNormalNoteNumber
{
    NSArray *selectArray = [self.selectedDic allValues];
    
    if (selectArray.count < 14) return 0;
    
    __block NSInteger number = 1;
    
    [selectArray enumerateObjectsUsingBlock:^(CLSFCSelectedModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        number *= model.optionsArray.count;
        
    }];
    
    return number;
    
}


#pragma mark ----- 机选胜负彩注数 -----
- (NSInteger)getRx9NoteNumber
{
    if (self.selectedDic.count < 9) return 0;
    
    
    //获取每场比赛的选中项个数
    NSMutableArray *selectCountArray = [NSMutableArray arrayWithCapacity:0];
    
    
    for (CLSFCSelectedModel *gameInfo in [self.selectedDic allValues]) {
        
        NSInteger count = 0;
        
        count = gameInfo.optionsArray.count;
        
        if (count > 0) {
            
            [selectCountArray addObject:@(count)];
        }
        
    }
    //先排列组合
    NSMutableArray *result = [NSMutableArray array];//结果
    NSMutableArray *list = [NSMutableArray array];//每次递归的子集
    NSInteger pos = 0;//保证子集升序排列
    [self permutationAndCombination:result list:list nums:selectCountArray postion:pos];
    
    //遍历选中的串关
    NSInteger note = 0;

        for (NSArray *res in result) {
            if (res.count == 9) {
                NSInteger oneNum = 1;
                for (NSNumber *num in res) {
                    oneNum *= [num integerValue];
                }
                note += oneNum;
            }
        }
    
    return note;

    
    
}

//排列组合 递归
- (void)permutationAndCombination:(NSMutableArray<NSMutableArray *> *)result
                             list:(NSMutableArray *)list
                             nums:(NSArray *)nums
                          postion:(NSInteger)pos {
    [result addObject:[list mutableCopy]];
    for (NSInteger i = pos; i < nums.count; i++) {
        [list addObject:nums[i]];
        [self permutationAndCombination:result list:list nums:nums postion:i + 1];
        [list removeObjectAtIndex:list.count - 1];
    }
}


#pragma mark ----- 选中个数 -----
- (NSInteger)getSelectOptionsCount
{

    return self.selectedDic.count;
}

- (NSInteger)getMinSelectOptionsCount
{

    switch (self.currentPlayMethod) {
        case CLSFCPlayMethodNormal:{
        
            return 14;
            break;
        }
        
        case CLSFCPlayMethodRx9:{
        
            return 9;
            break;
        };
    }
}

- (NSString *)getToastText
{

    switch (self.currentPlayMethod) {
        case CLSFCPlayMethodNormal:{
        
        
            if (self.selectedDic.count < 14) {
                
                return @"每场比赛请至少选择一个赛果";
                
            }else{

                return @"";
            }
            
            break;
        }
        case CLSFCPlayMethodRx9:{
        
            if (self.selectedDic.count < 9) {
                
                return @"至少选择9场比赛";
                
            }else{
            
                return @"";
            }
        }
    }
    
}

#pragma mark ----- 默认投注倍数 ----
- (NSInteger)getDefaultMultiple
{
    return self.defaultBetTimes;
}

#pragma mark ----- 清空 -----
- (void)clearOptions
{

    self.selectedDic = nil;
}

#pragma mark ----- lazyLoad -----
- (NSArray *)dataArray
{
    
    if (_dataArray == nil) {
        
        _dataArray = [NSArray new];
    }
    return _dataArray;
}

- (NSMutableDictionary *)selectedDic
{

    if (_selectedDic == nil) {
        
        _selectedDic = [NSMutableDictionary new];
    }
    return _selectedDic;
}

@end
