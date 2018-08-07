//
//  CLDElevenMainBetView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLDElevenConfigMessage.h"
@interface CLDElevenMainBetView : UIView

@property (nonatomic, strong) NSString *gameEn;

/**
 投注项发生改变调用block
 */
@property (nonatomic, copy) void(^selectedChangeBlock)(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus, BOOL hasSelectBetButton);
//配置默认选项
- (void)assginDataWithSelectedData:(id)betInfo playMothedType:(CLDElevenPlayMothedType)playMothedType;
//刷新页面
- (void)reloadDataWithPlayMothed:(CLDElevenPlayMothedType)playMothedType;
//获取投注项
- (NSArray *)getBetTermInfoWithPlayMothed:(CLDElevenPlayMothedType)playMothed;
//清空页面
- (void)clearAllSelectedBetButtonWithPlayMothed:(CLDElevenPlayMothedType)playMothed;

//刷新后台请求数据
- (void)reloadDataForMainBetViewWithPlayMothedType:(CLDElevenPlayMothedType)type;
@end
