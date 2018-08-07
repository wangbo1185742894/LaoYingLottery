//
//  CLCheckTokenManager.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/27.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLCheckTokenManager.h"
#import "CLCheckTokenApi.h"
#import "CLLoginRegisterAdapter.h"
#import "CLAppContext.h"
@interface CLCheckTokenManager ()<CLRequestCallBackDelegate>

@property (nonatomic, strong) CLCheckTokenApi *checkTokenApi;

@end
@implementation CLCheckTokenManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.checkTokenApi = [[CLCheckTokenApi alloc] init];
        self.checkTokenApi.delegate = self;
    }
    return self;
}

- (void)checkUserToken{
    
    NSString *token = [[CLAppContext context] token];
    if (token && token.length > 0) {
        [self.checkTokenApi start];
    }
}
- (void)requestFinished:(CLBaseRequest *)request{
    
    if (request.urlResponse.success && request.urlResponse.resp) {
        [CLLoginRegisterAdapter loginSuccessWithMessage:[request.urlResponse.resp firstObject]];
    }
    self.checkTokenApi = nil;
    self.checkTokenApi.delegate = nil;
    !self.destroyCheckTokenManager ? : self.destroyCheckTokenManager();
}
- (void)requestFailed:(CLBaseRequest *)request{
    
    self.checkTokenApi = nil;
    self.checkTokenApi.delegate = nil;
    !self.destroyCheckTokenManager ? : self.destroyCheckTokenManager();
}
@end
