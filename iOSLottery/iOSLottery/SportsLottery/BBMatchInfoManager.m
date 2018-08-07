//
//  BBMatchInfoManger.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBMatchInfoManager.h"

#import "BBMatchGroupModel.h"
#import "BBMatchModel.h"
#import "BBLeagueModel.h"
#import "BBSeletedGameModel.h"

#import "BBChuanGuanModel.h"

@interface BBMatchInfoManager ()

@property (nonatomic, strong) NSNumber *jclq_mix_p;

@property (nonatomic, assign) long long maxTimes;

@property (nonatomic, strong) NSNumber *defauleTimes;

@property (nonatomic, assign) NSInteger betMultiple;

@property (nonatomic, strong) NSMutableArray <BBMatchGroupModel *> *allMatchsArray;

@property (nonatomic, strong) NSMutableArray <BBLeagueModel *>*leagueMatchesArray;

@property (nonatomic, strong) NSMutableArray *allFilterMatchArray;

@property (nonatomic, strong) NSMutableDictionary *selectedDictionary;

@property (nonatomic, strong) NSMutableArray *chuanGuanArray;

@property (nonatomic, strong) NSDictionary *chuanGuanDic;

@end

@implementation BBMatchInfoManager

+ (instancetype)shareManager
{
    
    static dispatch_once_t once ;
    static BBMatchInfoManager *manager = nil;
    dispatch_once(&once, ^{
        
        manager = [[BBMatchInfoManager alloc] init];
        manager.maxTimes = 9999;
    });
    return manager;
}

/**
 记录最近一次服务器推荐倍数
 */
static NSInteger defaultBetMultiple;

- (NSMutableDictionary *)getSelectMatchInfo
{

    return self.selectedDictionary;
}

- (NSMutableArray *)getAllMatchArray
{

    return self.allMatchsArray;
}

- (void)saveAndclassifyAllMatchsInfo:(id)data{
    
    if ( data && [data isKindOfClass:[NSDictionary class]]) {
        
        //存储gameId
        NSNumber *jczq = data[@"jclq_mix_p"];
        NSNumber *maxTime = data[@"maxTimes"];
        
        self.maxTimes = [maxTime longLongValue];
        
        NSNumber *defaultTimes = data[@"defaultTimes"];
        
        defaultBetMultiple = [defaultTimes longLongValue];
        
        if ([jczq isKindOfClass:[NSNumber class]] && jczq) {
            
            self.jclq_mix_p = jczq;
        }
        if ([maxTime isKindOfClass:[NSNumber class]] && maxTime) {
            
            self.maxTimes = [maxTime longLongValue];
        }
        if ([defaultTimes isKindOfClass:[NSNumber class]] && defaultTimes) {
            
            self.betMultiple = [defaultTimes longLongValue];
        }
        //存储比赛 并将已选择的比赛中已过期的比赛清除掉
        NSArray *array = data[@"allMatches"];
        if ([array isKindOfClass:[NSArray class]] && array && array.count > 0) {
            
            [self.allMatchsArray removeAllObjects];
            [self.allMatchsArray addObjectsFromArray:[BBMatchGroupModel mj_objectArrayWithKeyValuesArray:array]];
            
            //归类所有联赛 并 筛出已过期但已选择的比赛
            [self classifyLeagueMatches];
        }
        
    }
}

//归类所有的联赛
- (void)classifyLeagueMatches
{
    
    NSArray *tempArray = [NSArray arrayWithArray:self.leagueMatchesArray];
    
    [self.leagueMatchesArray removeAllObjects];
    
    NSMutableArray *allMatchs = [NSMutableArray arrayWithCapacity:0];
    
    for (BBMatchGroupModel *groupModel in self.allMatchsArray) {
        
        for (BBMatchModel *model in groupModel.matches) {
            
            [allMatchs addObject:model.match_issue];
            
            
            BOOL isExist = NO;
            for (BBLeagueModel *existSeasionModel in self.leagueMatchesArray) {
                if (existSeasionModel.seasionId == model.season_id) {
                    
                    existSeasionModel.leagueTotal ++;
                    
                    isExist = YES;
                    
                    break;
                }
            }
            if (!isExist) {
                
                BBLeagueModel *leagueModel = [[BBLeagueModel alloc] init];
                leagueModel.seasionId = model.season_id;
                leagueModel.titile = model.season_pre;
                leagueModel.isSelect = YES;
                leagueModel.leagueTotal = 1;
                
                for (BBLeagueModel *tempModel in tempArray) {
                    
                    if (tempModel.seasionId == leagueModel.seasionId) {
                        
                        leagueModel.isSelect = tempModel.isSelect;
                    }
                }
                
                [self.leagueMatchesArray addObject:leagueModel];
            }
        }
        
    }
    [self deleteUnexistMatchWithAllMatch:allMatchs];
}


//将不存在的比赛 但之前已选择的比赛删除
- (void)deleteUnexistMatchWithAllMatch:(NSArray *)matchArrays
{
    
    [self.selectedDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, BBSeletedGameModel * obj, BOOL * _Nonnull stop) {
       
        if (![matchArrays containsObject:obj.matchIssue]) {
            
            [self.selectedDictionary removeObjectForKey:key];
        }
    }];
}

