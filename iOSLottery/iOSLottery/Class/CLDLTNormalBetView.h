//
//  CLDLTNormalBetView.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLDLTNormalBetTerm.h"
@interface CLDLTNormalBetView : UIView

@property (nonatomic, strong) CLDLTNormalBetTerm *betTerm;
@property (nonatomic, copy) void(^ssq_normalCallBackNoteBonusBlock)(NSInteger max, NSInteger min, NSInteger note, BOOL hasSelect);//最大奖金  最小奖金  注数 是否有选中的按钮

- (void)assignDefaultData:(CLDLTNormalBetTerm *)betTerm;

/**
 刷新注数 用于首页底部刷新
 */
- (void)refreshNote;
/**
 清空所有
 */
- (void)ssq_normalClearAll;

/**
 随机选号
 */
- (void)ssq_randomSelectBall;
/**
 配置遗漏
 
 @param redArray 红球
 @param blueArray 蓝球
 */
- (void)assignOmissionDataWithRed:(NSArray *)redArray blue:(NSArray *)blueArray;


/**
 隐藏遗漏

 @param hidden 是否隐藏
 */
- (void)hiddenOmission:(BOOL)hidden;

- (void)assignActicityLink:(id)data;
@end
