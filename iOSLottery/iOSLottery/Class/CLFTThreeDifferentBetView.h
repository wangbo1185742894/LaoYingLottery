//
//  CLFTThreeDifferentBetView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/14.
//  Copyright © 2016年 caiqr. All rights reserved.
// 三不同号

#import <UIKit/UIKit.h>
#import "CLFTBetViewDelegate.h"
@class CLFTThreeDifferentBetInfo;
@class CLFTThreeDifferentAllBetInfo;
@interface CLFTThreeDifferentBetView : UIView <CLFTBetViewDelegate>

//UI相关
@property (nonatomic, copy) void(^threeDifferentBetBonusAndNotesBlock)(NSInteger, NSInteger , NSInteger);
//投注相关
@property (nonatomic, strong) CLFTThreeDifferentBetInfo *betInfo;//通选
@property (nonatomic, strong) CLFTThreeDifferentAllBetInfo *allBetInfo;//单选
//摇一摇
- (void)configRandomDice;
@end