- (BBMatchModel *)getMatchInfoWithIssue:(NSString *)matchIssue{
    
    
    if (!(matchIssue != nil && matchIssue.length > 0)) return nil;
    
    for (BBMatchGroupModel *groupModel in self.allMatchsArray) {
        
        for (BBMatchModel *model in groupModel.matches) {
            if ([model.match_issue isEqualToString:matchIssue]) {
                return model;
            }
        }
    }
    return nil;
}



- (NSString *)getGameId{
    
    return [NSString stringWithFormat:@"%@",self.jclq_mix_p];
}


- (NSArray *)getNeedShowMatchs{
    
    NSMutableArray *needShowArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (BBMatchGroupModel *groupModel in self.allMatchsArray) {
        
        BBMatchGroupModel *showGroupModel = [[BBMatchGroupModel alloc] init];
        
        for (BBMatchModel *matchBetModel in groupModel.matches) {
            
            for (BBLeagueModel *leagueModel in self.leagueMatchesArray) {
                if (leagueModel.isSelect) {
                    if (matchBetModel.season_id == leagueModel.seasionId) {
                        [showGroupModel.matches addObject:matchBetModel];
                    }
                }
            }
        }
        if (showGroupModel.matches.count > 0) {
            showGroupModel.title = groupModel.title;
            showGroupModel.add_top = groupModel.add_top;
            [needShowArray addObject:showGroupModel];
        }
    }
    return needShowArray;
}


#pragma mark --- 保存一场比赛 ----
- (void)saveOneMatchSelectInfo:(BBSeletedGameModel *)oneGameInfo
{
    
    if (!(oneGameInfo.matchIssue != nil && oneGameInfo.matchIssue.length > 0)) return;
    
    BBSeletedGameModel *gameModel = [self.selectedDictionary objectForKey:oneGameInfo.matchIssue];
    
    if (gameModel == nil) {
    
          [self.selectedDictionary setObject:oneGameInfo forKey:oneGameInfo.matchIssue];;
        
    }else{
        
        [self.selectedDictionary setValue:oneGameInfo forKey:oneGameInfo.matchIssue];
    }
    
    [self deleteExistErrorChuanGuan];
}

- (BBSeletedGameModel *)getSingleMatchSelectInfoWithMatchIssue:(NSString *)matchIssue{
    
    if (matchIssue == nil || matchIssue.length == 0) return nil;
    
    BBSeletedGameModel *gameModel = self.selectedDictionary[matchIssue];
    
    return gameModel ? gameModel : nil;
    
}

- (NSInteger)getSingleMatchSelectPlayMothedNumberWithMatchIssue:(NSString *)matchIssue{
    
    BBSeletedGameModel *gameModel = [self getSingleMatchSelectInfoWithMatchIssue:matchIssue];
    NSInteger count = 0;
    
    count = gameModel.sfInfo.selectPlayMothedArray.count + gameModel.rfsfInfo.selectPlayMothedArray.count + gameModel.dxfInfo.selectPlayMothedArray.count + gameModel.sfcInfo.selectPlayMothedArray.count;
    
    return count;
}


- (void)removeOneMatchWithIssue:(NSString *)matchIssue{
    
    if (matchIssue == nil || matchIssue.length == 0) return;
    
    BBSeletedGameModel *gameModel = self.selectedDictionary[matchIssue];
    
    if (gameModel) {
        
        [self.selectedDictionary removeObjectForKey:matchIssue];
    }
    
    [self deleteExistErrorChuanGuan];
}
- (void)clearMatch{
    
    [self.selectedDictionary removeAllObjects];
    [self.chuanGuanArray removeAllObjects];
    self.betMultiple = defaultBetMultiple;
}


#pragma mark ---- 串关相关 ----

- (void)deleteExistErrorChuanGuan
{
    NSArray *chuanguanArr = self.getChuanGuanArray;
    NSMutableArray *cgStringArr = [NSMutableArray array];
    [chuanguanArr enumerateObjectsUsingBlock:^(BBChuanGuanModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *betTag = [NSString stringWithFormat:@"%@",obj.chuanGuanTag];
        if ([self.chuanGuanArray containsObject:betTag]) {
            [cgStringArr addObject:betTag];
        }
    }];
    
    [self.chuanGuanArray removeAllObjects];
    if (cgStringArr.count) {
        [self.chuanGuanArray addObjectsFromArray:cgStringArr];
    }
    
    
    
}



- (BOOL)getSelectMatchHasDanGuan{
    
    __block BOOL isAllDanGuan = YES;
    
    [self.selectedDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, BBSeletedGameModel *model, BOOL * _Nonnull stop) {
               
        if (model.sfInfo.selectPlayMothedArray.count > 0 && model.sfInfo.isDanGuan == NO) {
            
            isAllDanGuan = NO;
            
            *stop = YES;
        }
        
        if (model.rfsfInfo.selectPlayMothedArray.count > 0 && model.rfsfInfo.isDanGuan == NO ) {
            
            isAllDanGuan = NO;
            
            *stop = YES;
        }
        
        if (model.dxfInfo.selectPlayMothedArray.count > 0 && model.dxfInfo.isDanGuan == NO) {
            
            isAllDanGuan = NO;
            
            *stop = YES;
        }
        
        if (model.sfcInfo.selectPlayMothedArray.count > 0 && model.sfcInfo.isDanGuan == NO) {
            
            isAllDanGuan = NO;
            
            *stop = YES;
        }
        
    }];
    
    return isAllDanGuan;
    
}

