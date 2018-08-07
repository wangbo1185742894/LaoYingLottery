//
//  CQCustomerEntrancerService.h
//  caiqr
//
//  Created by huangyuchen on 16/8/1.
//  Copyright © 2016年 Paul. All rights reserved.
//

/* 调用七鱼客服 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CQCustomerEntrancerService : NSObject

/**
 *  联系客服
 */
+ (void)pushSessionViewControllerWithInitiator:(UIViewController *__weak)initiator;

@end
