//
//  SLPushService.m
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/31.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLPushService.h"
#import "SLListViewController.h"
#import "SLDrawNoticeController.h"
#import "SLBetOrderDetailsController.h"
@implementation SLPushService

+ (void)pushFootBallDrawNoticeViewControllerWithOrigin:(UIViewController *)originViewController gameEn:(NSString *)gameEn{
    
    SLDrawNoticeController *drawNoticeController = [[SLDrawNoticeController alloc] init];
    drawNoticeController.hidesBottomBarWhenPushed = YES;
    drawNoticeController.gameEn = gameEn;
    [originViewController.navigationController pushViewController:drawNoticeController animated:YES];
}

+ (void)pushFootBallOrderDetailViewControllerWithOrigin:(UIViewController *)originViewController orderId:(NSString *)orderId{
    
    
//    [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"SLBetOrderDetailsController_push/%@", orderID] dissmissPresent:YES animation:NO];
    
    SLBetOrderDetailsController *orderDetailController = [[SLBetOrderDetailsController alloc] init];
    orderDetailController.order_ID = orderId;
    orderDetailController.hidesBottomBarWhenPushed = YES;
    [originViewController.navigationController pushViewController:orderDetailController animated:YES];
}
@end