- (BOOL)getHasAllDanGuan
{

    //判断是否全是单关
    for (BBSeletedGameModel *gameInfo in [self.selectedDictionary allValues]) {
        
        if (gameInfo.sfInfo.selectPlayMothedArray.count > 0 && gameInfo.sfInfo.isDanGuan == NO) {
            
            return NO;
        }
        
        if (gameInfo.rfsfInfo.selectPlayMothedArray.count > 0 && gameInfo.rfsfInfo.isDanGuan == NO ) {
            return NO;
        }
        
        if (gameInfo.dxfInfo.selectPlayMothedArray.count > 0 && gameInfo.dxfInfo.isDanGuan == NO) {
            
            return NO;
        }
        
        if (gameInfo.sfcInfo.selectPlayMothedArray.count > 0 && gameInfo.sfcInfo.isDanGuan == NO) {
            
            return NO;
        }
    }
    
    return YES;
    
}


#pragma mark ---- 保存/删除投注项 -----

- (void)saveSelectBetInfoWithMatchIssue:(NSString *)matchIssue
                             palyMothed:(NSString *)playMothed
                             selectItem:(NSArray *)selectArray
                              isDanGuan:(BOOL)isDanGuan
                           rangFenCount:(NSString *)rangFenCount
{

    if (!matchIssue || ![matchIssue isKindOfClass:NSString.class] || matchIssue.length == 0) return;
    
    BBSeletedGameModel *gameInfo = self.selectedDictionary[matchIssue];
    
    BBSelectPlayMethodInfo *info = [[BBSelectPlayMethodInfo alloc] init];
    info.playMothed = playMothed;
    info.isDanGuan = isDanGuan;
    info.selectPlayMothedArray = [NSMutableArray arrayWithArray:selectArray];
    info.rangFenCount = rangFenCount;
    
    if (gameInfo == nil) {
        
        BBSeletedGameModel *singleGame = [[BBSeletedGameModel alloc] init];
        
        singleGame.matchIssue = matchIssue;
    
        
        if ([playMothed isEqualToString:@"sf"]) {
            
            singleGame.sfInfo = info;
            
            [self.selectedDictionary setObject:singleGame forKey:matchIssue];
            
            return;
        }
        
        if ([playMothed isEqualToString:@"rfsf"]) {
            
            singleGame.rfsfInfo = info;
            
            [self.selectedDictionary setObject:singleGame forKey:matchIssue];
            
            return;
        }
        
        if ([playMothed isEqualToString:@"dxf"]) {
            
            singleGame.dxfInfo = info;
            
            [self.selectedDictionary setObject:singleGame forKey:matchIssue];
            
            return;
        }
        
        if ([playMothed isEqualToString:@"sfc"]) {
            
            singleGame.sfcInfo = info;
            
            [self.selectedDictionary setObject:singleGame forKey:matchIssue];
            
            return;
        }
        
        return;
    }
    
    
    
    
    
    if ([playMothed isEqualToString:@"sf"]) {
        
        
        if (gameInfo.sfInfo == nil) {
            
            gameInfo.sfInfo = info;
            
        }else{
        
            for (NSString *selectItem in selectArray) {
                
                if (![gameInfo.sfInfo.selectPlayMothedArray containsObject:selectArray]) {
                    
                    [gameInfo.sfInfo.selectPlayMothedArray addObject:selectItem];
                }
            }
            
        }
        
        return;
    }
    
    
    
    
    if ([playMothed isEqualToString:@"rfsf"]) {
        
        if (gameInfo.rfsfInfo == nil) {
            
            gameInfo.rfsfInfo = info;
        
        }else{
        
            for (NSString *selectItem in selectArray) {
                
                if (![gameInfo.rfsfInfo.selectPlayMothedArray containsObject:selectArray]) {
                    
                    [gameInfo.rfsfInfo.selectPlayMothedArray addObject:selectItem];
                }
            }
        }
        return;
    }
    
    
    
    if ([playMothed isEqualToString:@"dxf"]) {
        
        if (gameInfo.dxfInfo == nil) {
            
            gameInfo.dxfInfo = info;
            
        }else{
        
            for (NSString *selectItem in selectArray) {
                
                if (![gameInfo.dxfInfo.selectPlayMothedArray containsObject:selectArray]) {
                    
                    [gameInfo.dxfInfo.selectPlayMothedArray addObject:selectItem];
                }
            }
        
        }
        return;
    }
    
    if ([playMothed isEqualToString:@"sfc"]) {
        
        if (gameInfo.sfcInfo == nil) {
            
            gameInfo.sfcInfo = info;
            
        }else{
        
            [gameInfo.sfcInfo.selectPlayMothedArray removeAllObjects];
            
            for (NSString *selectItem in selectArray) {
                
                if (![gameInfo.sfcInfo.selectPlayMothedArray containsObject:selectArray]) {
                    
                    [gameInfo.sfcInfo.selectPlayMothedArray addObject:selectItem];
                }
            }
        
        }
    
    }
    
    
    //比赛没有选中的玩法时，删除比赛
    if (gameInfo.sfInfo.selectPlayMothedArray.count == 0 && gameInfo.rfsfInfo.selectPlayMothedArray.count == 0 && gameInfo.dxfInfo.selectPlayMothedArray.count == 0 && gameInfo.sfcInfo.selectPlayMothedArray.count == 0) {
        
        [self removeOneMatchWithIssue:matchIssue];
    }
}


