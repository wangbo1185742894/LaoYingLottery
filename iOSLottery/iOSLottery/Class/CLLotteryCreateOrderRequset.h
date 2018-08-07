//
//  CLLotteryCreateOrderRequset.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/10.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLotteryBusinessRequest.h"

@interface CLLotteryCreateOrderRequset : CLLotteryBusinessRequest

 //http：//localhost：8080/order/normalOrder？token=userToken&gameId=19511&periodId=201611090001&betTimes=2&lotteryNumber=12_13_14[HEZHI],SAME_3_ALL[SAME_3_ALL],4 5 6[DIFF_3],1 2 3 5 6[DIFF_3]&amount=60&client=1

@property (nonatomic, strong) NSString *gameId;//彩种
@property (nonatomic, strong) NSString *periodId;//期次
@property (nonatomic, strong) NSString *betTimes;//投注倍数
@property (nonatomic, strong) NSString *lotteryNumber;//投注号
@property (nonatomic, strong) NSString *amount;//金额
@property (nonatomic, strong) NSString *gameExtra;//是否追加

@end
