//
//  SLExternalService.m
//  SportsLottery
//
//  Created by huangyuchen on 2017/6/1.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLExternalService.h"

@implementation SLExternalService

+ (instancetype)sl_ShareExternalService{
    
    static SLExternalService *sharedSLExternalService = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedSLExternalService = [[self alloc] init];
    });
    return sharedSLExternalService;
}

+ (NSString *)getToken{
    
    if ([[SLExternalService sl_ShareExternalService].externalService respondsToSelector:@selector(getToken)]) {
        return [[SLExternalService sl_ShareExternalService].externalService getToken];
    }
    return @"";
}

+ (void)showError:(NSString *)errorMes{
    
    if ([[SLExternalService sl_ShareExternalService].externalService respondsToSelector:@selector(showError:)]) {
        [[SLExternalService sl_ShareExternalService].externalService showError:errorMes];
    }
}

+ (void)startLoading{
    
    if ([[SLExternalService sl_ShareExternalService].externalService respondsToSelector:@selector(startLoading)]) {
        [[SLExternalService sl_ShareExternalService].externalService startLoading];
    }
}
+ (void)stopLoading{
    
    if ([[SLExternalService sl_ShareExternalService].externalService respondsToSelector:@selector(stopLoading)]) {
        [[SLExternalService sl_ShareExternalService].externalService stopLoading];
    }
}
+ (void)createOrderSuccess:(id)orderInfo origin:(UIViewController *)originVC{
    
    if ([[SLExternalService sl_ShareExternalService].externalService respondsToSelector:@selector(createOrderSuccess:origin:)]) {
        [[SLExternalService sl_ShareExternalService].externalService createOrderSuccess:orderInfo origin:originVC];
    }
}

+ (void)createContinueOrderSuccess:(id)orderInfo origin:(UIViewController *)originVC
{

    if ([[SLExternalService sl_ShareExternalService].externalService respondsToSelector:@selector(createContinueOrderSuccess:origin:)]) {
        
        [[SLExternalService sl_ShareExternalService].externalService createContinueOrderSuccess:orderInfo origin:originVC];
    }
}

+ (void)checkIsLoginWithComplete:(void (^)())complete{
    
    if ([[SLExternalService sl_ShareExternalService].externalService respondsToSelector:@selector(checkIsLoginWithComplete:)]) {
        [[SLExternalService sl_ShareExternalService].externalService checkIsLoginWithComplete:complete];
    }
}

+ (void)shareMessageWithTitle:(NSString *)title tableView:(UITableView *)tableView;
{

    if ([[SLExternalService sl_ShareExternalService].externalService respondsToSelector:@selector(shareMessageWithTitle:tableView:)]) {
        
        [[SLExternalService sl_ShareExternalService].externalService shareMessageWithTitle:title tableView:tableView];
    }
}

+ (void)showFootBallNewbieGuidance{
    
    if ([[SLExternalService sl_ShareExternalService].externalService respondsToSelector:@selector(showFootBallNewbieGuidance)]) {
        
        [[SLExternalService sl_ShareExternalService].externalService showFootBallNewbieGuidance];
    }
}

+ (void)showBasketBallNewbieGuidance{
    
    if ([[SLExternalService sl_ShareExternalService].externalService respondsToSelector:@selector(showBasketBallNewbieGuidance)]) {
        
        [[SLExternalService sl_ShareExternalService].externalService showBasketBallNewbieGuidance];
    }
}

+ (void)showRefundExplain
{
    if ([[SLExternalService sl_ShareExternalService].externalService respondsToSelector:@selector(showRefundExplain)]) {
        
        [[SLExternalService sl_ShareExternalService].externalService showRefundExplain];
    }
}

+ (BOOL)hasNet{
    
    if ([[SLExternalService sl_ShareExternalService].externalService respondsToSelector:@selector(hasNet)]) {
        
        return [[SLExternalService sl_ShareExternalService].externalService hasNet];
    }
    return YES;
}

+ (void)goToHomeViewController
{

    if ([[SLExternalService sl_ShareExternalService].externalService respondsToSelector:@selector(goToHomeViewController)]) {
        
        return[[SLExternalService sl_ShareExternalService].externalService goToHomeViewController];
    }
}

+ (void)goToFootBallViewController
{

    if ([[SLExternalService sl_ShareExternalService].externalService respondsToSelector:@selector(goToFootBallViewController)]) {
        
        return[[SLExternalService sl_ShareExternalService].externalService goToFootBallViewController];
    }
}

+ (void)goToBasketBallViewController
{

    if ([[SLExternalService sl_ShareExternalService].externalService respondsToSelector:@selector(goToBasketBallViewController)]) {
        
        return[[SLExternalService sl_ShareExternalService].externalService goToBasketBallViewController];
    }
}

@end