- (void)saveSelectBetInfoWithMatchIssue:(NSString *)matchIssue
                             palyMothed:(NSString *)playMothed
                             selectItem:(NSArray *)selectArray
                              isDanGuan:(BOOL)isDanGuan
{

    [self saveSelectBetInfoWithMatchIssue:matchIssue palyMothed:playMothed selectItem:selectArray isDanGuan:isDanGuan rangFenCount:@"0"];
}

#pragma mark ---- 是否可以保存/更改投注项 -----
- (BOOL)isCanSaveSelectBetInfoWithMatchIssue:(NSString *)matchIssue
{

    if (matchIssue == nil) return NO;
    
    if (matchIssue.length < 1) return NO;
    
    if (self.getSelectMatchCount == 8) {
    
        if (self.selectedDictionary[matchIssue] != nil) {
            
            return YES;
        }else{
        
            return NO;
        }
    }
    
    return YES;
}

- (void)removeSelectBetInfoWithMatchIssue:(NSString *)matchIssue
                               palyMothed:(NSString *)playMothed
                               selectItem:(NSArray *)selectArray
{
    
    BBSeletedGameModel *gameInfo = self.selectedDictionary[matchIssue];
    
    if (gameInfo == nil) return;
    
    if ([playMothed isEqualToString:@"sf"]) {
        
        for (NSString *selectItem in selectArray) {
            if ([gameInfo.sfInfo.selectPlayMothedArray containsObject:selectItem]) {
                [gameInfo.sfInfo.selectPlayMothedArray removeObject:selectItem];
            }
        }
    }
    
    if ([playMothed isEqualToString:@"rfsf"]) {
        
        for (NSString *selectItem in selectArray) {
            if ([gameInfo.rfsfInfo.selectPlayMothedArray containsObject:selectItem]) {
                [gameInfo.rfsfInfo.selectPlayMothedArray removeObject:selectItem];
            }
        }
    }
    
    if ([playMothed isEqualToString:@"dxf"]) {
        
        for (NSString *selectItem in selectArray) {
            if ([gameInfo.dxfInfo.selectPlayMothedArray containsObject:selectItem]) {
                [gameInfo.dxfInfo.selectPlayMothedArray removeObject:selectItem];
            }
        }
    }
    
    if ([playMothed isEqualToString:@"sfc"]) {
        
        for (NSString *selectItem in selectArray) {
            if ([gameInfo.sfcInfo.selectPlayMothedArray containsObject:selectItem]) {
                [gameInfo.sfcInfo.selectPlayMothedArray removeObject:selectItem];
            }
        }
    }
    
    
    //没有选项时删除这场比赛
    if (gameInfo.sfInfo.selectPlayMothedArray.count == 0 && gameInfo.rfsfInfo.selectPlayMothedArray.count == 0 && gameInfo.dxfInfo.selectPlayMothedArray.count == 0 && gameInfo.sfcInfo.selectPlayMothedArray.count == 0) {
        
        [self removeOneMatchWithIssue:matchIssue];
    }
    
}



#pragma mark ---- 是否可以删除一场比赛 ----
- (BOOL)afterRemoveCanBetWithMatchIssue:(NSString *)matchIssue
{
    
    NSMutableArray *mulArray = [NSMutableArray arrayWithArray:[self.selectedDictionary allValues]];
    
    for (BBSeletedGameModel *gameInfo in [self.selectedDictionary allValues]) {
        
        if ([gameInfo.matchIssue isEqualToString:matchIssue]) {
            [mulArray removeObject:gameInfo];
        }
    }
    
    
    //判断
    NSInteger count = 0;
    BOOL isAllDanGuan = YES;
    for (BBSeletedGameModel *singleGameInfo in mulArray) {
        
        BOOL isVaild = NO;

        
        if (singleGameInfo.sfInfo.selectPlayMothedArray.count > 0) {
            
            isVaild = YES;
            
            if ( !singleGameInfo.sfInfo.isDanGuan) isAllDanGuan = NO;
        }
        
        if (singleGameInfo.rfsfInfo.selectPlayMothedArray.count > 0) {
            
            isVaild = YES;
            
            if ( !singleGameInfo.rfsfInfo.isDanGuan) isAllDanGuan = NO;
        }
        
        if (singleGameInfo.dxfInfo.selectPlayMothedArray.count > 0) {
            
            isVaild = YES;
            
            if ( !singleGameInfo.dxfInfo.isDanGuan) isAllDanGuan = NO;
        }
        
        if (singleGameInfo.sfcInfo.selectPlayMothedArray.count > 0) {
            
            isVaild = YES;
            
            if ( !singleGameInfo.sfcInfo.isDanGuan) isAllDanGuan = NO;
        }
        
        if (isVaild) count++;
        
    }
    
    //如果比赛场数大于0，并且全是单关
    if (isAllDanGuan && count > 0) return YES;
    
    //如果比赛大于两场
    if (count > 1) return YES;
        
    return NO;
    
}


