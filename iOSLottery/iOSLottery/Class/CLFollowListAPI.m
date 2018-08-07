//
//  CLFollowListAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFollowListAPI.h"
#import "CLAPI.h"
#import "CLAppContext.h"
#import "CLFollowListModel.h"

@interface CLFollowListAPI () <CLBaseConfigRequest>

@property (nonatomic, strong) NSString *followTime;
@property (nonatomic, assign) BOOL ifNext;
@property (nonatomic, strong) NSMutableArray* followList;

@property (nonatomic, readwrite) BOOL isLoadMore;
@end

@implementation CLFollowListAPI

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.followTime = @"";
        self.followList = [NSMutableArray new];
        self.ifNext = YES;
    }
    return self;
}

- (NSString *)methodName {
    
    return @"followList";
}

- (NSString *)requestBaseUrlSuffix {
    
    return followListAPI;
}

-(NSDictionary *)requestBaseParams {
    
    return @{@"followTime":self.followTime,@"channel" : [CLAppContext channelId]};
}

- (void)refresh {
    
    self.isLoadMore = NO;
    [self start];
}

- (void)nextPage {
    
    self.isLoadMore = YES;
    [self start];
}

- (void)setIsLoadMore:(BOOL)isLoadMore {
    
    _isLoadMore = isLoadMore;
    if (!_isLoadMore) {
        //如果是刷新
        self.followTime = @"";
    }
}

/** 处理API返回数据 */
- (BOOL)arrangeListWithAPIData:(NSDictionary*)dict error:(NSError**)error
{
    NSArray *arr = nil;
    if ([dict isKindOfClass:[NSDictionary class]]) {
        arr = dict[@"followVoList"];
        self.followTime = dict[@"followTime"];
        self.ifNext = ([dict[@"ifNext"] integerValue] == 1);
        self.skipUrl = dict[@"downloadUrl"];
        self.bulletTips = dict[@"bulletTips"];
        self.ifSkipDownload = [dict[@"ifSkipDownload"] integerValue];
    }else{
        arr = @[];
    }
    //不是加载更多则 清空数据
    if (!self.isLoadMore) {
        [self.followList removeAllObjects];
    }
    if (arr.count > 0) {
        [self.followList addObjectsFromArray:[CLFollowListModel mj_objectArrayWithKeyValuesArray:arr]];
    }
    return YES;
}

- (NSArray*)pullFollowList {
    
    return self.followList;
}

- (BOOL)canLoadMore{
    
    return self.ifNext;
}
@end
