//
//  CLQXCManager.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/19.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLQXCManager.h"

#import "CLDEBetDetailModel.h"

#import "CLATBetCache.h"

@interface CLQXCManager ()

@property (nonatomic, strong) NSMutableArray *betOptionsData;

@property (nonatomic, strong) NSString *gameEn;

/**
 中奖信息
 */
@property (nonatomic, strong) NSString *bonusMessage;

/**
 遗漏数据
 */
@property (nonatomic, strong) NSMutableArray *omissionArray;

@end

@implementation CLQXCManager

+ (instancetype)shareManager
{
    
    static dispatch_once_t once ;
    static CLQXCManager *manager = nil;
    dispatch_once(&once, ^{
        
        manager = [[CLQXCManager alloc] init];
    });
    return manager;
}

- (void)setLotteryGame:(NSString *)str
{
    
    _gameEn = str;
    
}

- (void)setBonusMessageWithData:(NSArray *)data
{
    
    if (data == nil || data.count < 1 ) return;
    
    self.bonusMessage = data[0];
}

- (NSString *)getCurrentBounsMessage
{
    
    return self.bonusMessage;
}

#pragma mark ----- 遗漏信息 -----
- (void)setOmissionMessageWithData:(NSDictionary *)dic
{
    [self.omissionArray removeAllObjects];
    
    if (!(dic != nil && [dic isKindOfClass:[NSDictionary class]])) return;
    
    NSArray *one = dic[@"FIRST"];
    NSArray *two = dic[@"SECOND"];
    NSArray *three = dic[@"THIRD"];
    NSArray *four = dic[@"FOURTH"];
    NSArray *five = dic[@"FIFTH"];
    NSArray *six = dic[@"SIXTH"];
    NSArray *seven = dic[@"SEVENTH"];
    
    [self p_getOmissionArrayWithData:one];
    [self p_getOmissionArrayWithData:two];
    [self p_getOmissionArrayWithData:three];
    [self p_getOmissionArrayWithData:four];
    [self p_getOmissionArrayWithData:five];
    [self p_getOmissionArrayWithData:six];
    [self p_getOmissionArrayWithData:seven];
    
}

- (void)p_getOmissionArrayWithData:(NSArray *)data
{

    //数据异常情况
    if (data == nil || data.count == 0) {
        
       [self.omissionArray addObject:@[]];
        
        return;
    }
    
    [self.omissionArray addObject:data];
}

- (NSArray *)getOmissionMessageOfCurrentPlayMethod
{
    
    if (self.omissionArray.count == 0) {
        
        return @[@[],@[],@[],@[],@[],@[],@[]];
        
    }
    return self.omissionArray;
}

#pragma mark ----- 保存选项 ------
- (void)saveOneOptions:(NSString *)options withGroupTag:(NSString *)groupTag
{
    
    NSMutableArray *selectedArr = self.betOptionsData[[groupTag integerValue]];
    
    
    if ([selectedArr containsObject:options]) return;
    
    [selectedArr addObject:options];
}

- (void)saveOneGroupOptions:(NSMutableArray *)array
{
    
    self.betOptionsData = [array mutableCopy];
    
}

- (void)saveOneGroupBetOptionsOfReplaceIndex:(NSInteger)index;
{
    
    CLDEBetDetailModel *model = [[CLDEBetDetailModel alloc] init];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.betOptionsData];
    
    model.betNumberArr = [arr copy];
    
    NSString *betType = @"单式";
    
    NSMutableArray *temp = [NSMutableArray array];
    
    for (NSMutableArray *array in self.betOptionsData) {
        
        NSString *str = [array componentsJoinedByString:@""];
        
        [temp addObject:str];
        
        if (array.count > 1) {
            
            betType = @"复式";
        }
    }
    
    
    
    model.betNumber = [temp componentsJoinedByString:@" | "];
    
    //model.betNumberArr = [NSMutableArray arrayWithArray:[self.betOptionsData mutableCopy]];
    
    model.betNote = [NSString stringWithFormat:@"%ld注",[self getNoteNumber]];
    model.betMoney = [NSString stringWithFormat:@"%ld元",[self getNoteNumber] * 2];
    
    model.betType = betType;
    
    model.lotteryNumber = [temp componentsJoinedByString:@" "];
    
    if (index > -1) {
        
        [[CLATBetCache shareCache] replaecOneGroupBetOptions:model ofLotteryName:self.gameEn atIndex:index];
        
    }else{
        
        [[CLATBetCache shareCache] saveOneGroupBetOptions:model ofLotteryName:self.gameEn];
    }
}

