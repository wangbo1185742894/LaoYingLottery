//
//  CLFastThreeMainBetView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//
//快三投注页 的投注View的容器  用于切换不同的投注项
#import <UIKit/UIKit.h>
#import "CLFastThreeConfigMessage.h"
@interface CLFastThreeMainBetView : UIView

@property (nonatomic, strong) NSString *gameEn;

/**
 投注项发生变化回调  注数 最小奖金 最大奖金 是否有选中的投注按钮
 */
@property (nonatomic, copy) void(^betBonusAndNotesBlock)(NSInteger note, NSInteger minBonus, NSInteger maxBonus, BOOL hasSelectBetButton);
//配置默认选项
- (void)assginDataWithSelectedData:(id)betInfo playMothedType:(CLFastThreePlayMothedType)playMothedType;
//刷新页面
- (void)refreshShowWithPlayMothed:(CLFastThreePlayMothedType)playMothed;
//获取投注项
- (id)getBetTermInfoWithPlayMothed:(CLFastThreePlayMothedType)playMothed;
//清空页面
- (void)clearAllSelectedBetButtonWithPlayMothed:(CLFastThreePlayMothedType)playMothed;

/**
 请求数据返回后刷新数据
 */
- (void)reloadDataForFTMainBetView;
@end
