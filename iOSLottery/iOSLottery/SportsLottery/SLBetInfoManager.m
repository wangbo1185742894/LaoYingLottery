//
//  SLBetInfoManager.m
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/17.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBetInfoManager.h"
#import "SLBetInfoCache.h"
#import "SLMatchBetModel.h"
#import "SLChuanGuanModel.h"


@implementation SLBetInfoManager

/**
 记录最近一次服务器推荐倍数
 */
static NSInteger defaultBetMultiple;

+ (void)saveAndclassifyAllMatchsInfo:(id)data{
    
    if ([data isKindOfClass:[NSDictionary class]] && data) {
        //存储gameId
        NSNumber *jczq = data[@"jczq_mix_p"];
        NSNumber *maxTime = data[@"maxTimes"];
        NSNumber *defaultTimes = data[@"defaultTimes"];
        
        defaultBetMultiple = [defaultTimes longLongValue];
        
        if ([jczq isKindOfClass:[NSNumber class]] && jczq) {
        
            [SLBetInfoCache shareBetInfoCache].jczq_mix_p = data[@"jczq_mix_p"];
        }
        if ([maxTime isKindOfClass:[NSNumber class]] && maxTime) {
            [SLBetInfoCache shareBetInfoCache].maxTimes = [maxTime longLongValue];
        }
        if ([defaultTimes isKindOfClass:[NSNumber class]] && defaultTimes) {
            [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betMultiple = [defaultTimes longLongValue];
        }
        //存储比赛 并将已选择的比赛中已过期的比赛清除掉
        NSArray *array = data[@"allMatches"];
        if ([array isKindOfClass:[NSArray class]] && array && array.count > 0) {
            [[SLBetInfoCache shareBetInfoCache].allMatchsArray removeAllObjects];
            [[SLBetInfoCache shareBetInfoCache].allMatchsArray addObjectsFromArray:[SLMatchBetGroupModel mj_objectArrayWithKeyValuesArray:array]];
            //归类所有联赛 并 筛出已过期但已选择的比赛
            [self classifyLeagueMatches];
        }
        
    }
}
//归类所有的联赛
+ (void)classifyLeagueMatches{
    
    NSArray *tempArray = [NSArray arrayWithArray:[SLBetInfoCache shareBetInfoCache].leagueMatchesArray];
    
    [[SLBetInfoCache shareBetInfoCache].leagueMatchesArray removeAllObjects];
    
    NSMutableArray *allMatchs = [NSMutableArray arrayWithCapacity:0];
    
    for (SLMatchBetGroupModel *groupModel in [SLBetInfoCache shareBetInfoCache].allMatchsArray) {
        
        for (SLMatchBetModel *model in groupModel.matches) {
            
            [allMatchs addObject:model.match_issue];
            
            
            BOOL isExist = NO;
            for (SLMatchSelectModel *existSeasionModel in [SLBetInfoCache shareBetInfoCache].leagueMatchesArray) {
                if (existSeasionModel.seasionId == model.season_id) {
                    
                    existSeasionModel.leagueTotal ++;
                    
                    NSLog(@"%ld",existSeasionModel.leagueTotal);
                    isExist = YES;
                    
                    break;
                }

            }
            if (!isExist) {
                
                SLMatchSelectModel *seasionModel = [[SLMatchSelectModel alloc] init];
                seasionModel.seasionId = model.season_id;
                seasionModel.titile = model.season_pre;
                seasionModel.isSelect = YES;
                seasionModel.isFiveLeague = !(model.is_five_league == 0);
                seasionModel.leagueTotal = 1;
                
                for (SLMatchSelectModel *tempModel in tempArray) {
                    
                    if (tempModel.seasionId == seasionModel.seasionId) {
                        
                        seasionModel.isSelect = tempModel.isSelect;
                    }
                }
                
                [[SLBetInfoCache shareBetInfoCache].leagueMatchesArray addObject:seasionModel];
            }
        }
        
    }
    [self deleteUnexistMatchWithAllMatch:allMatchs];
}
//将不存在的比赛 但之前已选择的比赛删除
+ (void)deleteUnexistMatchWithAllMatch:(NSArray *)matchArrays{
    
    [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo enumerateObjectsUsingBlock:^(SLBetSelectSingleGameInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
     
        if (![matchArrays containsObject:obj.matchIssue]) {
            
            [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo removeObject:obj];
        }
    }];
    
}
+ (SLMatchBetModel *)getMatchInfoWithIssue:(NSString *)matchIssue{
    
    for (SLMatchBetGroupModel *groupModel in [SLBetInfoCache shareBetInfoCache].allMatchsArray) {
        
        for (SLMatchBetModel *model in groupModel.matches) {
            if ([model.match_issue isEqualToString:matchIssue]) {
                return model;
            }
        }
    }
    return nil;
}



+ (NSString *)getGameId{
    
    return [NSString stringWithFormat:@"%@",[SLBetInfoCache shareBetInfoCache].jczq_mix_p];
}


+ (NSArray *)getNeedShowMatchs{
    
    NSMutableArray *needShowArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (SLMatchBetGroupModel *groupModel in [SLBetInfoCache shareBetInfoCache].allMatchsArray) {
        
        SLMatchBetGroupModel *showGroupModel = [[SLMatchBetGroupModel alloc] init];
        
        for (SLMatchBetModel *matchBetModel in groupModel.matches) {
            for (SLMatchSelectModel *selectModel in [SLBetInfoCache shareBetInfoCache].leagueMatchesArray) {
                if (selectModel.isSelect) {
                    if (matchBetModel.season_id == selectModel.seasionId) {
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

+(void)saveOneMatchSelectInfo:(SLBetSelectSingleGameInfo *)oneGameInfo{
    
    NSInteger __block index = -1;
    [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo enumerateObjectsUsingBlock:^(SLBetSelectSingleGameInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.matchIssue isEqualToString:oneGameInfo.matchIssue]) {
            index = idx;
        }
    }];
    
    if (index == -1) {
        [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo addObject:oneGameInfo];
    }else{
        [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo replaceObjectAtIndex:index withObject:oneGameInfo];
    }
    [self deleteExistErrorChuanGuan];
}

+ (void)saveSelectBetInfoWithMatchIssue:(NSString *)matchIssue
                             palyMothed:(NSString *)playMothed
                             selectItem:(NSArray *)selectArray
                              isDanGuan:(BOOL)isDanGuan
{
    
    [[SLBetInfoCache shareBetInfoCache].allSelectBetItem saveSelectBetInfoWithMatchIssue:matchIssue palyMothed:playMothed selectItem:selectArray isDanGuan:isDanGuan];
    [self deleteExistErrorChuanGuan];
}

+ (void)saveSelectBetInfoWithMatchIssue:(NSString *)matchIssue
                             palyMothed:(NSString *)playMothed
                             selectItem:(NSArray *)selectArray
                              isDanGuan:(BOOL)isDanGuan
                           rangQiuCount:(NSString *)rangQiuCount{
    
    [[SLBetInfoCache shareBetInfoCache].allSelectBetItem saveSelectBetInfoWithMatchIssue:matchIssue palyMothed:playMothed selectItem:selectArray isDanGuan:isDanGuan rangQiuCount:rangQiuCount];
    [self deleteExistErrorChuanGuan];
}
+ (void)removeSelectBetInfoWithMatchIssue:(NSString *)matchIssue
                               palyMothed:(NSString *)playMothed
                               selectItem:(NSArray *)selectArray{
    
    [[SLBetInfoCache shareBetInfoCache].allSelectBetItem removeSelectBetInfoWithMatchIssue:matchIssue palyMothed:playMothed selectItem:selectArray];
    [self deleteExistErrorChuanGuan];
}
+ (void)removeOneMatchWithIssue:(NSString *)matchIssue{
    
    NSMutableArray *mulArray = [NSMutableArray arrayWithArray:[SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo];
    for (SLBetSelectSingleGameInfo *gameInfo in [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo) {
        
        if ([gameInfo.matchIssue isEqualToString:matchIssue]) {
            [mulArray removeObject:gameInfo];
        }
    }
    
    [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo removeAllObjects];
    [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo addObjectsFromArray:mulArray];
    
    [self deleteExistErrorChuanGuan];
}
+ (void)clearMatch{
    
    [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo removeAllObjects];
    [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray removeAllObjects];
    [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betMultiple = defaultBetMultiple;
}

+ (void)saveSelecrChuanGuan:(NSString *)chuanGuanTag{
    
    if (![[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray containsObject:chuanGuanTag]) {
    
        [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray addObject:chuanGuanTag];
    }
}

+(void)removeSelecrChuanGuan:(NSString *)chuanGuanTag{
    
    if ([[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray containsObject:chuanGuanTag]) {
        
        [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray removeObject:chuanGuanTag];
    }
}





+ (BOOL)afterRemoveCanBetWithMatchIssue:(NSString *)matchIssue{
    
    NSMutableArray *mulArray = [NSMutableArray arrayWithArray:[SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo];
    for (SLBetSelectSingleGameInfo *gameInfo in [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo) {
        
        if ([gameInfo.matchIssue isEqualToString:matchIssue]) {
            [mulArray removeObject:gameInfo];
        }
    }
    //判断
    NSInteger count = 0;
    BOOL isAllDanGuan = YES;
    for (SLBetSelectSingleGameInfo *singleGameInfo in mulArray) {
        
        BOOL isVaild = NO;
        for (SLBetSelectPlayMothedInfo *playInfo in singleGameInfo.singleBetSelectArray) {
            //判断存在有效比赛
            if (playInfo.selectPlayMothedArray.count > 0) {
             
                isVaild = YES;
                if (!playInfo.isDanGuan) isAllDanGuan = NO;
            }
            
        }
        if (isVaild) count++;
    }
    if (isAllDanGuan && count > 0) {
        //如果比赛场数大于0，并且全是单关
        return YES;
    }else if (count > 1){
        //如果比赛大于两场
        return YES;
    }else{
        return NO;
    }
}



+ (SLBetSelectSingleGameInfo *)getSingleMatchSelectInfoWithMatchIssue:(NSString *)matchIssue{
    
    for (SLBetSelectSingleGameInfo *singleGameInfo in [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo) {
        if ([singleGameInfo.matchIssue isEqualToString:matchIssue]) {
            
            return singleGameInfo;
        }
    };
    return nil;
}

+ (NSInteger)getSingleMatchSelectPlayMothedNumberWithMatchIssue:(NSString *)matchIssue{
    
    SLBetSelectSingleGameInfo *singleGameInfo = [self getSingleMatchSelectInfoWithMatchIssue:matchIssue];
    NSInteger count = 0;
    for (SLBetSelectPlayMothedInfo *playInfo in singleGameInfo.singleBetSelectArray) {
        count += playInfo.selectPlayMothedArray.count;
    }
    return count;
}

+ (NSInteger)getSelectMatchCount{
    
    NSInteger count = 0;
    
    for (SLBetSelectSingleGameInfo *singleGameInfo in [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo) {
        BOOL isHasMatch = NO;//该比赛是否含有选中项
        for (SLBetSelectPlayMothedInfo *playInfo in singleGameInfo.singleBetSelectArray) {
            
            if (playInfo.selectPlayMothedArray.count > 0) {
                isHasMatch = (playInfo.selectPlayMothedArray.count > 0);//含有有效的选项
                break;
            }
        }
        if (isHasMatch) {
            count ++;
        }
    }
    return count;
}

+ (BOOL)getSelectMatchHasDanGuan{
    
    for (SLBetSelectSingleGameInfo *singleGameInfo in [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo) {
        
        BOOL isAllDanGuan = NO;
        for (SLBetSelectPlayMothedInfo *playInfo in singleGameInfo.singleBetSelectArray) {
            
            if (playInfo.selectPlayMothedArray.count > 0) {
                isAllDanGuan = YES;
                if (!playInfo.isDanGuan) {
                    isAllDanGuan = NO;
                    break;
                }
            }
        }
        if (isAllDanGuan) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)getHasAllDanGuan{
    
    //判断是否全是单关
    for (SLBetSelectSingleGameInfo *singleGameInfo in [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo) {
        
        for (SLBetSelectPlayMothedInfo *playMothedInfo in singleGameInfo.singleBetSelectArray) {
            
            if (playMothedInfo.selectPlayMothedArray.count > 0) {
                
                if (!playMothedInfo.isDanGuan) {
                    return NO;
                }
            }
        }
    }
    return YES;
}

+ (NSInteger)getNote{
    
    if ([SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray.count == 0) {
        return 0;
    }
    //获取每场比赛的选中项个数
    NSMutableArray *selectCountArray = [NSMutableArray arrayWithCapacity:0];
    for (SLBetSelectSingleGameInfo *gameInfo in [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo) {
        NSInteger count = 0;
        for (SLBetSelectPlayMothedInfo *playInfo in gameInfo.singleBetSelectArray) {
            count += playInfo.selectPlayMothedArray.count;
        }
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
    for (NSString *chuanGuanTag in [SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray) {
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

+ (NSString *)getEstimateBonus{
    
    if ([SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray.count == 0) {
        //没有奖金
        return @"";
    }
    //取每场比赛的最低赔率 和 最高赔率 并排序
    NSMutableArray *minOddsArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *maxOddsArray = [NSMutableArray arrayWithCapacity:0];
    for (SLBetSelectSingleGameInfo *singleGameInfo in [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo) {
        SLMatchBetModel *matchModel = [self getMatchInfoWithIssue:singleGameInfo.matchIssue];
        CGFloat minOdds = MAXFLOAT;
        CGFloat maxOdds = 0;
        for (SLBetSelectPlayMothedInfo *playInfo in singleGameInfo.singleBetSelectArray) {
            
            for (NSString *tag in playInfo.selectPlayMothedArray) {
            
                CGFloat odds = [matchModel getOddsWithTag:tag];
                if (odds != 0 && odds < minOdds) {
                    minOdds = odds;
                }
                if (odds != 0 && odds > maxOdds) {
                    maxOdds = odds;
                }
            }
        }
        if (minOdds > 0) {
            [minOddsArray addObject:@(minOdds)];
        }
        if (maxOdds > 0) {
            [maxOddsArray addObject:@(maxOdds)];
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
    CGFloat minBonus = 2 * [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betMultiple;//单注2元
    CGFloat maxBonus = 2 * [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betMultiple;//单注2元
    //取最大串关数 和最小串关数
    NSMutableArray *tempChuanGuanArray = [NSMutableArray arrayWithArray:[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray];
    
    [tempChuanGuanArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    for (NSInteger i = 0; i < [[tempChuanGuanArray firstObject] integerValue]; i++) {
        if (i < minOddsArray.count) {
            minBonus *= [minOddsArray[i] floatValue];
        }
    }
    for (NSInteger i = 0; i < [[tempChuanGuanArray lastObject] integerValue]; i++) {
        if (i < maxOddsArray.count) {
            maxBonus *= [maxOddsArray[i] floatValue];
        }
    }
    
    //去两位小数 去比较
    minBonus = [[NSString stringWithFormat:@"%.2f",minBonus] floatValue];
    maxBonus = [[NSString stringWithFormat:@"%.2f",maxBonus] floatValue];
    
    if (minBonus < maxBonus) {
        
        return [NSString stringWithFormat:@"%.2f~%.2f元" , minBonus, maxBonus];
    }else if (minBonus == maxBonus){
        
        return [NSString stringWithFormat:@"%.2f元" , minBonus];
    }else{
        
        return @"";
    }
}

+(NSInteger)getMultiple{
    
    return [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betMultiple;
}

+ (NSInteger)getDefaultMultiple
{
    [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betMultiple = defaultBetMultiple;
    return defaultBetMultiple;
}

+ (NSString *)getCreateOrderNumber{
    
    NSString *lotteryNumber = @"";
    
    //排序 升序
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"matchIssue" ascending:YES];
    
    NSMutableArray *tempArray = [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo;
    
    [tempArray sortUsingDescriptors:@[sortDescriptor]];
    
    for (SLBetSelectSingleGameInfo *singleGameInfo in tempArray) {
        NSString *singleGameSelectNumber = @"";
        for (SLBetSelectPlayMothedInfo *playMothedInfo in singleGameInfo.singleBetSelectArray) {
            
            
            for (NSString *number in playMothedInfo.selectPlayMothedArray) {
                
                singleGameSelectNumber = [NSString stringWithFormat:@"%@#%@", singleGameSelectNumber, number];
            }
        }
        if (singleGameSelectNumber.length > 0) {
            lotteryNumber = [NSString stringWithFormat:@"%@ %@:%@:0", lotteryNumber, singleGameInfo.matchIssue, [singleGameSelectNumber substringFromIndex:1]];
        }
    }
    if (lotteryNumber.length > 0) {
    
        return [lotteryNumber substringFromIndex:1];
    }else{
        return @"";
    }
    
}

+ (NSString *)getCreateOrderChuanGuan{
    
    NSString *chuanGuan = @"";
    
    //获取串关数组
    NSMutableArray *array = [NSMutableArray arrayWithArray:[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray];
    
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

+ (NSArray *)getChuanGuanArray{
    
    NSMutableArray *chuanGuanArray = [[NSMutableArray alloc] initWithCapacity:0];
    //判断是否全是单关
    BOOL isAllDanGuan = YES;
    BOOL hasOrtherPlay = NO;//记录是否有其他玩法  最多4串1
    for (SLBetSelectSingleGameInfo *singleGameInfo in [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo) {
        
        for (SLBetSelectPlayMothedInfo *playMothedInfo in singleGameInfo.singleBetSelectArray) {
            
            if (playMothedInfo.selectPlayMothedArray.count > 0) {
                
                if (!playMothedInfo.isDanGuan) {
                    isAllDanGuan = NO;
                }
                
                if (!([playMothedInfo.playMothed isEqualToString:SPF] || [playMothedInfo.playMothed isEqualToString:RQSPF])) {
                    hasOrtherPlay = YES;
                }
            }
        }
    }
    if (isAllDanGuan) {
        
        SLChuanGuanModel *chuanGuan = [[SLChuanGuanModel alloc] init];
        chuanGuan.chuanGuanTag = @"1";
        chuanGuan.chuanGuanTitle = self.chuanGuanDic[chuanGuan.chuanGuanTag];
        chuanGuan.isSelect = [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray containsObject:chuanGuan.chuanGuanTag];
        [chuanGuanArray addObject:chuanGuan];
    }
    //添加其他串关
    for (NSInteger i = 2; i <= [SLBetInfoManager getSelectMatchCount]; i++) {
        
        if (hasOrtherPlay) {
            if (i <= 4) {
                SLChuanGuanModel *chuanGuan = [[SLChuanGuanModel alloc] init];
                chuanGuan.chuanGuanTag = [NSString stringWithFormat:@"%zi", i];
                chuanGuan.chuanGuanTitle = self.chuanGuanDic[chuanGuan.chuanGuanTag];
                chuanGuan.isSelect = [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray containsObject:chuanGuan.chuanGuanTag];
                [chuanGuanArray addObject:chuanGuan];
            }
        }else{
            if (i <= 8) {
                SLChuanGuanModel *chuanGuan = [[SLChuanGuanModel alloc] init];
                chuanGuan.chuanGuanTag = [NSString stringWithFormat:@"%zi", i];
                chuanGuan.chuanGuanTitle = self.chuanGuanDic[chuanGuan.chuanGuanTag];
                chuanGuan.isSelect = [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray containsObject:chuanGuan.chuanGuanTag];
                [chuanGuanArray addObject:chuanGuan];
                
            }
        }
    }
    return chuanGuanArray;
}

+ (NSInteger)getCurrentMaxChuanGuanCount{
    
    BOOL hasOrtherPlay = NO;//记录是否有其他玩法  最多4串1
    for (SLBetSelectSingleGameInfo *singleGameInfo in [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo) {
        
        for (SLBetSelectPlayMothedInfo *playMothedInfo in singleGameInfo.singleBetSelectArray) {
            
            if (playMothedInfo.selectPlayMothedArray.count > 0) {
    
                if (!([playMothedInfo.playMothed isEqualToString:SPF] || [playMothedInfo.playMothed isEqualToString:RQSPF])) {
                    hasOrtherPlay = YES;
                }
            }
        }
    }
    if (hasOrtherPlay) {
        return ([SLBetInfoManager getSelectMatchCount] > 4) ? 4 : [SLBetInfoManager getSelectMatchCount];
    }else{
        return [SLBetInfoManager getSelectMatchCount];
    }
}

/**
 删除已经选择的但是错误的串关
 */
+ (void)deleteExistErrorChuanGuan{
    
    //判断是否有单关
    BOOL isAllDanGuan = YES;
    BOOL hasOrtherPlay = NO;//记录是否有其他玩法  最多4串1
    for (SLBetSelectSingleGameInfo *singleGameInfo in [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo) {
        
        for (SLBetSelectPlayMothedInfo *playMothedInfo in singleGameInfo.singleBetSelectArray) {
            
            if (playMothedInfo.selectPlayMothedArray.count > 0) {
                
                if (!playMothedInfo.isDanGuan) {
                    isAllDanGuan = NO;
                }
                
                if (!([playMothedInfo.playMothed isEqualToString:SPF] || [playMothedInfo.playMothed isEqualToString:RQSPF])) {
                    hasOrtherPlay = YES;
                }
            }
        }
    }
    
    if (!isAllDanGuan) {
        //不应存在单关
        if ([[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray containsObject:@"1"]) {
            [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray removeObject:@"1"];
        }
    }
    

    NSMutableArray *betchuanArr = [NSMutableArray array];
    
    if ([[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray containsObject:@"1"]) {
        
        [betchuanArr insertObject:@"1" atIndex:0];
    }
    
    //当前正确比赛个数
    NSInteger count = [SLBetInfoManager getCurrentMaxChuanGuanCount];
    for (NSInteger i = 2; i <= count; i++) {
        if ([[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray containsObject:[NSString stringWithFormat:@"%zi", i]]) {
            [betchuanArr addObject:[NSString stringWithFormat:@"%zi",i]];
        }
    }
    [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray removeAllObjects];
    if (betchuanArr.count) {
        [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray addObjectsFromArray:betchuanArr];
    }
}

+ (BOOL)judgeCurrentSelectIsValid:(NSString *)matchIssue{
    
    NSInteger count = 0;
    //如果选中的比赛小于8场，则返回yes
    if ([SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo.count < 8) {
        return YES;
    }
    //如果大于等于8场  则判断当前有效选中的场次为几场 并判断是否是重复场次
    for (SLBetSelectSingleGameInfo *singleGameInfo in [SLBetInfoCache shareBetInfoCache].allSelectBetItem.betSelectInfo) {
        BOOL isHasMatch = NO;//该比赛是否含有选中项
        if ([matchIssue isEqualToString:singleGameInfo.matchIssue]) {
            //如果是相同的比赛 则count 不++  最后判断 count是否小于等于7场即可
            continue;
        }
        for (SLBetSelectPlayMothedInfo *playInfo in singleGameInfo.singleBetSelectArray) {
            
            if (playInfo.selectPlayMothedArray.count > 0) {
                isHasMatch = (playInfo.selectPlayMothedArray.count > 0);//含有有效的选项
                break;
            }
        }
        if (isHasMatch) {
            count ++;
        }
    }
    return (count < 8);
}


//排列组合 递归
+ (void)permutationAndCombination:(NSMutableArray<NSMutableArray *> *)result
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

+ (NSDictionary *)chuanGuanDic{
    
    return @{@"1" : @"单关",
             @"2" : @"2串1",
             @"3" : @"3串1",
             @"4" : @"4串1",
             @"5" : @"5串1",
             @"6" : @"6串1",
             @"7" : @"7串1",
             @"8" : @"8串1"};
}

@end
