//
//  CLSSQDTBetView.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/2.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLSSQDTBetTerm.h"
@interface CLSSQDTBetView : UIView

@property (nonatomic, strong) CLSSQDTBetTerm *betTerm;
@property (nonatomic, copy) void(^ssq_normalCallBackNoteBonusBlock)(NSInteger max, NSInteger min, NSInteger note, BOOL hasSelect);//最大奖金  最小奖金  注数 是否有选中的按钮
- (void)assginDefaultData:(CLSSQDTBetTerm *)betTerm;
- (void)ssq_danTuoClearAll;
- (void)refreshNote;
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
