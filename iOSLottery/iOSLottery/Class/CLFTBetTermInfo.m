//
//  CLFTBetTermInfo.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/7.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTBetTermInfo.h"
#import "CLFTHeZhiBetInfo.h"
#import "CLFTThreeSameSingleBetInfo.h"
#import "CLFTTwoSameSingleBetInfo.h"
#import "CLFTThreeDifferentBetInfo.h"
#import "CLFTTwoDifferentBetInfo.h"
#import "CLFTDanThreeDifferentBetInfo.h"
#import "CLFTDanTwoDifferentBetInfo.h"
@interface CLFTBetTermInfo ()

@property (nonatomic, strong) NSMutableArray *ft_BetTermArray;
@property (nonatomic, assign) CLFastThreePlayMothedType ft_PlayMothedType;//记录玩法

@end
@implementation CLFTBetTermInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.period = 1;
        self.multiple = 1;
        self.ft_BetTermArray = [NSMutableArray arrayWithCapacity:0];
        self.ft_PlayMothedType = CLFastThreePlayMothedTypeHeZhi;
    }
    return self;
}
#pragma mark ------ public Mothed ------
#pragma mark - 返回投注订单串
- (NSString *)getOrderBetNumber{
    
    NSMutableArray *orderNumberArray = [NSMutableArray arrayWithCapacity:0];
    for (CLLotteryBaseBetTerm * betInfo in self.ft_BetTermArray) {
        [orderNumberArray addObject:betInfo.orderBetNumber];
    }
    return [orderNumberArray componentsJoinedByString:@","];
}
#pragma mark - 添加一个投注项
- (void)addLotteryBetTerm:(NSArray *)betTermInfo{
    
    [self.ft_BetTermArray addObjectsFromArray:betTermInfo];
    if (((NSArray *)betTermInfo).count > 0) {
        self.ft_PlayMothedType = ((CLLotteryBaseBetTerm *)(betTermInfo[0])).playMothedType;
    }
}
#pragma mark - 替换一个投注项
- (void)replaceLotteryBetTerm:(NSArray *)betTermInfo index:(NSInteger)index{
    
    if (self.ft_BetTermArray.count > index) {
        [self.ft_BetTermArray replaceObjectsInRange:NSMakeRange(index, 1) withObjectsFromArray:betTermInfo];
        if (((NSArray *)betTermInfo).count > 0) {
            self.ft_PlayMothedType = ((CLLotteryBaseBetTerm *)(betTermInfo[0])).playMothedType;
        }
    }
}
#pragma mark - 获取投注项
- (NSArray *)getBetTerms{
    
    return self.ft_BetTermArray;
}
#pragma mark - 获取彩种的注数
- (NSInteger)getAllNote{
    
    NSInteger note = 0;
    for (CLLotteryBaseBetTerm * betInfo in self.ft_BetTermArray) {
        note += betInfo.betNote;
    }
    return note;
}
#pragma mark - 删除一条投注信息
- (void)deleteOneBetInfoWithIndex:(NSInteger)index{
    
    if (self.ft_BetTermArray.count > index) {
        [self.ft_BetTermArray removeObjectAtIndex:index];
    }
    if (self.ft_BetTermArray.count == 0) {
        self.period = 1;
        self.multiple = 1;
    }
}
#pragma mark - 删除所有投注信息
- (void)deleteAllBetInfo{
    
    [self.ft_BetTermArray removeAllObjects];
    self.period = 1;
    self.multiple = 1;
}
#pragma mark - 获取对应彩种的投注信息
- (id)getBetInfoWithIndex:(NSInteger)index{
    
    if (self.ft_BetTermArray.count > index) {
        return self.ft_BetTermArray[index];
    }else{
        return nil;
    }
}
#pragma mark - 获取投注信息的玩法
- (NSInteger)getPlayMothedTypeWithIndex:(NSInteger)index{
    
    if (self.ft_BetTermArray.count > index) {
        return ((CLLotteryBaseBetTerm *)self.ft_BetTermArray[index]).playMothedType;
    }else{
        NSAssert(NO, @"传入的index错误");
        return - 1;
    }
}
#pragma mark - 随机添加一注
- (void)randomAddOneBetInfo{
    
    switch (self.ft_PlayMothedType) {
        case CLFastThreePlayMothedTypeHeZhi:{
            [self randomHeZhiBetInfo];
        }
            break;
        case CLFastThreePlayMothedTypeThreeSame:{
            [self randomThreeSameBetInfo];
        }
            break;
        case CLFastThreePlayMothedTypeTwoSame:{
            [self randomTwoSameBetInfo];
        }
            break;
        case CLFastThreePlayMothedTypeThreeDifferent:{
            [self randomThreeDifferentBetInfo];
        }
            break;
        case CLFastThreePlayMothedTypeTwoDifferent:{
            [self randomTwoDifferentBetInfo];
        }
            break;
        case CLFastThreePlayMothedTypeDanTuoThreeDifferent:{
            [self randomThreeDifferentBetInfo];
        }
            break;
        case CLFastThreePlayMothedTypeDanTuoTwoDifferent:{
            [self randomTwoDifferentBetInfo];
        }
            break;
        default:
            
            break;
    }
    
}
#pragma mark ------------ private Mothed ------------
#pragma mark - 随机添加一注和值
- (void)randomHeZhiBetInfo{
    
    CLFTHeZhiBetInfo *betInfo = [[CLFTHeZhiBetInfo alloc] init];
    [betInfo addBetTerm:[NSString stringWithFormat:@"%zi", (arc4random() % 6 + 1) + (arc4random() % 6 + 1) + (arc4random() % 6 + 1)]];
    [self.ft_BetTermArray addObject:betInfo];
}
#pragma mark - 随机添加一注三同号
- (void)randomThreeSameBetInfo{
    
    NSInteger random = arc4random() % 6 + 1;
    CLFTThreeSameSingleBetInfo *betInfo = [[CLFTThreeSameSingleBetInfo alloc] init];
    [betInfo addBetTerm:[NSString stringWithFormat:@"%zi%zi%zi", random, random, random]];
    [self.ft_BetTermArray addObject:betInfo];
}
#pragma mark - 随机添加一注二同号
- (void)randomTwoSameBetInfo{
    
    NSInteger sameRandom = arc4random() % 6 + 1;
    NSInteger singleRandom = sameRandom + 1;
    for (NSInteger i = 0; i < 100; i++) {
        singleRandom = arc4random() % 6 + 1;
        if (singleRandom != sameRandom) {
            break;
        }
    }
    CLFTTwoSameSingleBetInfo *betInfo = [[CLFTTwoSameSingleBetInfo alloc] init];
    [betInfo addBetTerm:[NSString stringWithFormat:@"%zi%zi", sameRandom, sameRandom]];
    [betInfo addBetTerm:[NSString stringWithFormat:@"%zi", singleRandom]];
    [self.ft_BetTermArray addObject:betInfo];
}
#pragma mark - 随机添加一注三不同号
- (void)randomThreeDifferentBetInfo{
    
    NSInteger first = arc4random() % 6 + 1;
    NSInteger second = 1;
    NSInteger third = 1;
    for (NSInteger i = 0; i < 100; i++) {
        second = arc4random() % 6 + 1;
        if (first != second) {
            break;
        }
    }
    for (NSInteger i = 0; i < 100; i++) {
        third = arc4random() % 6 + 1;
        if ((first != third) && (third != second)) {
            break;
        }
    }
    CLFTThreeDifferentBetInfo *betInfo = [[CLFTThreeDifferentBetInfo alloc] init];
    [betInfo addBetTerm:[NSString stringWithFormat:@"%zi", first]];
    [betInfo addBetTerm:[NSString stringWithFormat:@"%zi", second]];
    [betInfo addBetTerm:[NSString stringWithFormat:@"%zi", third]];
    [self.ft_BetTermArray addObject:betInfo];
}
#pragma mark - 随机添加一注二不同号
- (void)randomTwoDifferentBetInfo{
    
    NSInteger first = arc4random() % 6 + 1;
    NSInteger second = 1;
    first = arc4random() % 6 + 1;
    for (NSInteger i = 0; i < 100; i++) {
        second = arc4random() % 6 + 1;
        if (first != second) {
            break;
        }
    }
    CLFTTwoDifferentBetInfo *betInfo = [[CLFTTwoDifferentBetInfo alloc] init];
    [betInfo addBetTerm:[NSString stringWithFormat:@"%zi", first]];
    [betInfo addBetTerm:[NSString stringWithFormat:@"%zi", second]];
    [self.ft_BetTermArray addObject:betInfo];
}
@end
