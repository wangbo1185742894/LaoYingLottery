//
//  CLDEBetDetailModel.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/5.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLDEBetDetailModel : CLBaseModel

/**
 投注号
 */
@property (nonatomic, strong) NSString *betNumber;

/**
 投注类型
 */
@property (nonatomic, strong) NSString *betType;

/**
 玩法类型
 */
@property (nonatomic, assign) NSInteger playMethodType;

/**
 投注注数
 */
@property (nonatomic, strong) NSString *betNote;

/**
 投注金额
 */
@property (nonatomic, strong) NSString *betMoney;

/**
 订单参数
 */
@property (nonatomic, strong) NSString *lotteryNumber;

@property (nonatomic, strong) NSArray *betNumberArr;

@end
