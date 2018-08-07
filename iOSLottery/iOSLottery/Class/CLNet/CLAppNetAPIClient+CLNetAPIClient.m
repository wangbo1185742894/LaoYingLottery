//
//  CLAppNetAPIClient+CLNetAPIClient.m
//  iOSLottery
//
//  Created by 彩球 on 17/2/27.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLAppNetAPIClient+CLNetAPIClient.h"
#import <objc/runtime.h>
#import "CLAppContext.h"
static char *cl_userAgent = "cl_userAgent";
@implementation CLAppNetAPIClient (CLNetAPIClient)
+ (void) load {
    
    Method M_Config = class_getInstanceMethod([CLAppNetAPIClient class], @selector(configApiClient));
    Method M_ReplaceConfig = class_getInstanceMethod([CLAppNetAPIClient class], @selector(replaceConfigApiClient));
    method_exchangeImplementations(M_Config, M_ReplaceConfig);
    
}

- (void) replaceConfigApiClient {
    
    
    /** 重新设置User_Agent */
    NSMutableString* user_agent = [NSMutableString stringWithString:[self.requestSerializer valueForHTTPHeaderField:@"User-Agent"]];
    [user_agent appendFormat:@" Client/%@",[CLAppContext clientType]];
    [self.requestSerializer setValue:user_agent forHTTPHeaderField:@"User-Agent"];
//    NSLog(@"user_agent ------ %@", user_agent);
    self.user_agent = user_agent;
    self.securityPolicyPinningMode = MKSSLPinningModeNone;
    
    [self replaceConfigApiClient];
    
}

-(void)setUser_agent:(NSString *)user_agent{
    objc_setAssociatedObject(self, cl_userAgent, user_agent, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)user_agent
{
    return objc_getAssociatedObject(self, cl_userAgent);
}

@end
