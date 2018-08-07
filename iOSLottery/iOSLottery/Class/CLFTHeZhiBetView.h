//
//  CLFastThreeBetView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/13.
//  Copyright © 2016年 caiqr. All rights reserved.
//
//快三 投注 和值页
#import <UIKit/UIKit.h>
#import "CLFTBetViewDelegate.h"
@class CLFTHeZhiBetInfo;
@interface CLFTHeZhiBetView : UIView <CLFTBetViewDelegate>
//UI相关
@property (nonatomic, copy) void(^heZhiBetBonusAndNotesBlock)(NSInteger, NSInteger , NSInteger);
//投注相关
@property (nonatomic, strong) CLFTHeZhiBetInfo *betInfo;//
//摇一摇
- (void)configRandomDice;


@end
