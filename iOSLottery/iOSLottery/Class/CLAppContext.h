//
//  CLAppContext.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

/** (单例) 用户信息 推送信息 app信息 运行环境  设备信息 */

#import <Foundation/Foundation.h>

@class CLUserBaseInfo;
@class CLFirstStartModel;
@interface CLAppContext : NSObject



/********************************************************/
/*                       运行环境                        */
/********************************************************/

/**
 *  provide current network enable state
 *  @return Boolen (enable/unable)
 */
- (BOOL)isReachable;

@property (nonatomic) BOOL appLoginState;

@property (nonatomic, strong) NSMutableArray* cacheFileListArrays;//本地缓存信息的文件名

/********************************************************/
/*                       app信息                        */
/********************************************************/

@property (nonatomic, strong) CLFirstStartModel *firstStartInfo;//启动接口数据
- (NSString *)getPicturePrefix;
- (NSString *)getGameNameWithGameEn:(NSString *)gameEn;
- (NSString*) url_Scheme;
+ (NSString *)channelId;
+ (NSString *)clientType;
+ (BOOL)suppleShare;
+ (NSString *)payVersion;
+ (NSString *)vNum;
/********************************************************/
/*                       设备信息                        */
/********************************************************/
@property (nonatomic, strong) NSString *deviceToken;//用于推送的token

@property (nonatomic, strong) NSString *device_id_uuid;//设备id， 即 uuid

@property (nonatomic, strong) NSString* deviceModel;

/********************************************************/
/*                       用户信息                        */
/********************************************************/

@property (nonatomic, strong) CLUserBaseInfo* userMessage;

- (void)setToken:(NSString *)token;

- (NSString*) token;

+ (CLAppContext *)context;


@end
