//
//  CLSaveUserPassWordTool.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/20.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLSaveUserPassWordTool.h"
#import "KeychainTool.h"
@implementation CLSaveUserPassWordTool

static NSString * const KEY_KEYCHAIN = @"com.iOSLottery.app.userInfo";
static NSString * const KEY_USERID = @"com.iOSLottery.app.userid";
static NSString * const KEY_PASSWORD = @"com.iOSLottery.app.password";

+(void)saveUserId:(NSString *)userId PassWord:(NSString *)password
{
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    [usernamepasswordKVPairs setObject:userId forKey:KEY_USERID];
    [usernamepasswordKVPairs setObject:password forKey:KEY_PASSWORD];
    [KeychainTool save:KEY_KEYCHAIN data:usernamepasswordKVPairs];
}

+(id)readUserId
{
    NSMutableDictionary *usernamepasswordKVPair = (NSMutableDictionary *)[KeychainTool load:KEY_KEYCHAIN];
    return [usernamepasswordKVPair objectForKey:KEY_USERID];
}

+(id)readPassWord
{
    NSMutableDictionary *usernamepasswordKVPair = (NSMutableDictionary *)[KeychainTool load:KEY_KEYCHAIN];
    return [usernamepasswordKVPair objectForKey:KEY_PASSWORD];
}


static NSString * const KEY_TOKEN_KEYCHAIN = @"com.iOSLottery.app.token";
static NSString * const KEY_TOKEN = @"com.iOSLottery.app.token";

+ (void)saveToken:(NSString *)token{
    
    NSMutableDictionary *tokenDic = [NSMutableDictionary dictionary];
    [tokenDic setObject:token forKey:KEY_TOKEN];
    [KeychainTool save:KEY_TOKEN_KEYCHAIN data:tokenDic];
}

+(id)readToken{
    
    NSMutableDictionary *tokenDic = (NSMutableDictionary *)[KeychainTool load:KEY_TOKEN_KEYCHAIN];
    return [tokenDic objectForKey:KEY_TOKEN];
}

static NSString * const KEY_DEVICEID_KEYCHAIN = @"com.iOSLottery.app.deviceid";
static NSString * const KEY_DEVICEID = @"com.iOSLottery.app.deviceid";

+ (void)saveDeviceId:(NSString *)deviceId{
    
    NSMutableDictionary *deviceIdDic = [NSMutableDictionary dictionary];
    [deviceIdDic setObject:deviceId forKey:KEY_DEVICEID];
    [KeychainTool save:KEY_DEVICEID_KEYCHAIN data:deviceIdDic];
}
+ (NSString *)readDeviceId{
    
    NSMutableDictionary *deviceIdDic = (NSMutableDictionary *)[KeychainTool load:KEY_DEVICEID_KEYCHAIN];
    return [deviceIdDic objectForKey:KEY_DEVICEID];
}
@end
