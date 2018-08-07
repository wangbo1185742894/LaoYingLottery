//
//  SLOrderDetailsRequest.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/24.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryBusinessRequest.h"

typedef NS_ENUM(NSInteger, SLOrderStatus) {
    
    SLOrderStatusUnPay = 0,    //等待支付
    SLOrderStatusOverduePay,   //过期未支付
    SLOrderStatusPay,          //已支付
    SLOrderStatusBeting,       //已拆单投注中
    SLOrderStatusRefund,       //已退款
    SLOrderStatusBetSuccess,   //投注成功
};

@interface SLOrderDetailsRequest : CLLotteryBusinessRequest<CLBaseConfigRequest>

@property (nonatomic, strong) NSString *order_id;


/**
 处理请求数据
 */
- (void)disposeDataDictionary:(NSDictionary *)data;

/**
 获取区头model
 */
- (id)getHeaderViewModel;

- (id)getAllModel;

@end
