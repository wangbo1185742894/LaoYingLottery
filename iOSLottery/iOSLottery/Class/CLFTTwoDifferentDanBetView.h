//
//  CLFTTwoDifferentDanBetView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLFTBetViewDelegate.h"
@class CLFTDanTwoDifferentBetInfo;
@interface CLFTTwoDifferentDanBetView : UIView <CLFTBetViewDelegate>

//UI相关
@property (nonatomic, copy) void(^danTwoDifferentBetBonusAndNotesBlock)(NSInteger, NSInteger , NSInteger);
//投注相关
@property (nonatomic, strong) CLFTDanTwoDifferentBetInfo *betInfo;//

@end
