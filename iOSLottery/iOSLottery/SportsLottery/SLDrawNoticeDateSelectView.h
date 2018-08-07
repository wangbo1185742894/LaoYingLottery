//
//  CLSelectDateView.h
//  日期控制器
//
//  Created by 任鹏杰 on 2017/4/19.
//  Copyright © 2017年 任鹏杰. All rights reserved.
//  开奖公告日期筛选View

#import <UIKit/UIKit.h>


@interface SLDrawNoticeDateSelectView : UIView

/**
 数据数组
 */
@property (nonatomic, strong) NSArray *dataArray;

/**
 
 */
@property (nonatomic, strong) NSString *defaultSelectDate;

@property (nonatomic, copy) void(^sureBtnClock)(NSString *selectDate);

/**
 显示视图
 */
- (void)showInWindow;

@end