#pragma mark ------ 删除选型 ------
- (void)removeOneOptions:(NSString *)options withGroupTag:(NSString *)groupTag
{
    
    NSMutableArray *selectedArr = self.betOptionsData[[groupTag integerValue]];
    
    
    if (![selectedArr containsObject:options]) return;
    
    [selectedArr removeObject:options];
    
}

#pragma mark ----- 添加一注随机号 -----
- (void)randomAddOneBetOptions
{
    
    [self getRandomNumber];
    
    [self saveOneGroupBetOptionsOfReplaceIndex:-1];
    
    [self clearOptions];
}

#pragma mark ------ 生成随机号 ------
- (NSArray *)getRandomNumber
{
    
    [self clearOptions];
    
    NSArray *temp = [self randomArrayWithCount:7];
    
    for (int i  = 0; i < temp.count; i ++) {
        
        NSString *selectTag = [NSString stringWithFormat:@"%zd",[temp[i] integerValue]];
        
        [self.betOptionsData[i] addObject:selectTag];
    }
    
    return temp;
}


#pragma mark ----- 生成不重复的随机数 -----
-(NSArray *)randomArrayWithCount:(NSInteger)count
{
    //随机数产生结果
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    
    do {
        
        NSInteger random = arc4random() % 10;
        
        if (![resultArray containsObject:@(random)]) {
            
            [resultArray addObject:@(random)];
        }
        
    } while (resultArray.count < count);

    return resultArray;
}

#pragma mark ------ 获取注数 ------
- (NSInteger)getNoteNumber
{
    
    //self.noteNumber = 1;
    
    NSInteger number = 1;
    
    for (NSMutableArray *array in self.betOptionsData) {
        
        number = number * array.count;
    }
    
    return number;
}

#pragma mark ------ 是否有选项 ------
- (BOOL)hasSelectedOptionsOfCurrentPlayMethod
{
    
    //是否有选项
    __block BOOL isHasOptions = NO;
    
    [self.betOptionsData enumerateObjectsUsingBlock:^(NSMutableArray *arr, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (arr.count > 0) {
            
            isHasOptions = YES;
            
            *stop = YES;
        }
    }];
    
    return isHasOptions;
}

- (NSArray *)getCurrentPlayMethodSelectedOptions
{
    
    return self.betOptionsData;
    
}


#pragma mark ------ 提示文字 ------
- (NSString *)getToastText
{
    
    NSString *toast = @"";
    
    for (NSMutableArray *array in self.betOptionsData) {
        
        if (array.count == 0) {
            
            toast = @"每位至少选择1个号码";
        }
    }
    
    return toast;
}

#pragma mark ------ 清空选型 ------
- (void)clearOptions
{
    self.betOptionsData = nil;
}


#pragma mark ----- lazyload ----
- (NSMutableArray *)betOptionsData
{
    
    if (_betOptionsData == nil) {
        
        _betOptionsData = [NSMutableArray arrayWithObjects:
                           [NSMutableArray new],
                           [NSMutableArray new],
                           [NSMutableArray new],
                           [NSMutableArray new],
                           [NSMutableArray new],
                           [NSMutableArray new],
                           [NSMutableArray new],nil];
    }
    return _betOptionsData;
}

- (NSMutableArray *)omissionArray
{
    
    if (_omissionArray == nil) {
        
        _omissionArray = [NSMutableArray new];
    }
    return _omissionArray;
}


@end

