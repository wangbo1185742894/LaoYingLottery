//
//  CLATManager.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLATManager.h"

#import "CLDEBetDetailModel.h"

#import "CLLotteryPeriodModel.h"

#import "CLATBetCache.h"

NSString *const playMethodTpyeOne = @"直选";

NSString *const playMethodTpyeTwo = @"组三单式";

NSString *const playMethodTpyeThree = @"组三复式";

NSString *const playMethodTpyeFour = @"组六";



@interface CLATManager ()

@property (nonatomic, strong) NSString *gameEn;

@property (nonatomic, assign) CLATPlayMethodType currentPlayMethodType;

/**
 奖金信息字典
 */
@property (nonatomic, strong) NSMutableDictionary *bonusMessageDic;

@property (nonatomic, strong) NSMutableArray *omissionArray;

/**
 
 */
@property (nonatomic, strong) NSMutableDictionary *playSelectedDic;

/**
 注数
 */
@property (nonatomic, assign) NSInteger noteNumber;


@end

@implementation CLATManager

+ (instancetype)shareManager
{
    
    static dispatch_once_t once ;
    static CLATManager *manager = nil;
    dispatch_once(&once, ^{
        
        manager = [[CLATManager alloc] init];
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

- (void)setCurrentPlayMethod:(CLATPlayMethodType)playMethod
{

    _currentPlayMethodType = playMethod;
}

- (CLATPlayMethodType)getCurrentPlayMethodType
{

    return _currentPlayMethodType;
}

#pragma mark ----- 奖金信息 -----
- (void)setBonusMessageWithData:(NSArray *)data
{

    NSArray *nameArr = @[@"0",@"1",@"2",@"3"];
    
    if (data.count != nameArr.count) return;
    
    for (int i = 0; i < data.count ; i ++ ) {
        
        [self.bonusMessageDic setObject:data[i] forKey:nameArr[i]];
    }
    
}

- (NSString *)getCurrentBounsMessage
{

    return self.bonusMessageDic[[self getKey]];
            
}

#pragma mark ----- 遗漏信息 -----
- (void)setOmissionMessageWithData:(NSDictionary *)dic
{
    [self.omissionArray removeAllObjects];
    
    if (!(dic != nil && [dic isKindOfClass:[NSDictionary class]])) return;

    NSArray *zhixuan_s = dic[@"ZHIXUAN_S"];
    
    NSArray *zuxuan3_s = dic[@"ZUXUAN3_S"];
    
    NSArray *zuxuan3_M = dic[@"ZUXUAN3_M"];
    
    NSArray *zuxuan6_S = dic[@"ZUXUAN6_S"];
    
    [self p_getOmissionArray:zhixuan_s number:10];
    
    [self p_getOmissionArray:zuxuan3_s number:10];
    
    [self p_getOmissionArray:zuxuan3_M number:10];
    
    [self p_getOmissionArray:zuxuan6_S number:10];
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
        
        return @[@[],@[],@[]];
        
    }
    return self.omissionArray[_currentPlayMethodType];
}


#pragma mark ----- 保存相关 -----
- (void)saveOneOptions:(NSString *)options withGroupTag:(NSString *)groupTag
{
    
    NSMutableArray *selectedArr = self.playSelectedDic[[self getKey]];
    
    switch (self.currentPlayMethodType) {
        case CLATPlayMothedTypeOne:{
            
            [self p_saveOptions:options toArray:selectedArr[[groupTag integerValue]]];
            
            break;
        }
        case CLATPlayMothedTypeTwo:{
            
            [self p_savePlayMothedTypeTwoOptions:options withGruopTag:[groupTag integerValue]];
            
            break;
        }
            
        case CLATPlayMothedTypeThree:
        case CLATPlayMothedTypeFour:{
            
            [self p_saveOptions:options toArray:selectedArr];
            
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
    
    [selectedArr[tag] removeAllObjects];
    
    [selectedArr[tag] addObject:options];
    
}

- (void)saveOneGroupOptions:(NSArray *)array
{
        
    for (int i = 0; i < array.count; i ++) {
        
        if ([array[i] isKindOfClass:[NSString class]]) {
            
            [self saveOneOptions:array[i] withGroupTag:@"0"];
            continue;
        }
            
           for (NSString *option in array[i]) {
            
            [self saveOneOptions:option withGroupTag:[NSString stringWithFormat:@"%d",i]];
         }
    }
}


#pragma mark ----- 删除相关 -----
- (void)removeOneOptions:(NSString *)options withGroupTag:(NSString *)groupTag
{

    NSString *key = [NSString stringWithFormat:@"%ld",self.currentPlayMethodType];
    
    NSMutableArray *selectedArr = self.playSelectedDic[key];
    
    switch (self.currentPlayMethodType) {
        case CLATPlayMothedTypeOne:{
            
            [self p_removeOptions:options fromArray:selectedArr[[groupTag integerValue]]];
            
            break;
        }
        case CLATPlayMothedTypeTwo:{
            
            [self p_removeOptions:options fromArray:selectedArr[[groupTag integerValue]]];
            
            break;
        }
            
        case CLATPlayMothedTypeThree:
        case CLATPlayMothedTypeFour:{
            
            [self p_removeOptions:options fromArray:selectedArr];
            
            break;
        }
            
        default:
            break;
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
        case CLATPlayMothedTypeOne:{
        

            
            if ([selected[0] count] > 0 || [selected[1] count] > 0 || [selected[2] count] > 0) {
                
                isHas = YES;
            }
            break;
        }
            
        case CLATPlayMothedTypeTwo:{
        
            if ([selected[0] count] > 0 || [selected[1] count] > 0) {
                
                isHas = YES;
            }
            break;
        }
            
        case CLATPlayMothedTypeFour:
        case CLATPlayMothedTypeThree:{
        
            if (selected.count > 0) {
                
                isHas = YES;
            }
            
        }
    }
    
    return isHas;
}

- (NSMutableArray *)getCurrentPlayMethodSelectedOptions
{

    return self.playSelectedDic[[self getKey]];
}

- (NSInteger)getNoteNumber
{

    NSString *key = [NSString stringWithFormat:@"%ld",self.currentPlayMethodType];
    
    switch (self.currentPlayMethodType) {
        case CLATPlayMothedTypeOne:{
            
            self.noteNumber = 1;
            
            for (NSMutableArray *array in self.playSelectedDic[key]) {
                
                self.noteNumber = self.noteNumber * array.count;
            }
            
            return self.noteNumber;
            
            break;
        }
        case CLATPlayMothedTypeTwo:{
            
            NSMutableArray *array = self.playSelectedDic[key];
            if ([array[0] count] == 1 && [array[1] count] == 1) {
                
                self.noteNumber = 1;
            }else{
            
                self.noteNumber = 0;
            }
            
            return self.noteNumber;
            break;
        }
            
        case CLATPlayMothedTypeThree:{
        
        
            NSMutableArray *array = self.playSelectedDic[key];
            
            self.noteNumber = array.count * (array.count  - 1);
            return self.noteNumber;
            break;
        }
        case CLATPlayMothedTypeFour:{
            
            
            NSInteger count = [self.playSelectedDic[key] count];
            
            self.noteNumber = (count * (count - 1) * (count - 2)) / 6;
            return self.noteNumber;
            break;
        }
            
        default:
            return 0;
            break;
    }
}

#pragma mark ------ 保存/生成一组 投注项 ------
- (void)saveOneGroupBetOptionsOfReplaceIndex:(NSInteger)index;
{
    NSMutableArray *array = [self getCurrentPlayMethodSelectedOptions];
    
    switch (self.currentPlayMethodType) {
        case CLATPlayMothedTypeOne:{
            
            NSString *groupOne = [array[0] componentsJoinedByString:@" "];
            NSString *groupTwo = [array[1] componentsJoinedByString:@" "];
            NSString *groupThree = [array[2] componentsJoinedByString:@" "];
            
            CLDEBetDetailModel *model = [[CLDEBetDetailModel alloc] init];
            
            model.betNumber = [NSString stringWithFormat:@"%@|%@|%@",groupOne,groupTwo,groupThree];
            
            model.betNumberArr = [array copy];
            
            model.betNote = [NSString stringWithFormat:@"%ld注",[self getNoteNumber]];
            model.betMoney = [NSString stringWithFormat:@"%ld元",[self getNoteNumber] * 2];
            
            if ([array[0] count] > 1 || [array[1] count] > 1 || [array[2] count] > 1) {
                
                model.betType = @"直选复式";
            
                
            }else{
            
               model.betType = @"直选单式";
            }
            
            model.playMethodType = self.currentPlayMethodType;
            
            model.lotteryNumber = [NSString stringWithFormat:@"%@[ZHIXUAN]",model.betNumber];
            
            if (index > -1) {
                
                [[CLATBetCache shareCache] replaecOneGroupBetOptions:model ofLotteryName:self.gameEn atIndex:index];
                
            }else{
            
                [[CLATBetCache shareCache] saveOneGroupBetOptions:model ofLotteryName:self.gameEn];
            }
            
            break;
        }
        case CLATPlayMothedTypeTwo:{
            
            NSString *groupOne = [array[0] componentsJoinedByString:@" "];
            NSString *groupTwo = [array[1] componentsJoinedByString:@" "];
            
            
            CLDEBetDetailModel *model = [[CLDEBetDetailModel alloc] init];
            
            model.betNumber = [NSString stringWithFormat:@"%@%@%@",groupOne,groupOne,groupTwo];
            
            model.betNumberArr = [array copy];
            
            model.betNote = [NSString stringWithFormat:@"%ld注",[self getNoteNumber]];
            model.betMoney = [NSString stringWithFormat:@"%ld元",[self getNoteNumber] * 2];
            
            model.betType = @"组三单式";
            
            model.playMethodType = self.currentPlayMethodType;
            
            model.lotteryNumber = [NSString stringWithFormat:@"%@[ZUXUAN3]",model.betNumber];
            
            if (index > -1) {
                
                [[CLATBetCache shareCache] replaecOneGroupBetOptions:model ofLotteryName:self.gameEn atIndex:index];
                
            }else{
                
                [[CLATBetCache shareCache] saveOneGroupBetOptions:model ofLotteryName:self.gameEn];
            }
            
            break;
        }
            
        case CLATPlayMothedTypeThree:{
            
            NSString *groupOne = [array componentsJoinedByString:@" "];
        
            CLDEBetDetailModel *model = [[CLDEBetDetailModel alloc] init];
            
            model.betNumber = groupOne;
            
            model.betNumberArr = [array copy];
            
            model.betNote = [NSString stringWithFormat:@"%ld注",[self getNoteNumber]];
            model.betMoney = [NSString stringWithFormat:@"%ld元",[self getNoteNumber] * 2];
            
            model.betType = @"组三复式";
            
            model.playMethodType = self.currentPlayMethodType;
            
            model.lotteryNumber = [NSString stringWithFormat:@"%@[ZUXUAN3]",model.betNumber];
            
            if (index > -1) {
                
                [[CLATBetCache shareCache] replaecOneGroupBetOptions:model ofLotteryName:self.gameEn atIndex:index];
                
            }else{
                
                [[CLATBetCache shareCache] saveOneGroupBetOptions:model ofLotteryName:self.gameEn];
            }
            
            break;
        }
            
            
        case CLATPlayMothedTypeFour:{
            
            NSString *groupOne = [array componentsJoinedByString:@" "];
            
            CLDEBetDetailModel *model = [[CLDEBetDetailModel alloc] init];
            
            model.betNumber = groupOne;
            
            model.betNumberArr = [array copy];
            
            model.betNote = [NSString stringWithFormat:@"%ld注",[self getNoteNumber]];
            model.betMoney = [NSString stringWithFormat:@"%ld元",[self getNoteNumber] * 2];
            
            if (array.count > 3) {
                
                model.betType = @"组六复式";
                model.lotteryNumber = [NSString stringWithFormat:@"%@[ZUXUAN6]",model.betNumber];
                
            }else{
            
                model.betType = @"组六单式";
                model.lotteryNumber = [NSString stringWithFormat:@"%@[ZUXUAN6]",model.betNumber];
            }
            
            model.playMethodType = self.currentPlayMethodType;

            if (index > -1) {
                
                [[CLATBetCache shareCache] replaecOneGroupBetOptions:model ofLotteryName:self.gameEn atIndex:index];
                
            }else{
                
                [[CLATBetCache shareCache] saveOneGroupBetOptions:model ofLotteryName:self.gameEn];
            }
            
            break;
        }
    }
}

#pragma mark ----- 生成随机号 ------
- (NSArray *)getRandomNumber
{
    NSMutableArray *array = self.playSelectedDic[[self getKey]];

    switch (self.currentPlayMethodType) {
        case CLATPlayMothedTypeOne:{
        

            [array[0] removeAllObjects];
            [array[1] removeAllObjects];
            [array[2] removeAllObjects];
            
            NSArray *random = [self randomArrayWithCount:3];
            
            
            for (int i = 0; i < random.count; i ++) {
            
                
                NSString *selectTag = [NSString stringWithFormat:@"%zd",[random[i] integerValue]];
                
                NSString *groupTag = [NSString stringWithFormat:@"%zi",i];
                
                [self saveOneOptions:selectTag withGroupTag:groupTag];
               
                
            }
            return random;
            
           break;
        }
        
        case CLATPlayMothedTypeTwo:{
        
            [array[0] removeAllObjects];
            [array[1] removeAllObjects];
            
            NSArray *random = [self randomArrayWithCount:2];
            
            
            for (int i = 0; i < random.count; i ++) {
                
                
                NSString *selectTag = [NSString stringWithFormat:@"%zd",[random[i] integerValue]];
                NSString *groupTag = [NSString stringWithFormat:@"%zi",i];
                
                [self saveOneOptions:selectTag withGroupTag:groupTag];
                
            }
            return random;
            break;
        }
            
            
        case CLATPlayMothedTypeThree:{
        
            
            [array removeAllObjects];
            
            NSArray *random = [self randomArrayWithCount:2];
            
            
            for (int i = 0; i < random.count; i ++) {
                
                
                NSString *selectTag = [NSString stringWithFormat:@"%zd",[random[i] integerValue]];
                
                [self saveOneOptions:selectTag withGroupTag:@"0"];
            }
            return random;
           
            break;
        }
            
        case CLATPlayMothedTypeFour:{
            
            
            [array removeAllObjects];
            
            NSArray *random = [self randomArrayWithCount:3];
            
            
            for (int i = 0; i < random.count; i ++) {
                
                
                NSString *selectTag = [NSString stringWithFormat:@"%zd",[random[i] integerValue]];
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
    //随机数产生结果
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];

    do {
        
        NSInteger randomNumber = arc4random() % 10;
        
        if (![resultArray containsObject:@(randomNumber)]) {
            
            [resultArray addObject:@(randomNumber)];
        }
        
    } while (resultArray.count < count);
    
    
    return [resultArray sortedArrayUsingSelector:@selector(compare:)];
}


#pragma mark ----- 添加一注随机号 -----
- (void)randomAddOneBetOptions
{

    [self getRandomNumber];
    
    [self saveOneGroupBetOptionsOfReplaceIndex:-1];
    
    [self clearOptions];
}

#pragma mark ----- 提示相关 ------
- (NSString *)getToastText
{

    NSMutableArray *array = [self getCurrentPlayMethodSelectedOptions];
    
    switch (self.currentPlayMethodType) {
        case CLATPlayMothedTypeOne:{
            
            if ([array[0] count] == 0 || [array[1] count] == 0 || [array[2] count] == 0) {
                
                return @"每位至少选择1个号码";
            }

            return @"";
            break;
        }
        case CLATPlayMothedTypeTwo:{
            
            if ([array[0] count] == 0 || [array[1] count] == 0) {
                
                return @"至少选择1个重号和1个单号";
            }
            
            return @"";
            
            break;
        }
            
        case CLATPlayMothedTypeThree:{
        
        
            if (array.count < 2) {
                
                return @"至少选择2个号码";
            }
            
            return @"";
            
            break;
        }
        case CLATPlayMothedTypeFour:{
            
            if (array.count < 3) {
                
                return @"至少选择3个号码";
            }
            
            return @"";
            
            break;
        }
            
        default:
            return @"当前玩法不存在";
            break;
    }

    
}

#pragma mark ----- 清除相关 ------
- (void)clearCurrentPlayMethodSelectedOptions
{

    NSMutableArray *array = [self getCurrentPlayMethodSelectedOptions];
        
    switch (self.currentPlayMethodType) {
        case CLATPlayMothedTypeOne:{
            
            [array[0] removeAllObjects];
            [array[1] removeAllObjects];
            [array[2] removeAllObjects];
            
            break;
        }
        case CLATPlayMothedTypeTwo:{
            
            [array[0] removeAllObjects];
            [array[1] removeAllObjects];
            
            break;
        }
            
        case CLATPlayMothedTypeThree:
        case CLATPlayMothedTypeFour:{
            
            [array removeAllObjects];
            
            break;
        }
    }

}

- (void)clearOptions
{

    self.playSelectedDic = nil;
}



#pragma mark ------ lazyLoad ------
- (NSMutableDictionary *)bonusMessageDic
{

    if (_bonusMessageDic == nil) {
        
        _bonusMessageDic = [NSMutableDictionary dictionary];
    }
    return _bonusMessageDic;
}

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
        
        [_playSelectedDic setValue:@[[NSMutableArray new],[NSMutableArray new],[NSMutableArray new]] forKey:@"0"];
        [_playSelectedDic setValue:@[[NSMutableArray new],[NSMutableArray new]]forKey:@"1"];
        [_playSelectedDic setValue:[NSMutableArray new] forKey:@"2"];
        [_playSelectedDic setValue:[NSMutableArray new]forKey:@"3"];
        
        
    }
    return _playSelectedDic;
}

@end
