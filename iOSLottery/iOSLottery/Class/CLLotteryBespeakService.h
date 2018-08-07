//
//  CLLotteryBespeakService.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CLLotteryBespeakService : NSObject

+ (void)runBespeakServiceWithOrderId:(NSString*)order_id
                          completion:(void(^)(void)) completion;

@end
