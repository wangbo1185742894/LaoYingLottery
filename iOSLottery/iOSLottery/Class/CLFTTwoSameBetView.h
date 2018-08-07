//
//  CLFTTwoSameBetView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//二同号

#import <UIKit/UIKit.h>
#import "CLFTBetViewDelegate.h"
@class CLFTTwoSameSingleBetInfo;
@class CLFTTwoSameDoubleBetInfo;
@interface CLFTTwoSameBetView : UIView <CLFTBetViewDelegate>

//UI相关
@property (nonatomic, copy) void(^twoSameBetBonusAndNotesBlock)(NSInteger, NSInteger , NSInteger);
//投注相关
@property (nonatomic, strong) CLFTTwoSameSingleBetInfo *singleBetInfo;//通选
@property (nonatomic, strong) CLFTTwoSameDoubleBetInfo *doubleBetInfo;//单选
//摇一摇
- (void)configRandomDice;
@end
