//
//  CLFTBetFooterView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/15.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLFTBetFooterView : UIView

@property (nonatomic, copy) void(^clearButtonClickBlock)(BOOL isClear);//点击了清空按钮 或 机选按钮
@property (nonatomic, copy) void(^confirmButtonClickBlock)();//点击了确认按钮
- (void)assignBetNote:(NSInteger)note minBonus:(NSInteger)minBonus maxBonus:(NSInteger)maxBonus hasSelectBetButton:(BOOL)hasSelectBetButton playMothed:(NSInteger)playMothed;

@end
