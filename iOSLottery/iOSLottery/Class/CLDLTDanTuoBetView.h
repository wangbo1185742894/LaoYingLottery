//
//  CLDLTDanTuoBetView.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLDLTDanTuoBetTerm.h"
@interface CLDLTDanTuoBetView : UIView

@property (nonatomic, strong) CLDLTDanTuoBetTerm *betTerm;
@property (nonatomic, copy) void(^ssq_normalCallBackNoteBonusBlock)(NSInteger max, NSInteger min, NSInteger note, BOOL hasSelect);//最大奖金  最小奖金  注数 是否有选中的按钮
- (void)assginDefaultData:(CLDLTDanTuoBetTerm *)betTerm;
- (void)ssq_danTuoClearAll;
- (void)refreshNote;
- (void)assignOmissionDataWithRed:(NSArray *)redArray blue:(NSArray *)blueArray;
/**
 隐藏遗漏
 
 @param hidden 是否隐藏
 */
- (void)hiddenOmission:(BOOL)hidden;
- (void)assignActicityLink:(id)data;
@end
