//
//  CLHomeAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLHomeAPI.h"
#import "CLHomeBannerModel.h"
#import "CLHomeAPIModel.h"
#import "CLRequestTimeLimitService.h"
#import "CLAppContext.h"
@interface CLHomeAPI () <CLBaseConfigRequest>

@property (nonatomic, strong) CLHomeAPIModel* apiResult;

@property (nonatomic, strong) NSMutableArray* homeData;

@property (nonatomic, strong) CLRequestTimeLimitService *timeLimit;//时间限制

@end

@implementation CLHomeAPI

- (void)start{
    
    if ([self.timeLimit requestTimeLimit]) {
        [super start];
    }else{
        if ([self.delegate respondsToSelector:@selector(cancelRequest:)]) {
            [self.delegate cancelRequest:self];
        }
        return;
    }
}
- (NSDictionary *)requestBaseParams{
    
    if ([CLAppContext channelId]) {
        return @{@"channel":[CLAppContext channelId]};
    }else{
        return @{};
    }
}
//index/
- (NSString *)methodName {
    
    return @"home";
}

- (NSString *)requestBaseUrlSuffix {
    
    return @"/index/";
}

- (void) dealingWithHomeData:(NSDictionary*)dict{
    
    CLHomeAPIModel* apiResult = [CLHomeAPIModel mj_objectWithKeyValues:dict];
    if (self.apiResult) self.apiResult = nil;
    self.apiResult = apiResult;
    
}

- (NSArray*) bannerData{
    return self.apiResult.banners;
}

- (NSArray*) reports {
    return self.apiResult.reports;
}

- (NSMutableArray *)homeData {
    
    if (!_homeData) {
        _homeData = [NSMutableArray new];
    }
    return _homeData;
}
#pragma mark ------------ getter Mothed ------------
- (CLRequestTimeLimitService *)timeLimit{
    
    if (!_timeLimit) {
        _timeLimit = [[CLRequestTimeLimitService alloc] init];
        _timeLimit.maxRequestTimeLimit = 5.f;
    }
    return _timeLimit;
}
@end
