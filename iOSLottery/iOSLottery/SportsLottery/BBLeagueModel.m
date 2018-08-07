//
//  BBLeagueModel.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBLeagueModel.h"

@implementation BBLeagueModel

- (id)mutableCopyWithZone:(NSZone *)zone{
    
    BBLeagueModel *model = [[BBLeagueModel allocWithZone:zone] init];
    model.seasionId = self.seasionId;
    model.titile = self.titile;
    model.isSelect = self.isSelect;
    model.leagueTotal = self.leagueTotal;
    return model;
}

- (id)copyWithZone:(NSZone *)zone{
    
    BBLeagueModel *model = [[BBLeagueModel allocWithZone:zone] init];
    model.seasionId = self.seasionId;
    model.titile = self.titile;
    model.isSelect = self.isSelect;
    model.leagueTotal = self.leagueTotal;
    return model;
}

@end
