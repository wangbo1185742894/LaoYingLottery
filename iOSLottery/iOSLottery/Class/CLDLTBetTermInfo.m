//
//  CLDLTBetTermInfo.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLDLTBetTermInfo.h"
#import "CLDLTNormalBetTerm.h"
#import "CLTools.h"
@interface CLDLTBetTermInfo ()

@property (nonatomic, strong) NSMutableArray *dlt_betTermArray;


@end

@implementation CLDLTBetTermInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.period = 1;
        self.multiple = 1;
        self.dlt_betTermArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}
#pragma mark ------ public Mothed ------
#pragma mark - 返回投注订单串
- (NSString *)getOrderBetNumber{
    
    NSMutableArray *orderNumberArray = [NSMutableArray arrayWithCapacity:0];
    for (CLLotteryBaseBetTerm * betInfo in self.dlt_betTermArray) {
        [orderNumberArray addObject:betInfo.orderBetNumber];
    }
    return [orderNumberArray componentsJoinedByString:@","];
}
#pragma mark - 添加一个投注项
- (void)addLotteryBetTerm:(NSArray *)betTermInfo{
    
    [self.dlt_betTermArray addObjectsFromArray:betTermInfo];
}
#pragma mark - 替换一个投注项
- (void)replaceLotteryBetTerm:(NSArray *)betTermInfo index:(NSInteger)index{
    
    if (self.dlt_betTermArray.count > index) {
        [self.dlt_betTermArray replaceObjectsInRange:NSMakeRange(index, 1) withObjectsFromArray:betTermInfo];
    }
}
#pragma mark - 获取投注项
- (NSArray *)getBetTerms{
    
    return self.dlt_betTermArray;
}
#pragma mark - 获取彩种的注数
- (NSInteger)getAllNote{
    
    NSInteger note = 0;
    for (CLLotteryBaseBetTerm * betInfo in self.dlt_betTermArray) {
        note += betInfo.betNote;
    }
    return note;
}
#pragma mark - 删除一条投注信息
- (void)deleteOneBetInfoWithIndex:(NSInteger)index{
    
    if (self.dlt_betTermArray.count > index) {
        [self.dlt_betTermArray removeObjectAtIndex:index];
    }
    if (self.dlt_betTermArray.count == 0) {
        self.period = 1;
        self.multiple = 1;
    }
}
#pragma mark - 删除所有投注信息
- (void)deleteAllBetInfo{
    
    [self.dlt_betTermArray removeAllObjects];
    self.period = 1;
    self.multiple = 1;
}
#pragma mark - 获取对应彩种的投注信息
- (id)getBetInfoWithIndex:(NSInteger)index{
    
    if (self.dlt_betTermArray.count > index) {
        return self.dlt_betTermArray[index];
    }else{
        return nil;
    }
}
#pragma mark - 获取投注信息的玩法
- (NSInteger)getPlayMothedTypeWithIndex:(NSInteger)index{
    
    if (self.dlt_betTermArray.count > index) {
        return ((CLLotteryBaseBetTerm *)self.dlt_betTermArray[index]).playMothedType;
    }else{
        NSAssert(NO, @"传入的index错误");
        return - 1;
    }
}
#pragma mark - 随机添加一注
- (void)randomAddOneBetInfo{
    
    CLDLTNormalBetTerm *normalBetTerm = [[CLDLTNormalBetTerm alloc] init];
    [normalBetTerm.redArray addObjectsFromArray:[CLTools randomArrayWithCount:5 maxNumber:35]];
    [normalBetTerm.blueArray addObjectsFromArray:[CLTools randomArrayWithCount:2 maxNumber:12]];
    [self.dlt_betTermArray addObject:normalBetTerm];
}

@end
