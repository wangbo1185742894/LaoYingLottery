//
//  CLWithdrawListAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/13.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLWithdrawListAPI.h"
#import "CLAppContext.h"
#import "CLAPI.h"

#import "CLWithdrawInfoModel.h"

@interface CLWithdrawListAPI () <CLBaseConfigRequest>

@property (nonatomic, strong) CLWithdrawInfoModel* withdrawInfo;

@property (nonatomic, strong) NSMutableArray* withdrawArray;

@end

@implementation CLWithdrawListAPI

- (NSString *)methodName {
    
    return @"CMD_ShowListWithdrawAPI";
}

- (NSDictionary *)requestBaseParams {
    
    return @{@"cmd":CMD_ShowListWithdrawAPI,@"account_type_id":@"1",@"token":[[CLAppContext context] token]};
}


- (void) dealingWithDrawDataFromDict:(NSDictionary*) dict {
    
    self.withdrawInfo = [CLWithdrawInfoModel mj_objectWithKeyValues:dict];
}

- (id) accountData {
    
    if (self.withdrawInfo.account_info) {
        return self.withdrawInfo.account_info;
    } else {
        return nil;
    }
}
- (id) bankCardDataAtIndex:(NSInteger *)index {
    if (!self.withdrawInfo) {
        *index = -1;
        return nil;
    } else if (((CLWithdrawList*)[self.withdrawInfo.withdraw_list firstObject]).channel_infos.count == 0)  {
        *index = -1;
        return nil;
    } else if (((CLWithdrawList*)[self.withdrawInfo.withdraw_list firstObject]).channel_infos.count >= *index + 1) {
        *index = MAX(*index, 0);
        return ((CLWithdrawList*)[self.withdrawInfo.withdraw_list firstObject]).channel_infos[*index];
    } else {
        *index = -1;
        return nil;
    }
}

- (NSArray*) pullWithdrawData  {
    
    if (self.withdrawInfo) return @[];
    
    
    if (self.withdrawArray.count == 0 && self.withdrawInfo) {
        
        if (((CLWithdrawList*)[self.withdrawInfo.withdraw_list firstObject]).channel_infos.count == 0) {
            CLWithdrawList* list = [[CLWithdrawList alloc] init];
            list.isNull = YES;
        } else {
             [self.withdrawArray addObject:[((CLWithdrawList*)[self.withdrawInfo.withdraw_list firstObject]).channel_infos objectAtIndex:0]];
        }
        [self.withdrawArray addObject:self.withdrawInfo.account_info];
    }
    return self.withdrawArray;
}

- (void) updateChannelCardIndex:(NSInteger)index {
    
    NSInteger idx = index;
    if (idx < 0 || idx >= [((CLWithdrawList*)[self.withdrawInfo.withdraw_list firstObject]).channel_infos count]) {
        idx = 0;
    }
    [self.withdrawArray replaceObjectAtIndex:0 withObject:[((CLWithdrawList*)[self.withdrawInfo.withdraw_list firstObject]).channel_infos objectAtIndex:idx]];
}

- (void) updateChannelInfos:(NSArray*)infos {
    
    if (infos.count > 0) {
        NSMutableArray* arr = (NSMutableArray*)((CLWithdrawList*)[self.withdrawInfo.withdraw_list firstObject]).channel_infos;
        if (arr && arr.count > 0) {
            [arr removeAllObjects];
        }
        [arr addObjectsFromArray:infos];
    }
}

- (NSArray*) pullChannelInfos {
    
    return (NSMutableArray*)((CLWithdrawList*)[self.withdrawInfo.withdraw_list firstObject]).channel_infos;
}

- (NSString*) getChannelType {
    NSInteger type = ((CLWithdrawList*)[self.withdrawInfo.withdraw_list firstObject]).channel_type;
    return [NSString stringWithFormat:@"%zi",type];
}

- (NSMutableArray *)withdrawArray {
    
    if (!_withdrawArray) {
        _withdrawArray = [NSMutableArray new];
    }
    return _withdrawArray;
}

@end
