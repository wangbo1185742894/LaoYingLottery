//
//  CLFTThreeDiffererntDanBetView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/14.
//  Copyright © 2016年 caiqr. All rights reserved.
// 三不同胆拖

#import <UIKit/UIKit.h>
#import "CLFTBetViewDelegate.h"
@class CLFTDanThreeDifferentBetInfo;
@interface CLFTThreeDiffererntDanBetView : UIView <CLFTBetViewDelegate>

//UI相关
@property (nonatomic, copy) void(^danThreeDifferentBetBonusAndNotesBlock)(NSInteger, NSInteger , NSInteger);
//投注相关
@property (nonatomic, strong) CLFTDanThreeDifferentBetInfo *betInfo;//

@end
