//
//  CLLotteryBetView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//  所有彩种点选投注项的主View  自带下拉功能

#import <UIKit/UIKit.h>
@protocol CLLotteryBetViewDelegate <NSObject>
@optional

- (UIView *)lotteryBetViewCustomHeaderView;//自定制 头部视图
- (UIView *)lotteryBetViewCustomBetView;//自定制 投注页面
- (UIView *)lotteryBetViewCustomAwardRecordView;//自定制 开奖记录
- (UIView *)lotteryBetViewCustomFooterView;//自定制 底部视图
- (UIView *)lotteryBetViewCustomPlayMothedView;//自定制 玩法筛选View

@end

@interface CLLotteryBetView : UIView

/**
 玩法选择页面展示与隐藏的回调
 */
@property (nonatomic, copy) void(^playMothedViewIsShowBlock)(BOOL);

/**
 底部开奖页面是否隐藏和显示
 */
@property (nonatomic, copy) void(^bottomViewIsShowBlock)(BOOL);

/**
 上层视图 偏移大小
 */
@property (nonatomic, assign) CGFloat mainViewOffset;
@property (nonatomic, weak) id <CLLotteryBetViewDelegate> delegate;
@property (nonatomic, assign) BOOL is_showPlayMothed;//是否展示选择玩法
@property (nonatomic, assign) BOOL is_showBottomView;//是否展示底部视图
@property (nonatomic, assign) BOOL mainViewShowStatus;//3.1.0添加，隐藏上层红篮球只展示开奖历史

- (void)lotteryBetViewReloadData;//刷新（类似 tableView的reloaddata）

@end
