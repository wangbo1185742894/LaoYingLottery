//
//  CLLotteryListViewController.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/11.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseViewController.h"

typedef NS_ENUM(NSInteger , CLLotteryOrderType) {
    
    CLLotteryOrderTypeDPC = 1,//大盘彩
    CLLotteryOrderTypeGPC = 2,//高频彩
    CLLotteryOrderTypeSFC = 5,//胜负彩
    CLLotteryOrderTypeFootBall = 30,//足球
    CLLotteryOrderTypeBasketBall = 31 //篮球
};

@interface CLLotteryBetOrderListViewController : CLBaseViewController

@end
