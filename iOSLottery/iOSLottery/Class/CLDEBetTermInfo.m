//
//  CLDEBetTermInfo.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/5.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLDEBetTermInfo.h"
#import "CLDElevenConfigMessage.h"
#import "CLLotteryBaseBetTerm.h"
#import "CLDEAnyBetTerm.h"
#import "CLDETwoGroupBetTerm.h"
#import "CLDEPreThreeDirectBetTerm.h"
@interface CLDEBetTermInfo ()

@property (nonatomic, strong) NSMutableArray *dElevenBetTermArray;
@property (nonatomic, assign) CLDElevenPlayMothedType dePlayMothedType;//记录玩法

@end
@implementation CLDEBetTermInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.period = 1;
        self.multiple = 1;
        self.dePlayMothedType = CLDElevenPlayMothedTypeTwo;
        self.dElevenBetTermArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}
#pragma mark ------------ public Mothed ------------
#pragma mark - 获取创建订单的投注字符串
- (NSString *)getOrderBetNumber{
    
    NSMutableArray *orderNumberArray = [NSMutableArray arrayWithCapacity:0];
    for (CLLotteryBaseBetTerm *betTerm in self.dElevenBetTermArray) {
        [orderNumberArray addObject:betTerm.orderBetNumber];
    }
    return [orderNumberArray componentsJoinedByString:@","];
}
#pragma mark - 添加投注项
- (void)addLotteryBetTerm:(NSArray *)betTermInfo{
    
    [self.dElevenBetTermArray addObjectsFromArray:betTermInfo]; 
    if (self.dElevenBetTermArray.count > 0) {
        self.dePlayMothedType = ((CLLotteryBaseBetTerm *)[self.dElevenBetTermArray lastObject]).playMothedType;
    }
}
#pragma mark - 替换投注项
- (void)replaceLotteryBetTerm:(NSArray *)betTermInfo index:(NSInteger)index{
    
    if (self.dElevenBetTermArray.count > index) {
        [self.dElevenBetTermArray replaceObjectsInRange:NSMakeRange(index, 1) withObjectsFromArray:betTermInfo];
        if (((NSArray *)betTermInfo).count > 0) {
            self.dePlayMothedType = ((CLLotteryBaseBetTerm *)(betTermInfo[0])).playMothedType;
        }
    }
}
#pragma mark - 获取投注项的数组（用于投注详情UI展示）
- (NSArray *)getBetTerms{
    
    return self.dElevenBetTermArray;
}
#pragma mark - 获取所有投注项的投注注数
- (NSInteger)getAllNote{
    
    NSInteger note = 0;
    for (CLLotteryBaseBetTerm *betTerm in self.dElevenBetTermArray) {
        note += betTerm.betNote;
    }
    return note;
}
#pragma mark - 机选一注
- (void)randomAddOneBetInfo{
    
    switch (self.dePlayMothedType) {
        case CLDElevenPlayMothedTypeTwo:{
            [self randomAnyBetWithCount:2 playMothed:CLDElevenPlayMothedTypeTwo];
        }
            break;
        case CLDElevenPlayMothedTypeThree:{
            [self randomAnyBetWithCount:3 playMothed:CLDElevenPlayMothedTypeThree];
        }
            break;
        case CLDElevenPlayMothedTypeFour:{
            [self randomAnyBetWithCount:4 playMothed:CLDElevenPlayMothedTypeFour];
        }
            break;
        case CLDElevenPlayMothedTypeFive:{
            [self randomAnyBetWithCount:5 playMothed:CLDElevenPlayMothedTypeFive];
        }
            break;
        case CLDElevenPlayMothedTypeSix:{
            [self randomAnyBetWithCount:6 playMothed:CLDElevenPlayMothedTypeSix];
        }
            break;
        case CLDElevenPlayMothedTypeSeven:{
            [self randomAnyBetWithCount:7 playMothed:CLDElevenPlayMothedTypeSeven];
        }
            break;
        case CLDElevenPlayMothedTypeEight:{
            [self randomAnyBetWithCount:8 playMothed:CLDElevenPlayMothedTypeEight];
        }
            break;
        case CLDElevenPlayMothedTypePreOne:{
            [self randomAnyBetWithCount:1 playMothed:CLDElevenPlayMothedTypePreOne];
        }
            break;
        case CLDElevenPlayMothedTypePreTwoDirect:{
            [self randomPreTwoDirect];
        }
            break;
        case CLDElevenPlayMothedTypePreTwoGroup:{
            [self randomAnyBetWithCount:2 playMothed:CLDElevenPlayMothedTypePreTwoGroup];
        }
            break;
        case CLDElevenPlayMothedTypePreThreeDirect:{
            [self randomPreThreeDirect];
        }
            break;
        case CLDElevenPlayMothedTypePreThreeGroup:{
            [self randomAnyBetWithCount:3 playMothed:CLDElevenPlayMothedTypePreThreeGroup];
        }
            break;
        case CLDElevenPlayMothedTypeDTTwo:{
            [self randomAnyBetWithCount:2 playMothed:CLDElevenPlayMothedTypeTwo];
        }
            break;
        case CLDElevenPlayMothedTypeDTThree:{
            [self randomAnyBetWithCount:3 playMothed:CLDElevenPlayMothedTypeThree];
        }
            break;
        case CLDElevenPlayMothedTypeDTFour:{
            [self randomAnyBetWithCount:4 playMothed:CLDElevenPlayMothedTypeFour];
        }
            break;
        case CLDElevenPlayMothedTypeDTFive:{
            [self randomAnyBetWithCount:5 playMothed:CLDElevenPlayMothedTypeFive];
        }
            break;
        case CLDElevenPlayMothedTypeDTSix:{
            [self randomAnyBetWithCount:6 playMothed:CLDElevenPlayMothedTypeSix];
        }
            break;
        case CLDElevenPlayMothedTypeDTSeven:{
            [self randomAnyBetWithCount:7 playMothed:CLDElevenPlayMothedTypeSeven];
        }
            break;
        case CLDElevenPlayMothedTypeDTEight:{
            [self randomAnyBetWithCount:8 playMothed:CLDElevenPlayMothedTypeEight];
        }
            break;
        case CLDElevenPlayMothedTypeDTPreTwoGroup:{
            [self randomAnyBetWithCount:2 playMothed:CLDElevenPlayMothedTypePreTwoGroup];
        }
            break;
        case CLDElevenPlayMothedTypeDTPreThreeGroup:{
            [self randomAnyBetWithCount:3 playMothed:CLDElevenPlayMothedTypePreThreeGroup];
        }
            break;
        default:
            break;
    }
    
}
#pragma mark - 清空列表
- (void)deleteAllBetInfo{
    
    [self.dElevenBetTermArray removeAllObjects];
    self.multiple = 1;
    self.period = 1;
}
#pragma mark - 删除一行
- (void)deleteOneBetInfoWithIndex:(NSInteger)index{
    
    if (self.dElevenBetTermArray.count > index) {
        [self.dElevenBetTermArray removeObjectAtIndex:index];
    }
    if (self.dElevenBetTermArray.count == 0) {
        self.period = 1;
        self.multiple = 1;
    }
}
#pragma mark - 获取对应的玩法
- (NSInteger)getPlayMothedTypeWithIndex:(NSInteger)index{
    
    if (self.dElevenBetTermArray.count > index) {
        return ((CLLotteryBaseBetTerm *)self.dElevenBetTermArray[index]).playMothedType;
    }
    return - 1;
}
#pragma mark - 获取对应的投注信息
- (id)getBetInfoWithIndex:(NSInteger)index{
    
    if (self.dElevenBetTermArray.count > index) {
        return self.dElevenBetTermArray[index];
    }
    return nil;
}
#pragma mark ------------ private Mothed ------------
#pragma mark - 任选 机选
- (void)randomAnyBetWithCount:(NSInteger)count playMothed:(CLDElevenPlayMothedType)playMothedType{
    CLDEAnyBetTerm *betTerm = [[CLDEAnyBetTerm alloc] init];
    betTerm.playMothedType = playMothedType;
    [betTerm.betTermArray addObjectsFromArray:[self randomArrayWithCount:count]];
    [self.dElevenBetTermArray addObject:betTerm];
}
#pragma mark - 前二 直选
- (void)randomPreTwoDirect{
    
    CLDETwoGroupBetTerm *twoBetTerm = [[CLDETwoGroupBetTerm alloc] init];
    NSArray *randomNumberArray = [self randomArrayWithCount:2];
    [twoBetTerm.firstBetTermArray addObject:randomNumberArray[0]];
    [twoBetTerm.secondBetTermArray addObject:randomNumberArray[1]];
    twoBetTerm.playMothedType = CLDElevenPlayMothedTypePreTwoDirect;
    [self.dElevenBetTermArray addObject:twoBetTerm];
}
#pragma mark - 前三 直选
- (void)randomPreThreeDirect{
    
    CLDEPreThreeDirectBetTerm *threeBetTerm = [[CLDEPreThreeDirectBetTerm alloc] init];
    NSArray *randomNumberArray = [self randomArrayWithCount:3];
    [threeBetTerm.firstBetTermArray addObject:randomNumberArray[0]];
    [threeBetTerm.secondBetTermArray addObject:randomNumberArray[1]];
    [threeBetTerm.thirdBetTermArray addObject:randomNumberArray[2]];
    threeBetTerm.playMothedType = CLDElevenPlayMothedTypePreThreeDirect;
    [self.dElevenBetTermArray addObject:threeBetTerm];
}
#pragma mark - 生成不重复的随机数
-(NSArray *)randomArrayWithCount:(NSInteger)count
{
    //随机数产生结果
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    
    for (NSInteger i = 0; i < MAXFLOAT; i++) {
        NSInteger randomNumber = arc4random() % 11 + 1;
        BOOL isStore = YES;
        for (NSNumber *number in resultArray) {
            if ([number integerValue] == randomNumber) {
                isStore = NO;
            }
        }
        if (isStore) {
            [resultArray addObject:[NSString stringWithFormat:@"%02zi", randomNumber]];
        }
        if (resultArray.count == count) {
            break;
        }
    }
    return resultArray;
}

@end
