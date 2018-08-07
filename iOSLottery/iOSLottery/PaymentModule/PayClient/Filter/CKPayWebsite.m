//
//  CKPayWebsite.m
//  iOSLottery
//
//  Created by 彩球 on 17/4/23.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CKPayWebsite.h"
#import <UIKit/UIKit.h>
#import "NSString+CKCoding.h"
#import "CKNotificationUtils.h"
#define CKPaySafariHostKey @"caiqrhost"
#define CKPaySafariHostValue @"caiqrPayment"

#define IOS_VERSION_GTR10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

NSDictionary* ck_urlQueryParse(NSString *query);

@implementation CKPayWebsite


+ (void)websitePaymentWithInfo:(id)info
                transitionType:(NSInteger)transitionType
                      h5Prefix:(NSString *)paymentUrlPrefix
                  intermediary:(id<CKPayIntermediaryInterface>) inter
                      complete:(void(^)(void))complete
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:info];
    [params setObject:[inter urlScheme] forKey:@"scheme"];
    [params setObject:[NSString stringWithFormat:@"%zi",transitionType] forKey:@"paytype"];
    [params setObject:CKPaySafariHostValue forKey:CKPaySafariHostKey];
    
    //fix bug issue #1
    if ([inter payH5ClientType]) [params setObject:[inter payH5ClientType] forKey:@"clientType"];
    if ([inter payH5UrlVersion]) [params setObject:[inter payH5UrlVersion] forKey:@"payStyleVersion"];
    if (paymentUrlPrefix == nil) {
        paymentUrlPrefix =  [NSString stringWithFormat:@"%@paymentRed.html",[inter onlyRedPacketPayUrlPrefix]];
    }
    NSAssert(paymentUrlPrefix, @"payment jump url is nil");
    /** 支付方式String */
    NSString *url = [NSString stringWithFormat:@"%@?%@",paymentUrlPrefix,[CKPayWebsite configOpenUrlParams:params]];
    NSLog(@"safari address is :%@",url);
    
//    UIApplicationOpenURLOptionUniversalLinksOnly
    //fix issue #2
    if (IOS_VERSION_GTR10) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{}
                                 completionHandler:^(BOOL success) {
                                     if (!success) {
                                         /** 无法打开对应URL */
                                         
                                         [[NSNotificationCenter defaultCenter] postNotificationName:CK_CanNotOpenSafari object:nil];
                                     }else{
                                         !complete?:complete();
                                     }
                                 }];
    }else{
        BOOL success = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
        if (success) {
            !complete?:complete();
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }else{
            /** 无法打开对应的URL */
            [[NSNotificationCenter defaultCenter] postNotificationName:CK_CanNotOpenSafari object:nil];
        }
    }
}


+ (BOOL)checkPageValidUrl:(NSURL*)url
{
    
    
    
//    NSString* payUrlScheme = [url scheme];
    NSString* payUrlHost = [url host];
//    NSString* payUrlQuery = [url query];
 
    return (payUrlHost.length && [payUrlHost isEqualToString:CKPaySafariHostValue]);

    
//    payUrlScheme isEqualToString:<#(nonnull NSString *)#>
//    
//    NSDictionary* queryDict = ck_urlQueryParse(payUrlQuery);
//    
//    CQPaymentResponse *paymentResponse = [CQSportsBetPaymentHandler objectGetUrlQuery:payUrlQuery];
//    
//    if (payUrlScheme && [payUrlScheme isEqualToString:[CKPayClient sharedManager].clientUrlScheme] &&
//        payUrlHost && [payUrlHost isEqualToString:CKPayClientPayMentFlag] &&
//        paymentResponse && paymentResponse.classname) {
//        
//        NSString* className = [NSString stringWithUTF8String:object_getClassName([CQSportsBetPaymentHandler sharedManager].paymentViewController)];
//        return [paymentResponse.classname isEqualToString:className];
//    }
//    return NO;
}


NSDictionary* ck_urlQueryParse(NSString *query){
    NSMutableDictionary __block *queryDic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (!query || query.length == 0) {
        return nil;
    }
    
    NSArray* tempArr = [query componentsSeparatedByString:@"&"];
    [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray* arr = [obj componentsSeparatedByString:@"="];
        if (arr.count == 2) {
            [queryDic setObject:[arr lastObject] forKey:[arr firstObject]];
        }
    }];
    return queryDic;
}

#pragma mark - url config

+ (NSString*)configOpenUrlParams:(NSDictionary*)dictionary
{
    NSMutableString __block *resultString = [NSMutableString stringWithCapacity:0];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString* obj, BOOL * _Nonnull stop) {
        NSString* value = @"";
        if ([obj isKindOfClass:[NSString class]]) {
            value = obj;
        }
        [resultString appendFormat:@"%@=%@&",key,value.ck_nativeUrlEncode.base64.ck_nativeUrlEncode];
//                [resultString appendFormat:@"%@=%@&",key,value];
    }];
    
    [resultString deleteCharactersInRange:NSMakeRange(resultString.length - 1, 1)];
    return resultString;
}

@end
