//
//  SLBetSelectInfo.m
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/16.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBetSelectInfo.h"
#import "SLBetInfoCache.h"

@interface SLBetSelectInfo ()

/**
 记录服务器最近一次默认推荐倍数
 */
@property (nonatomic, assign) NSInteger defaultBetMultiple;

@end

@implementation SLBetSelectInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.betMultiple = 1;
    }
    return self;
}

- (void)saveSelectBetInfoWithMatchIssue:(NSString *)matchIssue
                             palyMothed:(NSString *)playMothed
                             selectItem:(NSArray *)selectArray
                              isDanGuan:(BOOL)isDanGuan
                           rangQiuCount:(NSString *)rangQiuCount{
    
    BOOL isExistSingleMatch = NO;
    for (SLBetSelectSingleGameInfo *existSingleInfo in self.betSelectInfo) {
        
        if ([existSingleInfo.matchIssue isEqualToString:matchIssue]) {
            //如果已存储这场比赛
            BOOL isExistPlayMothed = NO;
            for (SLBetSelectPlayMothedInfo *existPlayMothed in existSingleInfo.singleBetSelectArray) {
                if ([existPlayMothed.playMothed isEqualToString:playMothed]) {
                    //已存储这种玩法
                    existPlayMothed.isDanGuan = isDanGuan;
                    existPlayMothed.rangQiuCount = rangQiuCount;
                    for (NSString *selectItem in selectArray) {
                        if (![existPlayMothed.selectPlayMothedArray containsObject:selectItem]) {
                            [existPlayMothed.selectPlayMothedArray addObject:selectItem];
                        }
                    }
                    isExistPlayMothed = YES;
                    break;
                }
            }
            if (!isExistPlayMothed) {
                //如果不存在这种玩法 则创建 并保存
                SLBetSelectPlayMothedInfo *selectPlayMothed = [[SLBetSelectPlayMothedInfo alloc] init];
                selectPlayMothed.playMothed = playMothed;
                selectPlayMothed.isDanGuan = isDanGuan;
                selectPlayMothed.rangQiuCount = rangQiuCount;
                [selectPlayMothed.selectPlayMothedArray addObjectsFromArray:selectArray];
                [existSingleInfo.singleBetSelectArray addObject:selectPlayMothed];
            }
            isExistSingleMatch = YES;
            break;
        }
    }
    if (!isExistSingleMatch) {
        //不存在这场比赛 创建并保存
        SLBetSelectSingleGameInfo *singleGame = [[SLBetSelectSingleGameInfo alloc] init];
        singleGame.matchIssue = matchIssue;
        
        SLBetSelectPlayMothedInfo *selectPlayMothed = [[SLBetSelectPlayMothedInfo alloc] init];
        selectPlayMothed.playMothed = playMothed;
        selectPlayMothed.isDanGuan = isDanGuan;
        selectPlayMothed.rangQiuCount = rangQiuCount;
        [selectPlayMothed.selectPlayMothedArray addObjectsFromArray:selectArray];
        [singleGame.singleBetSelectArray addObject:selectPlayMothed];
        [self.betSelectInfo addObject:singleGame];
    }
}

- (void)saveSelectBetInfoWithMatchIssue:(NSString *)matchIssue
                             palyMothed:(NSString *)playMothed
                             selectItem:(NSArray *)selectArray
                              isDanGuan:(BOOL)isDanGuan{
    
    [self saveSelectBetInfoWithMatchIssue:matchIssue palyMothed:playMothed selectItem:selectArray isDanGuan:isDanGuan rangQiuCount:@""];
}

- (void)removeSelectBetInfoWithMatchIssue:(NSString *)matchIssue
                               palyMothed:(NSString *)playMothed
                               selectItem:(NSArray *)selectArray{
    
    for (SLBetSelectSingleGameInfo *existSingleInfo in self.betSelectInfo) {
        
        if ([existSingleInfo.matchIssue isEqualToString:matchIssue]) {
            //如果已存储这场比赛
            for (SLBetSelectPlayMothedInfo *existPlayMothed in existSingleInfo.singleBetSelectArray) {
                if ([existPlayMothed.playMothed isEqualToString:playMothed]) {
                    //已存储这种玩法
                    for (NSString *selectItem in selectArray) {
                        if ([existPlayMothed.selectPlayMothedArray containsObject:selectItem]) {
                            [existPlayMothed.selectPlayMothedArray removeObject:selectItem];
                        }
                    }
                    return;
                }
            }
        }
    }

    
}


- (NSMutableArray<SLBetSelectSingleGameInfo *> *)betSelectInfo{
    
    if (!_betSelectInfo) {
        _betSelectInfo = [NSMutableArray arrayWithCapacity:0];
    }
    return _betSelectInfo;
}

- (NSMutableArray *)chuanGuanArray{
    
    if (!_chuanGuanArray) {
        _chuanGuanArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _chuanGuanArray;
}

@end

@implementation SLBetSelectSingleGameInfo

- (id)copyWithZone:(NSZone *)zone{
    
    SLBetSelectSingleGameInfo * gameInfo = [[SLBetSelectSingleGameInfo allocWithZone:zone] init];
    
    gameInfo.matchIssue = self.matchIssue;
    gameInfo.singleBetSelectArray = [self.singleBetSelectArray mutableCopy];
    
    return gameInfo;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    SLBetSelectSingleGameInfo * gameInfo = [[SLBetSelectSingleGameInfo allocWithZone:zone] init];
    
    gameInfo.matchIssue = self.matchIssue;
    gameInfo.singleBetSelectArray = self.singleBetSelectArray;
    
    return gameInfo;
}
- (NSMutableArray<SLBetSelectPlayMothedInfo *> *)singleBetSelectArray{
    
    if (!_singleBetSelectArray) {
        _singleBetSelectArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _singleBetSelectArray;
}

@end


@implementation SLBetSelectPlayMothedInfo

- (id)copyWithZone:(NSZone *)zone{
    
    SLBetSelectPlayMothedInfo *playMothedInfo = [[SLBetSelectPlayMothedInfo allocWithZone:zone] init];
    
    playMothedInfo.playMothed = self.playMothed;
    
    playMothedInfo.isDanGuan = self.isDanGuan;
    
    playMothedInfo.rangQiuCount = self.rangQiuCount;
    
    playMothedInfo.selectPlayMothedArray = self.selectPlayMothedArray;
    
    return playMothedInfo;
    
}
- (id)mutableCopyWithZone:(nullable NSZone *)zone{
    
    SLBetSelectPlayMothedInfo *playMothedInfo = [[SLBetSelectPlayMothedInfo allocWithZone:zone] init];
    
    playMothedInfo.playMothed = self.playMothed;
    
    playMothedInfo.isDanGuan = self.isDanGuan;
    
    playMothedInfo.rangQiuCount = self.rangQiuCount;
    
    playMothedInfo.selectPlayMothedArray = self.selectPlayMothedArray;
    
    return playMothedInfo;
    
}

- (NSMutableArray *)selectPlayMothedArray{
    
    if (!_selectPlayMothedArray) {
        _selectPlayMothedArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectPlayMothedArray;
}

@end
