//
//  SLSPFPlayView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//  胜平负view

#import <UIKit/UIKit.h>

@class SLSPFModel;

@interface SLSPFPlayView : UIView


/**
 主胜选项
 */
@property (nonatomic, strong) UIButton *hostWinBtn;

/**
 平局选项
 */
@property (nonatomic, strong) UIButton *dogfallBtn;

/**
 客胜选项
 */
@property (nonatomic, strong) UIButton *guestWinBtn;


@property (nonatomic, strong) SLSPFModel *spfModel;

/**
 当前比赛matchIssue
 */
@property (nonatomic, strong) NSString *matchIssue;

/**
 点击了按钮  是否选中  选中的第几个
 */
@property (nonatomic, copy) void(^clickButtonBlock)(BOOL isSelect, NSInteger selectNumber);

@end
