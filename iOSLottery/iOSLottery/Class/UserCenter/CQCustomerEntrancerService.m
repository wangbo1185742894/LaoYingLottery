//
//  CQCustomerEntrancerService.m
//  caiqr
//
//  Created by huangyuchen on 16/8/1.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQCustomerEntrancerService.h"
#import "QYSDK.h"
#import "CQDefinition.h"
#import "MJExtension.h"

#import "CLAppContext.h"
#import "CLUserBaseInfo.h"
#import "CLAccountInfoModel.h"

@implementation CQCustomerEntrancerService
#pragma mark - 跳转联系客服页面
+(void)pushSessionViewControllerWithInitiator:(UIViewController *__weak)initiator{
    
    BOOL __loginState = [[CLAppContext context] appLoginState];
    
    
    QYUserInfo *userInfo = [[QYUserInfo alloc] init];
    userInfo.userId = (__loginState)?[CLAppContext context].userMessage.user_info.user_id:@"";
    /** 配置客户端基本信息 */
    NSMutableArray* userInfoSource = [NSMutableArray arrayWithCapacity:3];
    
    NSString* realNameValue = (__loginState)? [CLAppContext context].userMessage.user_info.nick_name:@"未登陆用户";
    [userInfoSource addObject:@{@"key":@"real_name",@"value":realNameValue}];
    
    if (__loginState) {
        NSString* mobileValue = [CLAppContext context].userMessage.user_info.mobile;
        
        NSString* emailValue = [NSString stringWithFormat:@"账户余额:%.2f|\n红包余额:%.2f",([CLAppContext context].userMessage.account_info.account_balance / 100.f),([CLAppContext context].userMessage.account_info.red_balance / 100.f)];
        
        [userInfoSource addObject:@{@"key":@"mobile_phone",@"value":mobileValue}];
        [userInfoSource addObject:@{@"key":@"email",@"value":emailValue}];
    }
    
    
    
    
    NSString* deviceValue = [NSString stringWithFormat:@"系统版本:%f|\n设备类型:%@|\n客户端版本:%@",IOS_VERSION,[[CLAppContext context] deviceModel],APP_VERSION];
    NSString* clientValue = [NSString stringWithFormat:@"客户端名称:%@|\n客户端类型:%@",Client_DisplayName,[CLAppContext clientType]];
    [userInfoSource addObject:@{@"key":@"info",@"label":@"设备信息",@"value":deviceValue}];
    [userInfoSource addObject:@{@"key":@"info",@"label":@"设备类型",@"value":clientValue}];
    
    userInfo.data = [userInfoSource mj_JSONString];
    
    [[QYSDK sharedSDK] setUserInfo:userInfo];
    
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"客服小妹";
    sessionViewController.hidesBottomBarWhenPushed = YES;
    
    initiator.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                         NSFontAttributeName : [UIFont systemFontOfSize:16]};
    [initiator.navigationController pushViewController:sessionViewController animated:YES];
}
@end
