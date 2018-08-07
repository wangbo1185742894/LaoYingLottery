//
//  CLAppContext.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLAppContext.h"
#import "CLNetworkReachabilityManager.h"
#import "CLUserBaseInfo.h"
#import "CLSaveUserPassWordTool.h"
#import <sys/utsname.h>
#import "CLCacheManager.h"
#import "CLFirstStartModel.h"
@implementation CLAppContext

+ (CLAppContext *)context
{
    static CLAppContext *sharedAppContextInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAppContextInstance = [[self alloc] init];
    });
    return sharedAppContextInstance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userMessage = [[CLUserBaseInfo alloc] init];
    }
    return self;
}
- (NSString*) url_Scheme {
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"urlSchemes"];
}
- (NSString *)getGameNameWithGameEn:(NSString *)gameEn{
    
    return self.firstStartInfo.allGameNameDic[gameEn];
}
- (NSString *)getPicturePrefix{
    
    return self.firstStartInfo.picturePrefix;
}
#pragma mark - 运行环境

- (BOOL)isReachable {

    return ([CLNetworkReachabilityManager currentNetworkState] != CLNetworkReachabilityStatusNotReachable);
}


- (void)setToken:(NSString *)token{
    
    [CLSaveUserPassWordTool saveToken:token];
}

- (NSString*)token {
    
    
    return self.userMessage.login_token.token;
}

- (NSString *)device_id_uuid{
    
    //先取， 若没有则现存再取
    NSString *deviceId = [CLSaveUserPassWordTool readDeviceId];
    if (deviceId && deviceId.length > 0) {
        return deviceId;
    }else{
        NSString *newDeviceId = [[NSUUID UUID] UUIDString];
        [CLSaveUserPassWordTool saveDeviceId:newDeviceId];
        return newDeviceId;
    }
}
+ (NSString *)channelId{
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"channelId"];
}
+ (NSString *)clientType{
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"client_type"];
}
+ (BOOL)suppleShare{
    
    return ([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"suppleShare"] integerValue] == 1);
}
+ (NSString *)payVersion{
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"payVersion"];
}
+ (NSString *)vNum
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"vNum"];
}

- (NSString *)deviceModel {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPhone10,1"])   return @"国行(A1863)、日行(A1906)iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])   return @"美版(Global/A1905)iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])   return @"国行(A1864)、日行(A1898)iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])   return @"美版(Global/A1897)iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])   return @"国行(A1865)、日行(A1902)iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])   return @"美版(Global/A1901)iPhone X";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPod Touch 6G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
    
    
}

- (NSMutableArray*)cacheFileListArrays
{
    if (!_cacheFileListArrays) {
        _cacheFileListArrays = [NSMutableArray new];
    }
    if (_cacheFileListArrays.count > 0) {
        return _cacheFileListArrays;
    }
    [_cacheFileListArrays addObjectsFromArray:[CLCacheManager getCacheFileList]];
    
    return _cacheFileListArrays;
}
@end
