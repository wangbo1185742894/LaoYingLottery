//
//  CLLotteryActivitiesModel.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/31.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLLotteryActivitiesModel : CLBaseModel

@property (nonatomic, strong) NSString *activityTips;// 活动文案
@property (nonatomic, strong) NSString *activityImgUrl;//活动展示图片或文案
@property (nonatomic, strong) NSString *activityUrl;//活动跳转地址
@property (nonatomic, strong) NSString *activityIconUrl;//活动浮窗图片地址
@property (nonatomic, strong) NSString *activityTipsType;//活动文案色值

@end
