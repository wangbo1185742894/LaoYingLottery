//
//  CLNewLotteryBetInfo.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLNewLotteryBetInfo.h"
#import "CLLotteryBaseBetTermInfo.h"
#import "CLFTBetTermInfo.h"
#import "CLDEBetTermInfo.h"
#import "CLSSQBetTermInfo.h"
#import "CLDLTBetTermInfo.h"
@interface CLNewLotteryBetInfo ()

@property (nonatomic, strong) NSMutableDictionary *allLotteryBetInfoDic;//所有彩种 投注项存储

@end
@implementation CLNewLotteryBetInfo

+ (CLNewLotteryBetInfo *)shareLotteryBetInfo{
    
    static CLNewLotteryBetInfo *betInfo = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        betInfo = [[CLNewLotteryBetInfo alloc] init];
    });
    return betInfo;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.allLotteryBetInfoDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}
#pragma mark ------------ 获取对应 gameEn 的 投注项 ------------
- (CLLotteryBaseBetTermInfo *)getLotteryBetInfoWithGameEn:(NSString *)lotteryGameEn{
    
    if (!(lotteryGameEn && lotteryGameEn.length > 0)) {
        return nil;
    }
    if (![[self.allLotteryBetInfoDic allKeys] containsObject:lotteryGameEn]) {
        
        CLLotteryBaseBetTermInfo *lotteryBetInfo = nil;
        if ([[lotteryGameEn lowercaseString] hasSuffix:@"kuai3"]) {
            
            lotteryBetInfo = [[CLFTBetTermInfo alloc] init];
        }else if ([[lotteryGameEn lowercaseString] hasSuffix:@"d11"]){
            
            lotteryBetInfo = [[CLDEBetTermInfo alloc] init];
        }else if ([[lotteryGameEn lowercaseString] hasSuffix:@"ssq"]){
            
            lotteryBetInfo = [[CLSSQBetTermInfo alloc] init];
        }else if ([[lotteryGameEn lowercaseString] hasSuffix:@"dlt"]){
            
            lotteryBetInfo = [[CLDLTBetTermInfo alloc] init];
        }
        [self.allLotteryBetInfoDic setValue:lotteryBetInfo forKey:lotteryGameEn];
        return lotteryBetInfo;
    }else{
        return self.allLotteryBetInfoDic[lotteryGameEn];
    }
}


