//
//  CLFTBetHeaderView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/15.
//  Copyright © 2016年 caiqr. All rights reserved.
//快三 头部视图

#import <UIKit/UIKit.h>

@interface CLFTBetHeaderView : UIView

@property (nonatomic, strong) NSString *gameEn;

@property (nonatomic, copy) void(^tapHeadViewBlock)();

/**
 刷新数据
 */
- (void)reloadDataForFTBetHeaderView;

/**
 向下箭头 转动
 
 @param isRotation 是否转动
 */
- (void)arrowImageViewIsRotation:(BOOL)isRotation;
@end

//头部视图的左侧部分
@interface CLFTBetHeaderLeftView : UIView

//显示等待开奖
- (void)showWaitAwardWithPeriod:(NSString *)period;
//显示开奖动画
- (void)showAwardAnimationWithAwardNumber:(NSString *)awardNumber period:(NSString *)period;
//箭头动画
- (void)arrowImageViewIsRotation:(BOOL)isRotation;
@end
//头部视图的右侧部分
@interface CLFTBetHeaderRightView : UIView

@property (nonatomic, strong) NSString *peroid;//当前期次
@property (nonatomic, assign) NSInteger timeNumber;//当前期次的倒计时

/**
 当前期次的总倒计时  赋值需要在timerNumber之前，否则不生效
 */
@property (nonatomic, assign) NSInteger allTime;//当前期次的总倒计时
@end
