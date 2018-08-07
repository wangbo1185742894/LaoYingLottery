//
//  CLNativePushService.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/20.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLNativePushService.h"
#import "CLAllJumpManager.h"
#import "CLJumpLotteryManager.h"
#import "CLAppContext.h"
#import "CLNativePushLotteryManager.h"
#import "CLTools.h"
#define eagleNative @"eagleNative"

@implementation CLNativePushService

+ (void)pushNativeUrl:(NSString *)url{
    
    NSURL* availableUrl = nil;
    if ([CLTools isValidUrl:url]) {
        
        availableUrl = [NSURL URLWithString:url];
    }else{
        NSString *encodeUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        availableUrl = [NSURL URLWithString:encodeUrl];
    }
    
    //availableUrl is nil
    if (!availableUrl) return;
    
    NSString* nativeConvertMark = [availableUrl host];
    if (![nativeConvertMark isKindOfClass:[NSString class]] ||
        (![nativeConvertMark isEqualToString:eagleNative])){
        if ([url hasPrefix:@"http"]) {
            [[CLAllJumpManager shareAllJumpManager] open:url];
        }
        return;
    }
    id query = [self splitQuery:[availableUrl query]];
    //获取对应的page
    NSString *page = [self getPageWithQuery:query];
    //跳转对应页面
    [self jumpViewController:page query:query];
}
#pragma mark - 跳转对应页面
+ (void)jumpViewController:(NSString *)page query:(NSDictionary *)query{
    
    
    //获取对应的类名
    NSString *class = [self getClassNameWithPage:page];
    if (!(class && class.length > 0)) {
        return;
    }
    if ([page isEqualToString:@"followDetail"]) {
        [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"%@/%@",class, query[@"followId"]]];
    }else if ([page isEqualToString:@"orderDetail"]){
        
        [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"%@/%@",class, query[@"orderId"]]];
    }else if ([page isEqualToString:@"jcOrderDetail"]){
        [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"%@/%@",class,query[@"orderId"]] dissmissPresent:YES];
    }else if ([page isEqualToString:@"game"]){
        NSString *play = query[@"playType"];
        if (play && play.length > 0) {
            [CLJumpLotteryManager jumpLotteryWithGameEn:query[@"gameEn"] playMothed:play];
        }else{
            [CLJumpLotteryManager jumpLotteryWithGameEn:query[@"gameEn"] isJudgeCache:YES];
        }
        
    }else if ([page isEqualToString:@"betDetail"]){
        //跳转对应的投注详情
        BOOL ret = [CLNativePushLotteryManager saveBetTermInfo:query];
        if (ret) {
            [CLJumpLotteryManager jumpLotteryWithGameEn:query[@"gameEn"]];
        }
        
    }else if ([page isEqualToString:@"wap"]){
        
        NSString *baseUrl = query[@"url"];
        //判断是否有token
        if ([[CLAppContext context] token].length > 0) {
            //判断url中是否含有 ？ 有则直接拼&token=  没有则拼 ？token=
            if ([baseUrl rangeOfString:@"?"].location != NSNotFound) {
                baseUrl = [baseUrl stringByAppendingString:[NSString stringWithFormat:@"&token=%@", [CLAppContext context].token]];
            }else{
                baseUrl = [baseUrl stringByAppendingString:[NSString stringWithFormat:@"?token=%@", [CLAppContext context].token]];
            }
        }
        [[CLAllJumpManager shareAllJumpManager] open:baseUrl];
    }else{
        [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"%@",class]];
    }
}

#pragma mark - 转换url query 到字典
+ (NSDictionary*)splitQuery:(NSString*)query {
    if([query length]==0) return nil;
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    for(NSString* parameter in [query componentsSeparatedByString:@"&"]) {
        NSRange range = [parameter rangeOfString:@"="];
        if(range.location!=NSNotFound)
            [parameters setObject:[[parameter substringFromIndex:range.location+range.length] stringByRemovingPercentEncoding] forKey:[[parameter substringToIndex:range.location] stringByRemovingPercentEncoding]];
        else [parameters setObject:[[NSString alloc] init] forKey:[parameter stringByRemovingPercentEncoding]];
    }
    return [parameters copy];
}
#pragma mark - 获取对应的page
+ (NSString *)getPageWithQuery:(NSDictionary *)dic{
    
    if ([[dic allKeys] containsObject:@"page"]) {
        if (([dic[@"page"] isKindOfClass:[NSString class]] && ((NSString *)dic[@"page"]).length > 0)) {
            return dic[@"page"];
        }
    }
    return @"";
}

+ (NSString *)getClassNameWithPage:(NSString *)page{
    
    NSDictionary *classNameMap = @{
                                  @"followDetail" : @"CLFollowDetailViewController_push",
                                  @"orderDetail" : @"CLLottBetOrdDetaViewController_push",
                                  @"followList" : @"CLFollowListViewController_push",
                                  @"numOrderList" : @"CLLotteryBetOrderListViewController_push",
                                  @"game" : @"game",
                                  @"myhome" : @"CLUserCenterViewController",
                                  @"myhb" : @"CLRedEnvelopeViewController_push",
                                  @"buyhb" : @"CQBuyRedPacketsViewController_push",
                                  @"chongzhi" : @"CKNewRechargeViewController_push",
                                  @"login" : @"CLLoginViewController_present/",
                                  @"wap" : @"web",
                                  @"home" : @"CLHomeViewController",
                                  @"betDetail" : @"betDetail",
                                  @"userCenterActivity" : @"CLActivityViewController_push",
                                  @"jcOrderDetail":@"SLBetOrderDetailsController_push",
                                  };
    if ([[classNameMap allKeys] containsObject:page]) {
        if (([classNameMap[page] isKindOfClass:[NSString class]] && ((NSString *)classNameMap[page]).length > 0)) {
            return classNameMap[page];
        }
    }
    return @"";
}


@end
