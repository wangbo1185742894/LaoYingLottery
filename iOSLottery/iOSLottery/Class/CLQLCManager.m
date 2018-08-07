//
//  CLQLCManager.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/16.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLQLCManager.h"

#import "CLDEBetDetailModel.h"

#import "CLATBetCache.h"

#import "CLShowHUDManager.h"

#import "CLTools.h"
@interface CLQLCManager ()

@property (nonatomic, strong) NSString *gameEn;

@property (nonatomic, assign) CLQLCPlayMethodType currentPlayMethodType;


@property (nonatomic, strong) NSMutableArray *omissionArray;

/**
 
 */
@property (nonatomic, strong) NSMutableDictionary *playSelectedDic;

/**
 注数
 */
@property (nonatomic, assign) NSInteger noteNumber;


@end

@implementation CLQLCManager

+ (instancetype)shareManager
{
    
    static dispatch_once_t once ;
    static CLQLCManager *manager = nil;
    dispatch_once(&once, ^{
        
        manager = [[CLQLCManager alloc] init];
    });
    return manager;
}

- (NSString *)getKey
{
    return [NSString stringWithFormat:@"%ld",self.currentPlayMethodType];
    
}

- (void)setLotteryGame:(NSString *)str
{
    
    _gameEn = str;
}

- (void)setCurrentPlayMethod:(CLQLCPlayMethodType)playMethod
{
    
    _currentPlayMethodType = playMethod;
}

- (CLQLCPlayMethodType)getCurrentPlayMethodType
{
    
    return _currentPlayMethodType;
}


#pragma mark ----- 遗漏信息 -----
- (void)setOmissionMessageWithData:(NSDictionary *)dic
{
    [self.omissionArray removeAllObjects];
    
    NSArray *array = dic[@"RED"];
    
    if (array == nil || array.count == 0){
        [self.omissionArray addObject:@[]];
        return;
    };
    
    [self.omissionArray addObject:array];
}

- (void)p_getOmissionArray:(NSArray *)array number:(NSInteger)number
{
    NSMutableArray *temp = [NSMutableArray new];
    
    
    //数据异常，添加空数据，防止后面取值越界崩溃
    if (array == nil || array.count == 0) {
        
        [temp addObject:@[]];
        [temp addObject:@[]];
        [temp addObject:@[]];
        
        [self.omissionArray addObject:temp];
        return;
    }
    
    
    NSInteger count= array.count;//数组元素个数
    NSInteger max= number;//几个分割一次
    NSInteger segment= count / max + (count % max== 0 ? 0 : 1);//需要分割几次
    for (int i= 0;i < segment; i++){
        
        NSUInteger star= i*max; //开始位置
        
        NSUInteger end= (i==(segment-1))?(count-i*max)%(max+1):max; //结束位置
        
        NSRange range= NSMakeRange(star,end); //分割范围
        NSArray *subArray= [array subarrayWithRange:range];//开始抽取
        [temp addObject:subArray];
        
    }
    
    [self.omissionArray addObject:temp];
    
}
- (NSArray *)getOmissionMessageOfCurrentPlayMethod
{
    if (self.omissionArray.count == 0) {
        
        return @[];
    }
    
    return self.omissionArray[0];
}


#pragma mark ----- 保存相关 -----
- (void)saveOneOptions:(NSString *)options withGroupTag:(NSString *)groupTag
{
    
    NSMutableArray *selectedArr = self.playSelectedDic[[self getKey]];
    
    
    switch (self.currentPlayMethodType) {
        case CLQLCPlayMothedTypeNormal:{
            
            if (selectedArr.count == 24) {
                
                [CLShowHUDManager showInWindowWithText:@"最多选择24个号码" type:CLShowHUDTypeOnlyText delayTime:1.f];
                
                return;
            }
            
            [self p_saveOptions:options toArray:selectedArr];
            
            break;
        }
        case CLQLCPlayMothedTypeDanTuo:{
            
            NSMutableArray *arr = selectedArr[0];
            
            if ([groupTag integerValue] == 0 && arr.count == 6) {
               
                [CLShowHUDManager showInWindowWithText:@"胆码区最多选择6个号码" type:CLShowHUDTypeOnlyText delayTime:1.f];
                
                return;
            }
            
            [self p_savePlayMothedTypeTwoOptions:options withGruopTag:[groupTag integerValue]];
            
            break;
        }
            
        default:
            break;
    }
    
}

