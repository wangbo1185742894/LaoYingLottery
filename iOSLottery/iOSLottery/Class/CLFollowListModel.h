//
//  CLFollowListModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/21.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLFollowListModel : CLBaseModel

/**
 方案Id
 */
@property (nonatomic, strong) NSString* followId;

/**
 用户id
 */
@property (nonatomic, strong) NSString* userCode;

/**
 奖金
 */
@property (nonatomic, strong) NSString* bonus;
@property (nonatomic) NSInteger commonFlag;

/**
 方案创建时间
 */
@property (nonatomic, strong) NSString* createTime;

/**
 方案已追号信息
 */
@property (nonatomic, strong) NSString* followInfo;

/**
 方案追号状态
 */
@property (nonatomic, strong) NSString* followStatusCn;

/**
 方案状态码
 */
@property (nonatomic) NSInteger followStatus;

/**
 彩种中文名称
 */
@property (nonatomic, strong) NSString* gameName;

/**
 periodCancel
 */
@property (nonatomic) NSInteger periodCancel;

/**
 已追期次
 */
@property (nonatomic) NSInteger periodDone;

/**
 总期次
 */
@property (nonatomic) NSInteger totalPeriod;

/**
 开奖状态
 */
@property (nonatomic) NSInteger prizeStatus;

/**
 状态颜色
 */
@property (nonatomic, strong) NSString *statusCnColor;

@property (nonatomic, assign) BOOL ifSkipDetail;

@end
