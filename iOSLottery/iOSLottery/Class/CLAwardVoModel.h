//
//  CLAwardVoModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLAwardVoModel : CLBaseModel

@property (nonatomic, strong) NSString* periodId;
@property (nonatomic, strong) NSString* winningNumbers;
@property (nonatomic, strong) NSString* gameName;
@property (nonatomic, strong) NSString* gameEn;
@property (nonatomic, strong) NSString* awardTime;
@property (nonatomic, assign) long awardStatus;
@property (nonatomic, strong) NSArray *playTypeAndBonus;
@property (nonatomic, strong) id resultMap;
@property (nonatomic, strong) NSString *periodSale;
@property (nonatomic, strong) NSString *poolBonus;
@property (nonatomic, assign) NSInteger ifAuditing;//3.1.0 添加，版本审核控制

/**
 胜负彩赛事数据
 */
@property (nonatomic, strong) NSArray *sfcAwardVos;

/**
 胜负彩奖金信息
 */
@property (nonatomic, strong) NSDictionary *traditionalPlayTypeAndBonus;

/**
 试机号 福彩3D使用
 */
@property (nonatomic, strong) NSString *testNum;

/**
 赛事是否取消
 */
@property (nonatomic, assign) NSInteger isCancel;

@end

@interface CLSFCPeridDetailsModel : CLBaseModel

@property (nonatomic, strong) NSString *awayName;

@property (nonatomic, strong) NSString *result;

@property (nonatomic, strong) NSString *hostName;

@property (nonatomic, strong) NSString *score;

@property (nonatomic, strong) NSString *serialNumber;

@end
