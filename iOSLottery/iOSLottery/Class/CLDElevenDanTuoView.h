//
//  CLDElevenDanTuoView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/2.
//  Copyright © 2016年 caiqr. All rights reserved.
// D11 胆拖类的View

#import <UIKit/UIKit.h>
#import "CLDElevenMainBetDelegate.h"
@class CLDEDTBetTerm;
@interface CLDElevenDanTuoView : UIView <CLDElevenMainBetDelegate>
/**
 回调 返回 注数 最小奖金 最大奖金
 */
@property (nonatomic, copy) void(^callBackNoteBonusBlock)(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus);

@property (nonatomic, strong) UILabel *explainInfoLabel;//胆码说明
@property (nonatomic, strong) UILabel *tuoExplainInfoLabel;//拖码说明

@property (nonatomic, strong) CLDEDTBetTerm *dt_BetTerm;

//配置默认选中项
- (void)assignSelectBetButtonWithData:(CLDEDTBetTerm *)betTerm;
@end
