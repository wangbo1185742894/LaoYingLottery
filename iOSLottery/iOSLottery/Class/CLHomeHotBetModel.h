//
//  CLHomeHotBetModel.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"
@class CLHomeGamePeriodModel;

@interface CLHomeHotBetModel : CLBaseModel

/**
 开奖时间(SSQ/DLT)
 */
@property (nonatomic, strong) NSString *hotTips;

/**
 热门投注左上玩法描述
 */
@property (nonatomic, strong) NSString *hotTitle;

/**
 快速投注按钮文案
 */
@property (nonatomic, strong) NSString *buttonTips;
@property (nonatomic, strong) CLHomeGamePeriodModel *periodVo;

@end
