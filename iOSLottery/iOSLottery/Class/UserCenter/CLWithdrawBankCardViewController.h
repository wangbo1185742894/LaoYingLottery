//
//  CLWithdrawBankCardViewController.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseViewController.h"

@protocol CLWithdrawBankCardChangeDelegate <NSObject>

- (void) useSelectedBankCardIndex:(NSInteger)index;

- (void) bankCardsChange:(NSArray*)cards;

@end

@interface CLWithdrawBankCardViewController : CLBaseViewController

@property (nonatomic, strong) NSArray* bankCards;

@property (nonatomic, weak) id <CLWithdrawBankCardChangeDelegate> delegate;

- (instancetype) initWithCardIndex:(NSInteger)index bankCards:(NSArray*)cards;

@end
