//
//  CLHomeGameEnteranceModel.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/21.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLHomeGameEnteranceModel : CLBaseModel

@property (nonatomic, strong) NSString* contentUrl;
@property (nonatomic, strong) NSString* imgUrl;
@property (nonatomic, strong) NSString* tips;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* activityIconUrl;
@property (nonatomic, strong) NSString* ifShowTipsStyle;
@property (nonatomic, assign) long entranceId;
@property (nonatomic, assign) long isDel;
@property (nonatomic, assign) long positionType;
@property (nonatomic, assign) long weight;
@property (nonatomic, strong) NSString *tipsType;
@property (nonatomic, assign) long ifActivity;
/** 1.4添加字段 */
/** 是否显示倒计时时间 */
@property (nonatomic, readwrite) BOOL ifShowCountdown;
/** 倒计时时间 */
@property (nonatomic, assign) long long awardCountdown;
/** 是否是彩种系列 */
@property (nonatomic, readwrite) BOOL ifGameSeries;
/** 彩种系列数据 */
@property (nonatomic, strong) NSArray *subEntrances;
/** 系列彩种是不是展开状态 */
@property (nonatomic, readwrite) BOOL subEntranceIsShow;

@end
