//
//  CLFTThreeSameBetView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//三同号

#import <UIKit/UIKit.h>
#import "CLFTBetViewDelegate.h"
@class CLFTThreeSameSingleBetInfo;
@class CLFTThreeSameAllBetInfo;
@interface CLFTThreeSameBetView : UIView <CLFTBetViewDelegate>

//UI相关
@property (nonatomic, copy) void(^threeSameBetBonusAndNotesBlock)(NSInteger, NSInteger , NSInteger);
//投注相关
@property (nonatomic, strong) CLFTThreeSameAllBetInfo *allBetInfo;//通选
@property (nonatomic, strong) CLFTThreeSameSingleBetInfo *singleBetInfo;//单选
//摇一摇
- (void)configRandomDice;
@end
