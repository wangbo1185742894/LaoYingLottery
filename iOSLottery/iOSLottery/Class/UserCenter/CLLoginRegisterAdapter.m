//
//  CLLoginRegisterAdapter.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/7.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLoginRegisterAdapter.h"
#import "CLAppContext.h"
#import "CLUserBaseInfo.h"
#import "CLSaveUserPassWordTool.h"

@implementation CLLoginRegisterAdapter

+ (void) loginSuccessWithMessage:(NSDictionary*)loginMsg {
    
    [CLAppContext context].userMessage.account_info = [AccountInfo attribute:loginMsg[@"account_info"]];
    [CLAppContext context].userMessage.login_token = [LoginToken mj_objectWithKeyValues:loginMsg[@"login_token"]];
    [CLAppContext context].userMessage.user_info = [UserInfo mj_objectWithKeyValues:loginMsg[@"user_info"]];
    [CLAppContext context].appLoginState = YES;
}

+ (void) logout {
    [CLAppContext context].appLoginState = NO;
    //清除 缓存token
    [CLSaveUserPassWordTool saveToken:@""];
}

+ (BOOL) hasLoginPassword {
    
    return [CLAppContext context].userMessage.user_info.has_pwd;
}

@end
