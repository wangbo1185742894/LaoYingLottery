//
//  CLFTTwoDifferentBetView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//二不同号

#import <UIKit/UIKit.h>
#import "CLFTBetViewDelegate.h"
@class CLFTTwoDifferentBetInfo;
@interface CLFTTwoDifferentBetView : UIView <CLFTBetViewDelegate>

//UI相关
@property (nonatomic, copy) void(^twoDifferentBetBonusAndNotesBlock)(NSInteger, NSInteger , NSInteger);
//投注相关
@property (nonatomic, strong) CLFTTwoDifferentBetInfo *betInfo;//
//摇一摇
- (void)configRandomDice;
@end