//- (BOOL)getHasAllDanGuan{
//    
//    //判断是否全是单关
//    for (SLBetSelectSingleGameInfo *singleGameInfo in [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo) {
//        
//        for (SLBetSelectPlayMothedInfo *playMothedInfo in singleGameInfo.singleBetSelectArray) {
//            
//            if (playMothedInfo.selectPlayMothedArray.count > 0) {
//                
//                if (!playMothedInfo.isDanGuan) {
//                    return NO;
//                }
//            }
//        }
//    }
//    return YES;
//}

- (NSInteger)getSelectMatchCount
{
    
    return self.selectedDictionary.count;
}

+ (NSString *)getCreateOrderNumber{
    
    NSString *lotteryNumber = @"";
//
//    //排序 升序
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[[[BBMatchInfoManager shareManager].selectedDictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2)
     {
        return [obj1 compare:obj2]; //升序
        
     }]];
    
    for (NSString *matchbetString in tempArray) {
        
        BBSeletedGameModel *betModel = [[BBMatchInfoManager shareManager].selectedDictionary objectForKey:matchbetString];
        /** 20170815301:3#101#1003:0 20170815302:1000:0*/
        lotteryNumber = [lotteryNumber stringByAppendingFormat:@" %@",[betModel getCreadOrderString]];
        NSLog(@"%@",lotteryNumber);
    }
    
    
    if (lotteryNumber.length > 0) {
        
        return [lotteryNumber substringFromIndex:1];
    }else{
        return @"";
    }
}

+ (NSString *)getCreateOrderChuanGuan
{
    
    NSString *chuanGuan = @"";
    
    //获取串关数组
    NSMutableArray *array = [NSMutableArray arrayWithArray:[BBMatchInfoManager shareManager].chuanGuanArray];
    
    //排序
    [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        return [obj1 compare:obj2];
    }];
    
    //拼接串关项
    for (NSString *chanGuanTag in array) {
        chuanGuan = [NSString stringWithFormat:@"%@|%@", chuanGuan, [NSString stringWithFormat:@"%@_1", chanGuanTag]];
    }
    if (chuanGuan.length > 0) {
        return [chuanGuan substringFromIndex:1];
    }else{
        return @"";
    }
}

+ (NSArray *)getNeedShowLeagueMatchs
{
    return [BBMatchInfoManager shareManager].leagueMatchesArray;
}

+ (void)updateLeagueMatchesArray:(NSArray *)leagueArr
{
    if (!leagueArr || leagueArr.count == 0) return;
    [[BBMatchInfoManager shareManager].leagueMatchesArray removeAllObjects];
    [[BBMatchInfoManager shareManager].leagueMatchesArray addObjectsFromArray:leagueArr];
}

#pragma mark --- 倍数 ----
- (NSInteger)getMultiple
{
    return self.betMultiple;
}

- (NSInteger)getDefaultMultiple
{
    self.betMultiple = defaultBetMultiple;
    return defaultBetMultiple;
}

- (void)setMuitple:(NSInteger)number
{
    self.betMultiple = number;
}

- (NSInteger)getMaxMultiple
{

    return self.maxTimes;
}

#pragma mark ---- 注数 ----
- (NSInteger)getNote
{
    if (self.chuanGuanArray.count == 0) return 0;
    
    
    //获取每场比赛的选中项个数
    NSMutableArray *selectCountArray = [NSMutableArray arrayWithCapacity:0];
    
    
    for (BBSeletedGameModel *gameInfo in [self.selectedDictionary allValues]) {
        
        NSInteger count = 0;
        
        count = gameInfo.sfInfo.selectPlayMothedArray.count + gameInfo.rfsfInfo.selectPlayMothedArray.count + gameInfo.dxfInfo.selectPlayMothedArray.count + gameInfo.sfcInfo.selectPlayMothedArray.count;
        
        if (count > 0) {
            
            [selectCountArray addObject:@(count)];
        }
        
    }
    //先排列组合
    NSMutableArray *result = [NSMutableArray array];//结果
    NSMutableArray *list = [NSMutableArray array];//每次递归的子集
    NSInteger pos = 0;//保证子集升序排列
    [self permutationAndCombination:result list:list nums:selectCountArray postion:pos];
    
    //遍历选中的串关
    NSInteger note = 0;
    for (NSString *chuanGuanTag in self.chuanGuanArray) {
        for (NSArray *res in result) {
            if (res.count == [chuanGuanTag integerValue]) {
                NSInteger oneNum = 1;
                for (NSNumber *num in res) {
                    oneNum *= [num integerValue];
                }
                note += oneNum;
            }
        }
    }
    return note;

}

