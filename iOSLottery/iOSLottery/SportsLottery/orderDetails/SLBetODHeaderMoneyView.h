//
//  CQBetODHeaderMoneyView.h
//  caiqr
//
//  Created by huangyuchen on 16/7/22.
//  Copyright © 2016年 Paul. All rights reserved.
//
//投注订单详情页的头部视图中的 显示金额一行的视图

#import <UIKit/UIKit.h>

@interface SLBetODHeaderMoneyView : UIView

- (void)assignHeaderMoneyWithData:(id)data;

@property (nonatomic, copy) void(^continuePayBlock)(UIButton *);
@property (nonatomic, copy) void(^awarImageViewCilck)();
@property (nonatomic, copy) void(^notWinImageViewClick)();
@property (nonatomic, assign) BOOL isFirstAllocView;//标记是否第一次创建视图，第一次创建时中奖图片有动画效果
//重置图片 停止动画
- (void)resetImageAndStatus:(NSString *)dyImage bgImage:(NSString *)bgImage;

- (void)stopTimer;
@end
