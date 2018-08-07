//
//  CLATDrawNoticView.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLAwardVoModel;

@interface CLATDrawNoticeView : UIView

- (void)setData:(CLAwardVoModel *)data;

/**
 是否显示彩种名
 */
- (void)setShowLotteryName:(BOOL)show;

/**
 是否只显示文字
 */
- (void)setOnlyShowNumberText:(BOOL)show;


/**
 是否居中显示
 */
- (void)setShowInCenter:(BOOL)show;

@end
