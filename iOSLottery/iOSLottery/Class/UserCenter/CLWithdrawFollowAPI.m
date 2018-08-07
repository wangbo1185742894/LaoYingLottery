//
//  CLWithdrawFollowAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/13.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLWithdrawFollowAPI.h"
#import "CLAPI.h"
#import "CLAppContext.h"
#import "CLWithdrawFollowModuleModel.h"

@interface CLWithdrawFollowAPI () <CLBaseConfigRequest>

@property (nonatomic, strong) NSString* lastDay;

@property (nonatomic, strong) NSMutableArray* followArray;

@property (nonatomic) BOOL isLoadMore;

@end

@implementation CLWithdrawFollowAPI

- (NSString *)methodName {
    
    return @"withdraw_follow_api";
}

- (NSDictionary *)requestBaseParams {
    
    if (self.isLoadMore && self.lastDay.length > 0) {
        return @{@"cmd":CMD_WithdrawFollowAPI,
                 @"token":[[CLAppContext context] token],
                 @"last_day":self.lastDay};
    }
    return @{@"cmd":CMD_WithdrawFollowAPI,
             @"token":[[CLAppContext context] token]};
}

- (void)refresh {
    
    self.isLoadMore = NO;
}

- (void)nextPage {
    
    self.isLoadMore = YES;
}

- (void)setIsLoadMore:(BOOL)isLoadMore {
    
    _isLoadMore = isLoadMore;
    [self start];
}

- (void)dealingWithFollowDict:(NSDictionary*)dict {
    
    id objc = dict[@"get_last_day"];
    if ([objc isKindOfClass:NSString.class] && [objc length] > 0) {
        self.lastDay = objc;
    } else {
        self.lastDay = nil;
    }
    NSArray* result_list = dict[@"result_list"];
    NSArray* list = [CLWithdrawFollowModuleModel mj_objectArrayWithKeyValuesArray:result_list];
    
    if (!self.isLoadMore) {
        [self.followArray removeAllObjects];
    }
    
    [self.followArray addObjectsFromArray:list];
    
}

- (BOOL)canLoadMore {
    
    return (self.lastDay != nil);
}

- (NSArray*)pullFollowData {
    
    return self.followArray;
}

- (NSMutableArray *)followArray {
    
    if (!_followArray) {
        _followArray = [NSMutableArray new];
    }
    return _followArray;
}

@end