//排列组合 递归
- (void)permutationAndCombination:(NSMutableArray<NSMutableArray *> *)result
                             list:(NSMutableArray *)list
                             nums:(NSArray *)nums
                          postion:(NSInteger)pos {
    [result addObject:[list mutableCopy]];
    for (NSInteger i = pos; i < nums.count; i++) {
        [list addObject:nums[i]];
        [self permutationAndCombination:result list:list nums:nums postion:i + 1];
        [list removeObjectAtIndex:list.count - 1];
    }
}

#pragma mark --- 预计奖金 ----
- (NSString *)getEstimateBonus
{

    //没有奖金
    if (self.chuanGuanArray.count == 0) return @"";
    

    //取每场比赛的最低赔率 和 最高赔率 并排序
    NSMutableArray *minOddsArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *maxOddsArray = [NSMutableArray arrayWithCapacity:0];
    
    for (BBSeletedGameModel *singleGameInfo in [self.selectedDictionary allValues]) {
        
        BBMatchModel *matchModel = [self getMatchInfoWithIssue:singleGameInfo.matchIssue];
        NSDecimalNumber * minOdds = [NSDecimalNumber decimalNumberWithString:@"10000"];
        NSDecimalNumber * maxOdds = [NSDecimalNumber decimalNumberWithString:@"0"];
        
        for (NSString *tag in singleGameInfo.sfInfo.selectPlayMothedArray) {
            
            
            NSDecimalNumber *odds = [NSDecimalNumber decimalNumberWithString:[matchModel getOddsWithTag:tag]];

            NSComparisonResult maxResult = [odds compare:maxOdds];
            
            if (maxResult == NSOrderedDescending) {
                
                maxOdds = odds;
                
                NSLog(@"%@",maxOdds.description);
                
            }
            
            NSComparisonResult minResult = [odds compare:minOdds];
            
            if (minResult == NSOrderedAscending) {
                
                minOdds = odds;
                
                NSLog(@"%@",minOdds.description);
            }
            
        }
        
        for (NSString *tag in singleGameInfo.rfsfInfo.selectPlayMothedArray) {
            
//            CGFloat odds = [matchModel getOddsWithTag:tag];
//            if (odds != 0 && odds < minOdds) {
//                minOdds = odds;
//            }
//            if (odds != 0 && odds > maxOdds) {
//                maxOdds = odds;
//            }
            
            NSDecimalNumber *odds = [NSDecimalNumber decimalNumberWithString:[matchModel getOddsWithTag:tag]];
            
            NSLog(@"%@",maxOdds.description);
            NSLog(@"%@",odds.description);
            NSComparisonResult result = [odds compare:maxOdds];
            //  > 号
            if (result == NSOrderedDescending) {
                
                maxOdds = odds;
                
                NSLog(@"%@",maxOdds.description);
                
            }
            
            NSComparisonResult minResult = [odds compare:minOdds];
            //  < 号
            if (minResult == NSOrderedAscending) {
                
                minOdds = odds;
                
                NSLog(@"%@",minOdds.description);
            }
        }
        
        for (NSString *tag in singleGameInfo.dxfInfo.selectPlayMothedArray) {
            
            NSDecimalNumber *odds = [NSDecimalNumber decimalNumberWithString:[matchModel getOddsWithTag:tag]];
            
            NSComparisonResult result = [odds compare:maxOdds];
            
            if (result == NSOrderedDescending) {
                
                maxOdds = odds;
                
                NSLog(@"%@",maxOdds.description);
                
            }
            
            NSComparisonResult minResult = [odds compare:minOdds];
            
            if (minResult == NSOrderedAscending) {
                
                minOdds = odds;
                
                NSLog(@"%@",minOdds.description);
            }
        }
        
        for (NSString *tag in singleGameInfo.sfcInfo.selectPlayMothedArray) {
            
            NSDecimalNumber *odds = [NSDecimalNumber decimalNumberWithString:[matchModel getOddsWithTag:tag]];
            
            NSComparisonResult result = [odds compare:maxOdds];
            
            if (result == NSOrderedDescending) {
                
                maxOdds = odds;
                
                NSLog(@"%@",maxOdds.description);
            }
            
            NSComparisonResult minResult = [odds compare:minOdds];
            
            if (minResult == NSOrderedAscending) {
                
                minOdds = odds;
                
                NSLog(@"%@",minOdds.description);
            }
        }
        
        
        if ([minOdds.description floatValue] > 0) {
            
            NSLog(@" --- %@",minOdds.description);
            
            [minOddsArray addObject:minOdds];
        }
        if ([maxOdds.description floatValue] > 0) {
            
            NSLog(@" ++++ %@",maxOdds.description);
            
            [maxOddsArray addObject:maxOdds];
        }
    }
    
    //排序升序
    [minOddsArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    //排序降序
    [maxOddsArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
    
    
    
    //根据当前选择的串关  取最大值和最小值
    NSDecimalNumber  *minBonus = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",(self.betMultiple * 2)]];
    //2 * self.betMultiple;//单注2元
    NSDecimalNumber  *maxBonus = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",(self.betMultiple * 2)]];
    //2 * self.betMultiple;//单注2元
    
    //取最大串关数 和最小串关数
    NSMutableArray *tempChuanGuanArray = [NSMutableArray arrayWithArray:self.chuanGuanArray];
    
    [tempChuanGuanArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSDecimalNumberHandler*roundUp = [NSDecimalNumberHandler
                                      
                                      decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                      
                                      scale:4
                                      
                                      raiseOnExactness:NO
                                      
                                      raiseOnOverflow:NO
                                      
                                      raiseOnUnderflow:NO
                                      
                                      raiseOnDivideByZero:NO];
    
    for (NSInteger i = 0; i < [[tempChuanGuanArray firstObject] integerValue]; i++) {
        if (i < minOddsArray.count) {
            
            
            minBonus = [minBonus decimalNumberByMultiplyingBy:minOddsArray[i] withBehavior:roundUp];
            
            NSLog(@"%@",minBonus.description);
            
            //minBonus *= [minOddsArray[i] floatValue];
        }
    }
    for (NSInteger i = 0; i < [[tempChuanGuanArray lastObject] integerValue]; i++) {
        if (i < maxOddsArray.count) {
//            maxBonus *= [maxOddsArray[i] floatValue];
            
            maxBonus = [maxBonus decimalNumberByMultiplyingBy:maxOddsArray[i] withBehavior:roundUp];
            
            NSLog(@"%@",maxBonus.description);
        }
    }
    
    //去两位小数 去比较
//    minBonus = [[NSString stringWithFormat:@"%.2f",minBonus] floatValue];
//    maxBonus = [[NSString stringWithFormat:@"%.2f",maxBonus] floatValue];
    
    NSLog(@"----- %@",minBonus.description);
    NSLog(@"----- %@",maxBonus.description);
    
    
    NSComparisonResult result = [minBonus compare:maxBonus];
    
    NSDecimalNumberHandler*roundDown = [NSDecimalNumberHandler
                                      
                                      decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                      
                                      scale:2
                                      
                                      raiseOnExactness:NO
                                      
                                      raiseOnOverflow:NO
                                      
                                      raiseOnUnderflow:NO
                                      
                                      raiseOnDivideByZero:NO];

    
    if (result == NSOrderedAscending) {
       minBonus = [minBonus decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"0.0"] withBehavior:roundDown];
        maxBonus = [maxBonus decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"0.0"] withBehavior:roundDown];
        return [NSString stringWithFormat:@"%@~%@元" , minBonus.description, maxBonus.description];
        
    }else if (result == NSOrderedSame){
        minBonus = [minBonus decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"0.0"] withBehavior:roundDown];
        return [NSString stringWithFormat:@"%@元" , minBonus.description];
    }else{
    
        maxBonus = [minBonus decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"0.0"] withBehavior:roundDown];
        return [NSString stringWithFormat:@"%@元" , maxBonus.description];
        
    }
    
    
