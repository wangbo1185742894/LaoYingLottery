//
//  CLPersonalMsgHandler.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLPersonalMsgHandler : NSObject

+ (CLPersonalMsgHandler *) sharedPersonal;

- (void) updatePersonalMesssageFrom:(NSDictionary*)dict;

+ (NSArray *)personalMessage;

+ (NSString *)personalHeadImgStr;

+ (NSString *)personalNickName;

+ (NSString *)personalMobile;

/* 真实姓名 */
+ (NSString *)personalRealName;

/* 身份证号码 */
+ (NSString *)personalIdCardNo;

+ (BOOL) identityAuthentication;

+ (void) updateIdentityAuthenForRealName:(NSString*)realName idCard:(NSString*)idCard;

@end
