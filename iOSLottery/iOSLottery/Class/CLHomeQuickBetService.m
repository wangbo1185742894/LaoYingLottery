//
//  CLHomeQuickBetService.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/10.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLHomeQuickBetService.h"
#import "CLDEAnyBetTerm.h"
#import "CLFTHeZhiBetInfo.h"
#import "CLSSQNormalBetTerm.h"
#import "CLDLTNormalBetTerm.h"
#import "CLTools.h"
#import "CLLotteryCreateOrderRequset.h"
#import "CLHomeGamePeriodModel.h"
#import "CLLoadingAnimationView.h"
@interface CLHomeQuickBetService ()<CLRequestCallBackDelegate>

@property (nonatomic, strong) CLDEAnyBetTerm *de_betTerm;
@property (nonatomic, strong) CLFTHeZhiBetInfo *ft_betTerm;
@property (nonatomic, strong) CLSSQNormalBetTerm *ssq_betTerm;
@property (nonatomic, strong) CLDLTNormalBetTerm *dlt_betTerm;

@property (nonatomic, strong) CLLotteryCreateOrderRequset *createOrderRequest;//创建订单请求

@end
@implementation CLHomeQuickBetService

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.createOrderRequest = [[CLLotteryCreateOrderRequset alloc] init];
        self.createOrderRequest.delegate = self;
    }
    return self;
}
#pragma mark ------------ public Mothed ------------
- (void)createOrderNumberWithMultiple:(NSInteger)multiple periodModel:(CLHomeGamePeriodModel *)model{
    
    self.createOrderRequest.gameId = [NSString stringWithFormat:@"%zi", model.gameId];
    self.createOrderRequest.periodId = model.periodId;
    self.createOrderRequest.betTimes = [NSString stringWithFormat:@"%zi", multiple];
    if ([[model.gameEn lowercaseString] hasSuffix:@"d11"]) {
        
        self.createOrderRequest.lotteryNumber = self.de_betTerm.orderBetNumber;
        self.createOrderRequest.amount = [NSString stringWithFormat:@"%zi", self.de_betTerm.betNote * multiple * 2];
    } else if ([[model.gameEn lowercaseString] hasSuffix:@"kuai3"]) {
    
        self.createOrderRequest.lotteryNumber = self.ft_betTerm.orderBetNumber;
        self.createOrderRequest.amount = [NSString stringWithFormat:@"%zi", self.ft_betTerm.betNote * multiple * 2];
    } else if ([[model.gameEn lowercaseString] hasSuffix:@"ssq"]) {
        
        self.createOrderRequest.lotteryNumber = self.ssq_betTerm.orderBetNumber;
        self.createOrderRequest.amount = [NSString stringWithFormat:@"%zi", self.ssq_betTerm.betNote * multiple * 2];
    } else if ([[model.gameEn lowercaseString] hasSuffix:@"dlt"]) {
        
        self.createOrderRequest.lotteryNumber = self.dlt_betTerm.orderBetNumber;
        self.createOrderRequest.amount = [NSString stringWithFormat:@"%zi", self.dlt_betTerm.betNote * multiple * 2];
    }
    [[CLLoadingAnimationView shareLoadingAnimationView] showLoadingAnimationInCurrentViewControllerWithType:CLLoadingAnimationTypeNormal];
    [self.createOrderRequest start];
}
- (void)requestFinished:(CLBaseRequest *)request{
    
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
    if (request.urlResponse.resp && request.urlResponse.success) {
        
        if ([self.delegate respondsToSelector:@selector(requestFinishBet:)]) {
            [self.delegate requestFinishBet:request.urlResponse.resp];
        }
    }else{
        
        if ([self.delegate respondsToSelector:@selector(requestFailBet:)]) {
            [self.delegate requestFailBet:request.urlResponse.errorMessage];
        }
    }
}
- (void)requestFailed:(CLBaseRequest *)request{
    
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
    if ([self.delegate respondsToSelector:@selector(requestFailBet:)]) {
        [self.delegate requestFailBet:request.urlResponse.errorMessage];
    }
}
#pragma mark - 返回随机数组
- (NSArray <NSString *>*)getRandomBetTermWithType:(NSString *)lotteryGameEn{
    
    if ([[lotteryGameEn lowercaseString] hasSuffix:@"d11"]) {

        return [self getAnyTwoRandomBetTerm];
    } else if ([[lotteryGameEn lowercaseString] hasSuffix:@"kuai3"]) {

        return [self getHeZhiRandomBetTerm];
    } else if ([[lotteryGameEn lowercaseString] hasSuffix:@"ssq"]) {
        
        return [self getSSQRandomBetTerm];
    } else if ([[lotteryGameEn lowercaseString] hasSuffix:@"dlt"]) {
        
        return [self getDLTRandomBetTerm];
    }
    return nil;
}
#pragma mark - 和值的随机数组
- (NSArray <NSString *>*)getHeZhiRandomBetTerm{
    
    NSMutableArray *randomArray = [NSMutableArray arrayWithCapacity:0];
    NSInteger sum = 0;
    for (NSInteger i = 0; i < 3; i++) {
        
        NSInteger randomNum = arc4random() % 6 + 1;
        [randomArray addObject:[NSString stringWithFormat:@"%zi", randomNum]];
        sum += randomNum;
    }
    self.ft_betTerm = [[CLFTHeZhiBetInfo alloc] init];
    [self.ft_betTerm addBetTerm:[NSString stringWithFormat:@"%zi", sum]];
    return randomArray;
}
#pragma mark - D11的任选二的随机数组
- (NSArray <NSString *>*)getAnyTwoRandomBetTerm{
    
    NSArray *randomArray = [CLTools randomArrayWithCount:2 maxNumber:11];
    self.de_betTerm = [[CLDEAnyBetTerm alloc] init];
    [self.de_betTerm.betTermArray addObjectsFromArray:randomArray];
    randomArray = [randomArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 integerValue] > [obj2 integerValue];
    }];
    
    return randomArray;
}
#pragma mark - ssq随机数组
- (NSArray <NSString *>*)getSSQRandomBetTerm{
    
    NSArray *redRandomArray = [CLTools randomArrayWithCount:6 maxNumber:33];
    NSArray *blueRandomArray = [CLTools randomArrayWithCount:1 maxNumber:16];
    self.ssq_betTerm = [[CLSSQNormalBetTerm alloc] init];
    [self.ssq_betTerm.redArray addObjectsFromArray:redRandomArray];
    [self.ssq_betTerm.blueArray addObjectsFromArray:blueRandomArray];
    NSMutableArray *mArr = [[NSMutableArray alloc] initWithArray:redRandomArray];
    [mArr addObjectsFromArray:blueRandomArray];
    return mArr;
}
#pragma mark - dlt随机数组
- (NSArray <NSString *>*)getDLTRandomBetTerm{
    
    NSArray *redRandomArray = [CLTools randomArrayWithCount:5 maxNumber:35];
    NSArray *blueRandomArray = [CLTools randomArrayWithCount:2 maxNumber:12];
    self.dlt_betTerm = [[CLDLTNormalBetTerm alloc] init];
    [self.dlt_betTerm.redArray addObjectsFromArray:redRandomArray];
    [self.dlt_betTerm.blueArray addObjectsFromArray:blueRandomArray];
    NSMutableArray *mArr = [[NSMutableArray alloc] initWithArray:redRandomArray];
    [mArr addObjectsFromArray:blueRandomArray];
    return mArr;
}
@end
