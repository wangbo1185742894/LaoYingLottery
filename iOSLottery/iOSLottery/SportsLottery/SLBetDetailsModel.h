//
//  SLBetDetailsModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/18.
//  Copyright © 2017年 caiqr. All rights reserved.
//  投注列表 Model

#import "SLBaseModel.h"

@class SLBetDetailsItemModel;

@interface SLBetDetailsModel : SLBaseModel

@property (nonatomic, strong) NSString *hostName;

@property (nonatomic, strong) NSString *awayName;

@property (nonatomic, strong) NSString *matchIssue;

/**
 赛事信息(周几00几)
 */
@property (nonatomic, strong) NSString *matchSession;

@property (nonatomic, strong) NSMutableArray<SLBetDetailsItemModel *> *itemArray;

@property (nonatomic, assign, getter=isHiddenBottomLine) BOOL hiddenBottomLine;

@end

@interface SLBetDetailsItemModel : SLBaseModel

@property (nonatomic, strong) NSString *playName;

@property (nonatomic, strong) NSMutableArray *betArray;


@end
