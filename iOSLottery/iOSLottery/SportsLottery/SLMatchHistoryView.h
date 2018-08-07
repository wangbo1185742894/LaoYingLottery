//
//  SLMatchHistoryView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/12.
//  Copyright © 2017年 caiqr. All rights reserved.
//  投注列表cell 历史详情view

#import <UIKit/UIKit.h>

@class SLMatchHistoryModel;

@interface SLMatchHistoryView : UIView

@property (nonatomic, strong) NSString *hostName;

@property (nonatomic, strong) SLMatchHistoryModel *vsModel;

@property (nonatomic, strong) SLMatchHistoryModel *hostModel;

@property (nonatomic, strong) SLMatchHistoryModel *awayModel;

@property (nonatomic, strong) NSString *detailsUrl;

@property (nonatomic, copy) void(^onClickBlock)();
@end
