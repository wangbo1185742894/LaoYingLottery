//
//  CLRedEnveConsumeAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/29.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLRedEnveConsumeAPI.h"
#import "CLAPI.h"
#import "CLRedEnveConsumeModel.h"
#import "CLAppContext.h"

@interface CLRedEnveConsumeAPI () <CLBaseConfigRequest>

@property (nonatomic, strong) NSString* last_fid;

@property (nonatomic) BOOL loadMore;

@property (nonatomic, strong) NSMutableArray* consumeData;

@end

@implementation CLRedEnveConsumeAPI

- (NSString *)methodName {
    
    return @"get_red_info_detail";
}

- (NSDictionary *)requestBaseParams {
    
    if (self.loadMore) {
        return @{@"cmd":CMD_RedEnvelopConsumeAPI,
                 @"user_fid":self.user_fid,
                 @"token":[[CLAppContext context] token],
                 @"last_fid":self.last_fid,
                 @"red_client":@"1"};
    } else {
        return @{@"cmd":CMD_RedEnvelopConsumeAPI,
                 @"user_fid":self.user_fid,
                 @"token":[[CLAppContext context] token],
                 @"red_client":@"1",
                 @"client_type":[CLAppContext clientType]};
    }
    
}

- (void) refresh {
    
    self.loadMore = NO;
    [self start];
}

- (void) nextPage {
    
    self.loadMore = YES;
    [self start];
}

- (void) configureConsumeFollowDataWithArr:(NSArray*)arr {
    
    if (!self.loadMore) {
        [self.consumeData removeAllObjects];
    }
    
    [self.consumeData addObjectsFromArray:[CLRedEnveConsumeModel mj_objectArrayWithKeyValuesArray:arr]];
    
    if (arr.count > 0) {
        self.last_fid = ((CLRedEnveConsumeModel*)[self.consumeData lastObject]).fid;
    }
    
    _canLoadMore = (arr.count > 0);
}

- (NSArray*) pullData {
    
    return self.consumeData;
}

- (void)setLoadMore:(BOOL)loadMore {
    
    _loadMore = loadMore;
    if (!_loadMore) {
        self.last_fid = nil;
    }
}

- (NSMutableArray *)consumeData {
    
    if (!_consumeData) {
        _consumeData = [NSMutableArray new];
    }
    return _consumeData;
}

@end
