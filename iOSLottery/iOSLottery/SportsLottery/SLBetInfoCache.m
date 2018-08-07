//
//  SLBetInfoCache.m
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/16.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBetInfoCache.h"

@implementation SLBetInfoCache

+ (instancetype)shareBetInfoCache{
    
    static dispatch_once_t once ;
    static SLBetInfoCache *sele = nil;
    dispatch_once(&once, ^{
        
        sele = [[SLBetInfoCache alloc] init];
        sele.maxTimes = 9999;
    });
    return sele;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.allSelectBetItem = [[SLBetSelectInfo alloc] init];
    }
    return self;
}

- (NSMutableArray<SLMatchBetGroupModel *> *)allMatchsArray{
    
    if (!_allMatchsArray) {
        _allMatchsArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _allMatchsArray;
}

- (NSMutableArray *)allFilterMatchArray{
    
    if (!_allFilterMatchArray) {
        _allFilterMatchArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _allFilterMatchArray;
}

- (NSMutableArray<SLMatchSelectModel *> *)leagueMatchesArray{
    
    if (!_leagueMatchesArray) {
        _leagueMatchesArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _leagueMatchesArray;
}

@end