- (void)p_saveOptions:(NSString *)options toArray:(NSMutableArray *)array
{
    
    if ([array containsObject:options]) return;
    
    [array addObject:options];
    
}

- (void)p_savePlayMothedTypeTwoOptions:(NSString *)options withGruopTag:(NSInteger)tag
{
    
    NSMutableArray *selectedArr = self.playSelectedDic[[self getKey]];
    
    if (tag == 0) {
        
        if ([selectedArr[1] containsObject:options]) {
            
            [selectedArr[1] removeObject:options];
        }
        
    }else{
        
        if ([selectedArr[0] containsObject:options]) {
            
            [selectedArr[0] removeObject:options];
        }
        
    }
    
    if ([selectedArr[tag] containsObject:options]) return;
    
    [selectedArr[tag] addObject:options];
    
}

- (void)saveOneGroupOptions:(NSArray *)array
{
    
    NSMutableArray *selectArr = [NSMutableArray arrayWithArray:array];
    
    [self.playSelectedDic setValue:selectArr forKey:[self getKey]];
}


#pragma mark ----- 删除相关 -----
- (void)removeOneOptions:(NSString *)options withGroupTag:(NSString *)groupTag
{
    
    NSMutableArray *selectedArr = self.playSelectedDic[[self getKey]];
    
    switch (self.currentPlayMethodType) {
        case CLQLCPlayMothedTypeNormal:{
            
            [self p_removeOptions:options fromArray:selectedArr];
            
            break;
        }
        case CLQLCPlayMothedTypeDanTuo:{
            
            [self p_removeOptions:options fromArray:selectedArr[[groupTag integerValue]]];
            
            break;
        }
    }
}

- (void)p_removeOptions:(NSString *)options fromArray:(NSMutableArray *)array
{
    
    if (![array containsObject:options]) return;
    
    [array removeObject:options];
    
}

- (BOOL)hasSelectedOptionsOfCurrentPlayMethod
{
    
    BOOL isHas = NO;
    
    NSMutableArray *selected = self.playSelectedDic[[self getKey]];
    
    switch (self.currentPlayMethodType) {
        case CLQLCPlayMothedTypeNormal:{
            
            if ([selected count] > 0) {
                
                isHas = YES;
            }
            break;
        }
            
        case CLQLCPlayMothedTypeDanTuo:{
            
            if ([selected[0] count] > 0 || [selected[1] count] > 0) {
                
                isHas = YES;
            }
            break;
        }
    }
    
    return isHas;
}

- (NSMutableArray *)getCurrentPlayMethodSelectedOptions
{
    
    return self.playSelectedDic[[self getKey]];
}


#pragma mark ----- 计算注数 -----
- (NSInteger)getNoteNumber
{
    
    NSString *key = [NSString stringWithFormat:@"%ld",self.currentPlayMethodType];
    
    switch (self.currentPlayMethodType) {
        case CLQLCPlayMothedTypeNormal:{
            
            NSMutableArray *arr = self.playSelectedDic[key];
            
            self.noteNumber = [self countOfNumber:arr.count];
        
            return self.noteNumber;
            
            break;
        }
        case CLQLCPlayMothedTypeDanTuo:{
            
            NSMutableArray *array = self.playSelectedDic[key];
            
            self.noteNumber = [self getDanTuoNoteWithDanNumber:[array[0] count] tuoNumber:[array[1] count]];
            
            return self.noteNumber;
            break;
        }
    }
}


#pragma mark ----- 计算普通玩法 -----
- (NSInteger)countOfNumber:(NSInteger)number
{

    NSInteger count = 0;
    
    if (number < 7) return count;
    
    if (number == 7) return 1;
    
    return [CLTools getPermutationCombinationNumber:number needCount:7];
    
//    NSInteger m = 1;
//    NSInteger n = 1;
//
//    for (int i = 1; i <= 7; i++) {
//
//        m *= (number - i + 1);
//        n *= (i);
//    }
//
//    count = m / n;
//
//    return count;
}

