//
//  CLUserBaseInfo.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/6.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLUserBaseInfo.h"
#import "CLSaveUserPassWordTool.h"
#import "NSString+Coding.h"
@implementation CLUserBaseInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.login_token = [[LoginToken alloc] init];
        self.account_info = [[AccountInfo alloc] init];
        self.user_info = [[UserInfo alloc] init];
    }
    return self;
}

@end

@implementation UserInfo

- (void)setNick_name:(NSString *)nick_name{
    
    _nick_name = [nick_name urlDecode];
}

@end

@implementation AccountInfo

+ (AccountInfo*)attribute:(id)info;
{
    AccountInfo* account = [[AccountInfo alloc] init];
    if (!info || (![info isKindOfClass:[NSDictionary class]])) return account;
    
    
    NSString* money = info[@"account_balance"];
    double real_money = 0.f;
    if (money && (money.length > 0)) {
        NSRange range = [money rangeOfString:@"元"];
        if (range.location != NSNotFound) {
            real_money = [[money substringToIndex:range.location] doubleValue];
        } else {
            real_money = [money doubleValue];
        }
    }
    account.account_balance = real_money * 100.f;
    account.red_balance = [info[@"red_balance"] doubleValue] * 100.f;
    return account;
}

@end

@implementation LoginToken
@synthesize token = _token;
- (void)setToken:(NSString *)token{
    
    _token = token;
    [CLSaveUserPassWordTool saveToken:token];
}
- (NSString *)token{
    
    return [CLSaveUserPassWordTool readToken];
}
@end
