//
//  CLLotteryAllInfo.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLotteryAllInfo.h"
#import "CLConfigMessage.h"
#import "CLBaseMainBetAllInfo.h"
#import "CLLotteryPeriodModel.h"
#import "CLLotteryMainBetModel.h"

@interface CLLotteryAllInfo ()

@property (nonatomic, strong) NSMutableDictionary *allLotteryAllInfoDic;

@end
@implementation CLLotteryAllInfo

+ (CLLotteryAllInfo *)shareLotteryAllInfo{
    static CLLotteryAllInfo *lotteryAllInfo = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        lotteryAllInfo = [[self alloc] init];
    });
    return lotteryAllInfo;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.allLotteryAllInfoDic = [NSMutableDictionary dictionaryWithCapacity:0];
        self.ft_animationPeriodDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(globalTimerRun) name:GlobalTimerRuning object:nil];
    }
    return self;
}

- (CLBaseMainBetAllInfo *)getLotteryAllInfo:(NSString *)lotteryGameEn{
    
    if (!(lotteryGameEn && lotteryGameEn.length > 0)) {
        return nil;
    }
    if (![[self.allLotteryAllInfoDic allKeys] containsObject:lotteryGameEn]) {
        
        CLBaseMainBetAllInfo *lotteryBetInfo = [[CLBaseMainBetAllInfo alloc] init];
        [self.allLotteryAllInfoDic setValue:lotteryBetInfo forKey:lotteryGameEn];
        return lotteryBetInfo;
    }else{
        return self.allLotteryAllInfoDic[lotteryGameEn];
    }
}

- (void)setMainRequestData:(CLLotteryMainBetModel *)requestData gameEn:(NSString *)lotteryGameEn{
    
    [self getLotteryAllInfo:lotteryGameEn].mainResquestData = requestData;
}
- (void)setPlayMothed:(NSInteger)playMothed gameEn:(NSString *)lotteryGameEn{

    [self getLotteryAllInfo:lotteryGameEn].lastRecordPlayMothed = playMothed;
}

- (CLLotteryMainBetModel *)getMainRequestDataWithGameEn:(NSString *)lotteryGameEn{
    
    return [self getLotteryAllInfo:lotteryGameEn].mainResquestData;
}
- (NSInteger)getPlayMothedWithGameEn:(NSString *)lotteryGameEn{
    
    return [self getLotteryAllInfo:lotteryGameEn].lastRecordPlayMothed;
}

- (void)setShowOmission:(BOOL)omission gameEn:(NSString *)gameEn
{
    [[self getLotteryAllInfo:gameEn] setOmission:omission];
    
}

- (BOOL)getShowOmissionWithGameEn:(NSString *)gameEn{
    
    return [self getLotteryAllInfo:gameEn].isOmission;
}


#pragma mark - 倒计时进行中
- (void)globalTimerRun
{
    for (NSString *key in [self.allLotteryAllInfoDic allKeys]) {
        
        CLBaseMainBetAllInfo *model = self.allLotteryAllInfoDic[key];
        CLLotteryMainBetModel *lotteryModel = model.mainResquestData;
        CLLotteryPeriodModel *periodModel = lotteryModel.currentPeriod;
        if (periodModel.saleEndTime == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:periodModel.gameEn object:nil
             ];
        }else{
            periodModel.saleEndTime--;
        }
    }
}
@end




