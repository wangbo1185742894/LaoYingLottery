//
//  CLActivityModel.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/4/6.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLActivityModel : CLBaseModel

/**
 活动标题
 */
@property (nonatomic, strong) NSString *shareTitle;

/**
 活动时间
 */
@property (nonatomic, strong) NSString *activityDate;

/**
 是否参加
 */
@property (nonatomic, assign) NSInteger isJoin;

/**
 活动的图片url
 */
@property (nonatomic, strong) NSString *imgUrl;

/**
 活动的url
 */
@property (nonatomic, strong) NSString *activityUrl;

@end
