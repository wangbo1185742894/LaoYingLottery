//
//  CLSaveUserPassWordTool.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/20.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLSaveUserPassWordTool : NSObject


/**
 保存用户名和密码

 @param userId   用户名
 @param password 密码
 */
+(void)saveUserId:(NSString *)userId PassWord:(NSString *)password;

/**
 读取用户名

 @return 返回用户名
 */
+(id)readUserId;

/**
 *    @brief    读取密码
 *
 *    @return    密码内容
 */
+(id)readPassWord;


/**
 保存用户登录token
 
 @param token 用户token
 */
+ (void)saveToken:(NSString *)token;

/**
 读取用户token

 @return 返回用户token
 */
+(id)readToken;


/**
 保存device id

 @param deviceId 需要保存的deviceId
 */
+ (void)saveDeviceId:(NSString *)deviceId;

/**
 读取deviceId

 @return 返回deviceId
 */
+ (NSString *)readDeviceId;


@end