#pragma mark ------ public Mothed ------
#pragma mark - 返回投注订单串
- (NSString *)getOrderBetNumberWithLottery:(NSString *)lotteryGameEn{
    
    return [[self getLotteryBetInfoWithGameEn:lotteryGameEn] getOrderBetNumber];
}
#pragma mark - 添加一个投注项
- (void)addLotteryBetTerm:(NSArray *)betTermInfo lotteryType:(NSString *)lotteryGameEn{
    
    [[self getLotteryBetInfoWithGameEn:lotteryGameEn] addLotteryBetTerm:betTermInfo];
}
#pragma mark - 替换一个投注项
- (void)replaceLotteryBetTerm:(NSArray *)betTermInfo lotteryType:(NSString *)lotteryGameEn index:(NSInteger)index{
    
    [[self getLotteryBetInfoWithGameEn:lotteryGameEn] replaceLotteryBetTerm:betTermInfo index:index];
}
#pragma mark - 获取投注项
- (NSArray *)getBetTermsWithLotteryType:(NSString *)lotteryGameEn{
    
    return [[self getLotteryBetInfoWithGameEn:lotteryGameEn] getBetTerms];
}
#pragma mark - 获取彩种的注数
- (NSInteger)getAllNoteWithLottery:(NSString *)lotteryGameEn{
    
    return [[self getLotteryBetInfoWithGameEn:lotteryGameEn] getAllNote];
}
#pragma mark - 设置彩种的追期期数
- (void)setPeriod:(NSInteger)period lottery:(NSString *)lotteryGameEn{
    
    [self getLotteryBetInfoWithGameEn:lotteryGameEn].period = period;
}
#pragma mark - 设置彩种的倍数
- (void)setMultiple:(NSInteger)multiple lottery:(NSString *)lotteryGameEn{
    
    [self getLotteryBetInfoWithGameEn:lotteryGameEn].multiple = multiple;
}
#pragma mark - 设置彩种gameEn
- (void)setGameEn:(NSString *)gameEn lottery:(NSString *)lotteryGameEn{
    
    [self getLotteryBetInfoWithGameEn:lotteryGameEn].gameEn = gameEn;
}
#pragma mark - 设置彩种gameId
- (void)setGameId:(NSString *)gameId lottery:(NSString *)lotteryGameEn{
    
    [self getLotteryBetInfoWithGameEn:lotteryGameEn].gameId = gameId;
}
#pragma mark - 设置彩种periodId
- (void)setPeriodId:(NSString *)periodId lottery:(NSString *)lotteryGameEn{
    
    [self getLotteryBetInfoWithGameEn:lotteryGameEn].periodId = periodId;
}
#pragma mark - 设置彩种followMode
- (void)setFollowMode:(NSString *)followMode lottery:(NSString *)lotteryGameEn{
    
    [self getLotteryBetInfoWithGameEn:lotteryGameEn].followMode = followMode;
}
#pragma mark - 设置彩种followType
- (void)setFollowType:(NSString *)followType lottery:(NSString *)lotteryGameEn{
    
    [self getLotteryBetInfoWithGameEn:lotteryGameEn].followType = followType;
}
#pragma mark - 获取彩种followMode
- (NSString *)getFollowModeWithLottery:(NSString *)lotteryGameEn{
    
    return [self getLotteryBetInfoWithGameEn:lotteryGameEn].followMode;
}
#pragma mark - 获取彩种followType
- (NSString *)getFollowTypeWithLottery:(NSString *)lotteryGameEn{
    
    return [self getLotteryBetInfoWithGameEn:lotteryGameEn].followType;
}
#pragma mark - 获取彩种追期
- (NSInteger)getPeriodWithLottery:(NSString *)lotteryGameEn{
    
    return [self getLotteryBetInfoWithGameEn:lotteryGameEn].period;
}
#pragma mark - 获取彩种倍数
- (NSInteger)getMultipleWithLottery:(NSString *)lotteryGameEn{
    
    return [self getLotteryBetInfoWithGameEn:lotteryGameEn].multiple;
}
#pragma mark - 获取彩种gameEn
- (NSString *)getGameEnWithLottery:(NSString *)lotteryGameEn{
    
    return [self getLotteryBetInfoWithGameEn:lotteryGameEn].gameEn;
}
#pragma mark - 获取彩种gameId
- (NSString *)getGameIdWithLottery:(NSString *)lotteryGameEn{
    
    return [self getLotteryBetInfoWithGameEn:lotteryGameEn].gameId;
}
#pragma mark - 获取彩种periodId
- (NSString *)getPeriodIdWithLottery:(NSString *)lotteryGameEn{
    
    return [self getLotteryBetInfoWithGameEn:lotteryGameEn].periodId;
}
#pragma mark - 删除一条投注信息
- (void)deleteOneBetInfoWithIndex:(NSInteger)index lottery:(NSString *)lotteryGameEn{
    
    [[self getLotteryBetInfoWithGameEn:lotteryGameEn] deleteOneBetInfoWithIndex:index];
}
#pragma mark - 删除所有投注信息
- (void)deleteAllBetInfoWithLottery:(NSString *)lotteryGameEn{
    
    [[self getLotteryBetInfoWithGameEn:lotteryGameEn] deleteAllBetInfo];
}
#pragma mark - 获取对应彩种的投注信息
- (id)getBetInfoWithIndex:(NSInteger)index lottery:(NSString *)lotteryGameEn{
    
    return [[self getLotteryBetInfoWithGameEn:lotteryGameEn] getBetInfoWithIndex:index];
}
#pragma mark - 获取投注信息的玩法
- (NSInteger)getPlayMothedTypeWithIndex:(NSInteger)index lottery:(NSString *)lotteryGameEn{
    
    return [[self getLotteryBetInfoWithGameEn:lotteryGameEn] getPlayMothedTypeWithIndex:index];
}
#pragma mark - 随机添加一注
- (void)randomAddOneBetInfoWithLottery:(NSString *)lotteryGameEn{
    
    [[self getLotteryBetInfoWithGameEn:lotteryGameEn] randomAddOneBetInfo];
}

- (void) setIsAdditional:(BOOL)isAdd lottery:(NSString *)lotteryGameEn{
    
    [self getLotteryBetInfoWithGameEn:lotteryGameEn].isAdditional = isAdd;
}

- (BOOL)getIsAdditionalWithLottery:(NSString *)lotteryGameEn{
    
    return [self getLotteryBetInfoWithGameEn:lotteryGameEn].isAdditional;
}
@end
