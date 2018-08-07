//
//  BBMatchHistoryView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/23.
//  Copyright © 2017年 caiqr. All rights reserved.
//  篮球历史战绩 View

#import <UIKit/UIKit.h>

@class SLMatchHistoryModel;

@interface BBMatchHistoryView : UIView

@property (nonatomic, strong) NSString *hostName;

@property (nonatomic, strong) SLMatchHistoryModel *vsModel;

@property (nonatomic, strong) SLMatchHistoryModel *hostModel;

@property (nonatomic, strong) SLMatchHistoryModel *awayModel;

@property (nonatomic, strong) NSString *detailsUrl;

@property (nonatomic, copy) void(^onClickBlock)();


@end
