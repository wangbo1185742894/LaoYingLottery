//
//  CLLotteryBespeakApi.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryBusinessRequest.h"

@interface CLLotteryBespeakApi : CLLotteryBusinessRequest<CLBaseConfigRequest>

@property (nonatomic, strong) NSString *order_Id;


@end
