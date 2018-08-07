//
//  CLOrderStatus.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/21.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, lotteryOrderStatus) {
    
    lotteryOrderStatusUnPay = 0,    //等待支付
    lotteryOrderStatusOverduePay,   //过期未支付
    lotteryOrderStatusPay,          //已支付
    lotteryOrderStatusBeting,       //已拆单投注中
    lotteryOrderStatusRefund,       //已退款
    lotteryOrderStatusBetSuccess,   //投注成功
};

typedef NS_ENUM(NSInteger, orderPrizeStatus) {
    
    orderPrizeStatusNoLottery = 0,              //未开奖
    orderPrizeStatusNoBonus,                //未中奖
    orderPrizeStatusSmallPrize,             //中小奖
    orderPrizeStatusBigPrizeWaitConfirm,    //中大奖奖金待确认
    orderPrizeStatusBigPrize,               //中大奖
};

typedef NS_ENUM(NSInteger, followPrizeStatus) {
    
    followPrizeStatusWaitBonus = 0,          //未开奖
    followPrizeStatusNoBonus,                //未中奖
    followPrizeStatusSmallPrize,             //中小奖
    followPrizeStatusBigPrizeWaitConfirm,    //中大奖奖金待确认
    followPrizeStatusBigPrize,               //中大奖
};

typedef NS_ENUM(NSInteger, followOrderStatus) {
    
    followOrderStatusUnPay = 0,              //未支付
    followOrderStatusUnPayCancel,            //未支付撤销
    followOrderStatusPay,                    //已支付
    followOrderStatusBeting,                  //已拆单投注中
    followOrderStatusFinishALLFollow,         //追号已经完成到期停止
    followOrderStatusFinishFollow,            //已完成,未继续追号期次已退款
};


@interface CLOrderStatus : NSObject



@end