//    if (minBonus < maxBonus) {
//        
//        return [NSString stringWithFormat:@"%.2f~%.2f元" , minBonus, maxBonus];
//    }else if (minBonus == maxBonus){
//        
//        return [NSString stringWithFormat:@"%.2f元" , minBonus];
//    }else{
//        
//        return @"";
//    }
}

#pragma mark ---- 保存串关项 ----
- (void)saveSelectChuanGuan:(NSString *)chuanGuanTag
{
    
    if (![self.chuanGuanArray containsObject:chuanGuanTag]) {
        
        [self.chuanGuanArray addObject:chuanGuanTag];
    }
}

#pragma mark ---- 删除串关项 -----
- (void)removeSelectChuanGuan:(NSString *)chuanGuanTag
{
    
    if ([self.chuanGuanArray containsObject:chuanGuanTag]) {
        
        [self.chuanGuanArray removeObject:chuanGuanTag];
    }
}


#pragma mark --- 串关数组 ----
- (NSArray *)getChuanGuanArray
{
    
    NSMutableArray *chuanGuanArray = [[NSMutableArray alloc] initWithCapacity:0];
    //判断是否全是单关
    BOOL isAllDanGuan = YES;
    BOOL hasOrtherPlay = NO;//记录是否有其他玩法  最多4串1
    
    
    for (BBSeletedGameModel *singleGameInfo in [self.selectedDictionary allValues]) {
        
        
        if (singleGameInfo.sfInfo.selectPlayMothedArray.count > 0) {
            
            if (singleGameInfo.sfInfo.isDanGuan == NO) {
                
                isAllDanGuan = NO;
            }
        }
        
        if (singleGameInfo.rfsfInfo.selectPlayMothedArray.count > 0) {
            
            if (singleGameInfo.rfsfInfo.isDanGuan == NO) {
                
                isAllDanGuan = NO;
            }
         }
            
            if (singleGameInfo.dxfInfo.selectPlayMothedArray.count > 0) {
                
                if (singleGameInfo.dxfInfo.isDanGuan == NO) {
                    
                    isAllDanGuan = NO;
                }
            }
                
            if (singleGameInfo.sfcInfo.selectPlayMothedArray.count > 0) {
                
                if (singleGameInfo.sfcInfo.isDanGuan == NO) {
                    
                    isAllDanGuan = NO;
                }
                    
                    hasOrtherPlay = YES;
            }
    
    }
    
    
    if (isAllDanGuan) {
        
        BBChuanGuanModel *chuanGuan = [[BBChuanGuanModel alloc] init];
        chuanGuan.chuanGuanTag = @"1";
        chuanGuan.chuanGuanTitle = self.chuanGuanDic[chuanGuan.chuanGuanTag];
        chuanGuan.isSelect = [self.chuanGuanArray containsObject:chuanGuan.chuanGuanTag];
        [chuanGuanArray addObject:chuanGuan];
    }
    //添加其他串关
    for (NSInteger i = 2; i <= [self getSelectMatchCount]; i++) {
        
        if (hasOrtherPlay) {
            if (i <= 4) {
                BBChuanGuanModel *chuanGuan = [[BBChuanGuanModel alloc] init];
                chuanGuan.chuanGuanTag = [NSString stringWithFormat:@"%zi", i];
                chuanGuan.chuanGuanTitle = self.chuanGuanDic[chuanGuan.chuanGuanTag];
                chuanGuan.isSelect = [self.chuanGuanArray containsObject:chuanGuan.chuanGuanTag];
                [chuanGuanArray addObject:chuanGuan];
            }
        }else{
            if (i <= 8) {
                BBChuanGuanModel *chuanGuan = [[BBChuanGuanModel alloc] init];
                chuanGuan.chuanGuanTag = [NSString stringWithFormat:@"%zi", i];
                chuanGuan.chuanGuanTitle = self.chuanGuanDic[chuanGuan.chuanGuanTag];
                chuanGuan.isSelect = [self.chuanGuanArray containsObject:chuanGuan.chuanGuanTag];
                [chuanGuanArray addObject:chuanGuan];
                
            }
        }
    }
    return chuanGuanArray;
}