#pragma mark ----- 计算胆拖玩法 -----
- (NSInteger)getDanTuoNoteWithDanNumber:(NSInteger)dan tuoNumber:(NSInteger)tuo
{
    
    NSInteger count = 0;
    
    if (dan < 1 || tuo < 2 || (dan + tuo) < 8) return count;

    return [CLTools getPermutationCombinationNumber:tuo needCount:7 - dan];
//    NSInteger count = 0;
//
//    if (dan < 1 || tuo < 2 || (dan + tuo) < 8) return count;
//
//    NSInteger m = 1;
//    NSInteger n = 1;
//
//    for (int i = 0; i < tuo - (7 - dan); i++) {
//
//        m *= (tuo - i);
//        n *= (i + 1);
//    }
//
//    count = m / n;
//
//    return count;
    
//    NSInteger count = 0;
//
//    if (tuo < 7 - dan) return count;
//
//    if (tuo == 7 - dan) return 1;
//
//    NSInteger m = 1;
//    NSInteger n = 1;
//
//    for (int i = 1; i < (7 - dan); i++) {
//
//        m *= (tuo - i + 1);
//        n *= (i);
//    }
//
//    count = m / n;
//
//    return count;
}

#pragma mark ------ 保存/生成一组 投注项 ------
- (void)saveOneGroupBetOptionsOfReplaceIndex:(NSInteger)index;
{
    NSArray *array = [self getCurrentPlayMethodSelectedOptions];
    
    switch (self.currentPlayMethodType) {
        case CLQLCPlayMothedTypeNormal:{
            
            CLDEBetDetailModel *model = [[CLDEBetDetailModel alloc] init];
            
            array = [array sortedArrayUsingSelector:@selector(compare:)];
            
            model.betNumber = [array componentsJoinedByString:@" "];
            
            model.betNumberArr = [array copy];
            
            model.betNote = [NSString stringWithFormat:@"%ld注",[self getNoteNumber]];
            model.betMoney = [NSString stringWithFormat:@"%ld元",[self getNoteNumber] * 2];
            
            if (array.count > 7) {
                
                model.betType = @"复式";
                
                
            }else{
                
                model.betType = @"单式";
            }
            
            model.playMethodType = self.currentPlayMethodType;
            
            model.lotteryNumber = [NSString stringWithFormat:@"%@",model.betNumber];
            
            
            if (index > -1) {
                
                [[CLATBetCache shareCache] replaecOneGroupBetOptions:model ofLotteryName:self.gameEn atIndex:index];
                
            }else{
                
                [[CLATBetCache shareCache] saveOneGroupBetOptions:model ofLotteryName:self.gameEn];
            }
            
            break;
        }
        case CLQLCPlayMothedTypeDanTuo:{
            
            
            NSArray *groupOneArr = [array[0] sortedArrayUsingSelector:@selector(compare:)];
            NSArray *groupTwoArr = [array[1] sortedArrayUsingSelector:@selector(compare:)];
            
            NSString *groupOne = [groupOneArr componentsJoinedByString:@" "];
            NSString *groupTwo = [groupTwoArr componentsJoinedByString:@" "];
            
            
            CLDEBetDetailModel *model = [[CLDEBetDetailModel alloc] init];
            
            model.betNumber = [NSString stringWithFormat:@"(%@)%@",groupOne,groupTwo];
            
            model.betNumberArr = [array copy];
            
            model.betNote = [NSString stringWithFormat:@"%ld注",[self getNoteNumber]];
            model.betMoney = [NSString stringWithFormat:@"%ld元",[self getNoteNumber] * 2];
            
            model.betType = @"胆拖";
            
            model.playMethodType = self.currentPlayMethodType;
            
            model.lotteryNumber = [NSString stringWithFormat:@"%@",model.betNumber];
            
            if (index > -1) {
                
                [[CLATBetCache shareCache] replaecOneGroupBetOptions:model ofLotteryName:self.gameEn atIndex:index];
            }else{
            
            [[CLATBetCache shareCache] saveOneGroupBetOptions:model ofLotteryName:self.gameEn];
            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark ----- 生成随机号 ------
- (NSArray *)getRandomNumber
{
    //当前玩法为胆拖玩法时，机选一注，当做普通玩法处理
    self.currentPlayMethodType = CLQLCPlayMothedTypeNormal;
    NSMutableArray *array = self.playSelectedDic[[self getKey]];
    
    switch (self.currentPlayMethodType) {
        case CLQLCPlayMothedTypeNormal:{
            
            
            [array removeAllObjects];
            
            NSArray *random = [self randomArrayWithCount:7];
            
            
            for (int i = 0; i < random.count; i ++) {
                
                
                NSString *selectTag = [NSString stringWithFormat:@"%02zi",[random[i] integerValue] + 1];
                
                [self saveOneOptions:selectTag withGroupTag:@"0"];
                
            }
            return random;
            
            break;
        }
            
        default:
            
            return @[];
            
            break;
    }
    
}


#pragma mark - 生成不重复的随机数
-(NSArray *)randomArrayWithCount:(NSInteger)count
{
    NSString *str = @"";
    #pragma unused(str)
    
    //随机数产生结果
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    
    do {
        
        NSInteger random = arc4random() % 30;
        
        if (![resultArray containsObject:@(random)]) {
            
            [resultArray addObject:@(random)];
        }
        
    } while (resultArray.count < count);
    
   return [resultArray sortedArrayUsingSelector:@selector(compare:)];

}


#pragma mark ----- 添加一注随机号 -----
- (void)randomAddOneBetOptions
{
    
    if (self.currentPlayMethodType == CLQLCPlayMothedTypeDanTuo) {
        
        self.currentPlayMethodType = CLQLCPlayMothedTypeNormal;
    }
    
    [self getRandomNumber];
    
    [self saveOneGroupBetOptionsOfReplaceIndex:-1];
    
    [self clearOptions];
}

#pragma mark ----- 提示相关 ------
- (NSString *)getToastText
{
    
    NSMutableArray *array = [self getCurrentPlayMethodSelectedOptions];
    
    switch (self.currentPlayMethodType) {
        case CLQLCPlayMothedTypeNormal:{
            
            if (array.count < 7) {
                
                return @"至少选择7个号码";
            }
            
            return @"";
            break;
        }
        case CLQLCPlayMothedTypeDanTuo:{
            
            NSUInteger count1 = [array[0] count];
            NSUInteger count2 = [array[1] count];
            
            if (count1 < 1) {
                
                return @"红球胆码至少选1个";
            }
            
            if (count2 < 2) {
                
                return @"红球拖码至少选2个";
            }
            
            if ((count2 + count1) < 8) {
                
               return @"至少选择8个号码";
                
            }
            
            return @"";
            
            break;
        }
    }
}

#pragma mark ----- 清除相关 ------
- (void)clearCurrentPlayMethodSelectedOptions
{
    
    NSMutableArray *array = [self getCurrentPlayMethodSelectedOptions];
    
    switch (self.currentPlayMethodType) {
        case CLQLCPlayMothedTypeNormal:{
            
            [array removeAllObjects];
            
            break;
        }
        case CLQLCPlayMothedTypeDanTuo:{
            
            [array[0] removeAllObjects];
            [array[1] removeAllObjects];
            
            break;
        }
        default:
            break;
    }
    
}

- (void)clearOptions
{
    
    self.playSelectedDic = nil;
}



#pragma mark ------ lazyLoad ------

- (NSMutableArray *)omissionArray
{
    
    if (_omissionArray == nil) {
        
        _omissionArray = [NSMutableArray new];
    }
    return _omissionArray;
}

- (NSMutableDictionary *)playSelectedDic
{
    
    if (_playSelectedDic == nil) {
        
        _playSelectedDic = [NSMutableDictionary dictionary];
        
        [_playSelectedDic setValue:[NSMutableArray new] forKey:@"0"];
        [_playSelectedDic setValue:@[[NSMutableArray new],[NSMutableArray new]] forKey:@"1"];

    }
    return _playSelectedDic;
}

@end
