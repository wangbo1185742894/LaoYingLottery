//
//  BBBetDetailChuanGuanView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/16.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBBetDetailChuanGuanView : UIView
@property (nonatomic, copy) void(^buttonOnClickBlock)();

/**
 2串1是什么意思
 */
@property (nonatomic, copy) void(^twoChuanOneBlock)();

- (void)setChoosableChuanGuan;

@end
