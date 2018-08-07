//
//  CLSSQDetailModel.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/7.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLSSQDetailModel : CLBaseModel

@property (nonatomic, strong) NSString *betNumber;//投注号
@property (nonatomic, strong) NSString *betType;//投注类型
@property (nonatomic, strong) NSString *betNote;//投注注数
@property (nonatomic, strong) NSString *betMoney;//投注金额

@end