- (NSInteger)getCurrentMaxChuanGuanCount
{
    
    BOOL hasOrtherPlay = NO;//记录是否有其他玩法  最多4串1

    
    for (BBSeletedGameModel *singleGameInfo in [self.selectedDictionary allValues]) {
        
        
        if (singleGameInfo.sfInfo.selectPlayMothedArray && singleGameInfo.sfInfo.selectPlayMothedArray.count > 0) {
            
            if (singleGameInfo.sfInfo.isDanGuan == YES) {
                
                hasOrtherPlay = YES;
            }
        }
        
        if (singleGameInfo.rfsfInfo.selectPlayMothedArray && singleGameInfo.rfsfInfo.selectPlayMothedArray.count > 0) {
            
            if (singleGameInfo.rfsfInfo.isDanGuan == YES) {
                
                hasOrtherPlay = YES;
            }
        }
        
        if (singleGameInfo.dxfInfo.selectPlayMothedArray && singleGameInfo.dxfInfo.selectPlayMothedArray.count > 0) {
            
            if (singleGameInfo.dxfInfo.isDanGuan == YES) {
                
                hasOrtherPlay = YES;
            }
        }
        
        if (singleGameInfo.sfcInfo.selectPlayMothedArray && singleGameInfo.sfcInfo.selectPlayMothedArray.count > 0) {
            
            if (singleGameInfo.sfcInfo.isDanGuan == YES) {
                
                hasOrtherPlay = YES;
            
            }
        }
    }

    
    
    if (hasOrtherPlay) {
        
        return ([self getSelectMatchCount] > 4) ? 4 : [self getSelectMatchCount];
    }else{
        
        return [self getSelectMatchCount];
    }
}


- (NSInteger)getSelectChuanGuanArrayCount
{

    [self.chuanGuanArray removeAllObjects];
    
    return self.chuanGuanArray.count;
}



#pragma mark ----- lazyLoad ----

- (NSMutableArray<BBMatchGroupModel *> *)allMatchsArray
{
    
    if (!_allMatchsArray) {
        _allMatchsArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _allMatchsArray;
}

- (NSMutableArray *)allFilterMatchArray
{
    
    if (!_allFilterMatchArray) {
        _allFilterMatchArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _allFilterMatchArray;
}

- (NSMutableArray<BBLeagueModel *> *)leagueMatchesArray
{
    
    if (!_leagueMatchesArray) {
        _leagueMatchesArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _leagueMatchesArray;
}

- (NSMutableArray *)chuanGuanArray
{
    
    if (!_chuanGuanArray) {
        _chuanGuanArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _chuanGuanArray;
}

- (NSMutableDictionary *)selectedDictionary
{

    if (_selectedDictionary == nil) {
        
        _selectedDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _selectedDictionary;
}


- (NSDictionary *)chuanGuanDic
{
    
    if (_chuanGuanDic == nil) {
        
        _chuanGuanDic = @{@"1" : @"单关",
                          @"2" : @"2串1",
                          @"3" : @"3串1",
                          @"4" : @"4串1",
                          @"5" : @"5串1",
                          @"6" : @"6串1",
                          @"7" : @"7串1",
                          @"8" : @"8串1"};
    }
    return _chuanGuanDic;
}

@end
