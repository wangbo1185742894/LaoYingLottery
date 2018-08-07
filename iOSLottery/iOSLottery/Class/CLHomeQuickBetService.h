//
//  CLHomeQuickBetService.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/10.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class CLHomeGamePeriodModel;

@protocol CLHomeQuickBetServiceDelegate <NSObject>

- (void)requestFinishBet:(id)data;

- (void)requestFailBet:(id)data;
@end

@interface CLHomeQuickBetService : NSObject

@property (nonatomic, weak) id<CLHomeQuickBetServiceDelegate> delegate;


- (NSArray *)getRandomBetTermWithType:(NSString *)lotteryGameEn;

- (void)createOrderNumberWithMultiple:(NSInteger)multiple periodModel:(CLHomeGamePeriodModel *)model;


@end
