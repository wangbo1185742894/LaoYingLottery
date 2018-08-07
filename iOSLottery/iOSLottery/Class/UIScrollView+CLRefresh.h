//
//  UIScrollView+CLRefresh.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (CLRefresh)

/**
 是否显示刷新

 @param shows yes or no
 */
- (void)showsRefresh:(BOOL)shows;

/**
 是否显示上拉加载

 @param shows yes or no
 */
- (void)showsLoading:(BOOL)shows;
/**
 开启刷新动画
 */
- (void)startRefreshAnimating;

/**
 停止刷新动画
 */
- (void)stopRefreshAnimating;

/**
 开启上拉加载动画
 */
- (void)startLoadingAnimating;

/**
 停止上拉加载动画
 */
- (void)stopLoadingAnimating;

/**
 重置没有更多数据
 */
- (void)resetNoMoreData;
/**
 没有更多数据 停止上拉加载动画
 */
- (void)stopLoadingAnimatingWithNoMoreData;
/**
 刷新事件

 @param refreshAction 刷新事件
 */
- (void)addRefresh:(void(^)(void))refreshAction;

/**
 加载事件

 @param loadingAction 加载事件
 */
- (void)addLoading:(void(^)(void))loadingAction;

@end
