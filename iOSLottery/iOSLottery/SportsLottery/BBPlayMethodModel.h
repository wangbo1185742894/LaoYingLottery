//
//  BBPlayMethodModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBaseModel.h"

@interface BBPlayMethodModel : SLBaseModel

@property (nonatomic, strong) NSString *matchIssuse;

@property (nonatomic, strong) NSString *playMethodName;

@property (nonatomic, strong) NSArray *playMethodTag;

@property (nonatomic, assign) BOOL isSale;

@property (nonatomic, strong) NSArray *itemNameArray;

@property (nonatomic, strong) NSArray *oddsArray;

@property (nonatomic, assign) BOOL isDanGuan;

@property (nonatomic, assign) BOOL isRangFen;

@property (nonatomic, strong) NSString *rangFenNumber;

@end
