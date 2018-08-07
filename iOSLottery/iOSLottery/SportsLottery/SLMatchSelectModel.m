//
//  SLMatchSelectModel.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLMatchSelectModel.h"

@implementation SLMatchSelectModel

- (id)mutableCopyWithZone:(NSZone *)zone{
    
    SLMatchSelectModel *model = [[SLMatchSelectModel allocWithZone:zone] init];
    model.seasionId = self.seasionId;
    model.titile = self.titile;
    model.isSelect = self.isSelect;
    model.isFiveLeague = self.isFiveLeague;
    model.leagueTotal = self.leagueTotal;
    return model;
}

- (id)copyWithZone:(NSZone *)zone{
    
    SLMatchSelectModel *model = [[SLMatchSelectModel allocWithZone:zone] init];
    model.seasionId = self.seasionId;
    model.titile = self.titile;
    model.isSelect = self.isSelect;
    model.isFiveLeague = self.isFiveLeague;
    model.leagueTotal = self.leagueTotal;
    return model;
}

@end
