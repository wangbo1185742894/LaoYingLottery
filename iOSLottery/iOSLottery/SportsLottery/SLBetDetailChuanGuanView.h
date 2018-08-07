//
//  SLBetDetailChuanGuanView.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/19.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLBetDetailChuanGuanView : UIView

@property (nonatomic, copy) void(^buttonOnClickBlock)();

/**
 2串1是什么意思
 */
@property (nonatomic, copy) void(^twoChuanOneBlock)();

- (void)setChoosableChuanGuan;

@end
