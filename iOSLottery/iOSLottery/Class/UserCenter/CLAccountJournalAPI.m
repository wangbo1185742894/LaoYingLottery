//
//  CLAccountJournalAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/25.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLAccountJournalAPI.h"
#import "CLAPI.h"
#import "CLPersonalJournalModel.h"
#import "CLAppContext.h"

@interface CLAccountJournalAPI () <CLBaseConfigRequest>

@property (nonatomic) BOOL isLoadMore;

@property (nonatomic, strong) CLPersonalJournalModel* journalData;

@end

@implementation CLAccountJournalAPI

- (NSString *)methodName {
    
    return @"CMD_AccountCashJournalAPI";
}

- (NSDictionary *)requestBaseParams {
    
    if (_last_day && _last_day.length > 0) {
        return @{@"cmd":CMD_AccountCashJournalAPI,
                 @"token":[[CLAppContext context] token],
                 @"account_type_id":@"1",
                 @"last_day":_last_day};
    } else {
        return @{@"cmd":CMD_AccountCashJournalAPI,
                 @"token":[[CLAppContext context] token],
                 @"account_type_id":@"1"};
    }
    
}


- (void)refresh {
    
    _last_day = nil;
    self.isLoadMore = NO;
    [self start];
}

- (void)nextPage {
    
    if (_last_day && _last_day.length > 0) {
        self.isLoadMore = YES;
        [self start];
    }
    
}

- (BOOL)isCanLoadMore{
    
    return (_last_day && _last_day.length > 0);
}

- (void) updateJournalListArrayWith:(NSDictionary*)objc {
    
    CLPersonalJournalModel* model = [CLPersonalJournalModel mj_objectWithKeyValues:objc];
    
    if (!self.isLoadMore) {
        if (self.journalData) {
            self.journalData = nil;
        }
        self.journalData = model;
        self.last_day = model.cash_log.get_last_day;
    } else {
        
        self.journalData.account_info = model.account_info;
        [self.journalData.cash_log.result_list addObjectsFromArray:model.cash_log.result_list];
        self.last_day = model.cash_log.get_last_day;
    }
    
}

- (CLAccountInfoModel*) accountInfo {
    return self.journalData.account_info;
}

- (NSMutableArray*) cashLog {
    return self.journalData.cash_log.result_list;
}

@end
