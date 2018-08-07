//
//  CLUserCashJournalModel.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/25.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLUserCashJournalModel.h"
#import "CLUserCashJournalDeailModel.h"

@implementation CLUserCashJournalModel

- (void)setFlows:(NSArray *)flows
{
    _flows = [CLUserCashJournalDeailModel mj_objectArrayWithKeyValuesArray:flows];
}

@end
