//
//  CLTabbarTempCheckAPI.m
//  iOSLottery
//
//  Created by 洪利 on 2018/6/1.
//  Copyright © 2018年 caiqr. All rights reserved.
//

#import "CLTabbarTempCheckAPI.h"
#import "CLRequestTimeLimitService.h"
#import "CLAppContext.h"
#import "CQDefinition.h"
#import "CQLaunchConf.h"
@interface CLTabbarTempCheckAPI ()<CLBaseConfigRequest>

@property (nonatomic, strong) CLRequestTimeLimitService *timeLimit;//时间限制

@end


@implementation CLTabbarTempCheckAPI



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
    
    NSString *token = [[CLAppContext context] token];
    if (token && token.length > 0) {
        return @{@"token":token,@"clientType":CQ_Client_Type,@"version":APP_VERSION};
    }else{
        return @{@"clientType":CQ_Client_Type,@"version":APP_VERSION};
    }
}
//index/
- (NSString *)methodName {
    
    return @"/index/auditing/check";
}

- (NSString *)requestBaseUrlSuffix {
    
    return @"/index/auditing/check";
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
