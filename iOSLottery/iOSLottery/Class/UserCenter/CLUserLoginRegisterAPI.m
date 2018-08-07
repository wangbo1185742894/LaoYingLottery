//
//  CLUserLoginAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/6.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLUserLoginRegisterAPI.h"
#import "CLAPI.h"
#import "NSString+Coding.h"
#import "CLAppContext.h"
@interface CLUserLoginRegisterAPI () <CLBaseConfigRequest>

@end

@implementation CLUserLoginRegisterAPI

- (NSString *)methodName {
    
    return @"CLUserLoginAPI";
}

- (NSDictionary *)requestBaseParams {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:CMD_LoginOrRegisterAPI forKey:@"cmd"];
    [params setObject:self.mobile forKey:@"mobile"];
    [params setObject:self.verify_code forKey:@"verify_code"];
    [params setObject:[CLAppContext clientType] forKey:@"client_type"];
    [params setObject:[CLAppContext channelId] forKey:@"channel"];
    [params setObject:@"240" forKey:@"login_version"];
    
    if (self.loginPassword && self.loginPassword.length > 0) {
        [params setObject:[self.loginPassword md5] forKey:@"password"];
        [params setObject:[self.loginPassword md5] forKey:@"re_password"];
    }
    
    if (self.thirdLoginInfo && self.thirdLoginInfo.count > 0) {
        [params addEntriesFromDictionary:self.thirdLoginInfo];
    }
    //设备信息
    if ([[CLAppContext context] device_id_uuid] && [[CLAppContext context] device_id_uuid].length > 0) {
        [params setObject:[[CLAppContext context] device_id_uuid] forKey:@"device_id"];
    }
    if ([CLAppContext context].deviceModel && [CLAppContext context].deviceModel.length > 0) {
        
        [params setObject:[CLAppContext context].deviceModel forKey:@"device_name"];
    }
    if ([CLAppContext context].deviceToken && [CLAppContext context].deviceToken.length > 0) {
        [params setObject:[CLAppContext context].deviceToken forKey:@"device_token"];
    }
    return params;
}

@end
