//
//  CLOneGroupBallView.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/1.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLLotteryBallView;
@interface CLOneGroupBallView : UIView

- (CLOneGroupBallView *)initWithFrame:(CGRect)frame ballCount:(NSInteger)count ballColor:(UIColor *)color;

/**
 最多选中个数
 */
@property (nonatomic, assign) NSInteger maxSelectedCount;

/**
 需要弹窗提示
 */
@property (nonatomic, copy) void(^needShowHUDBlock)();

/**
 有选中按钮的选中状态发生了改变
 */
@property (nonatomic, copy) void(^selectStateChangeBlock)(CLLotteryBallView *);

- (CGFloat)getOneGroupBallVeiwHeightWithCount:(NSInteger)interger;

/**
 随机选号
 @param selectNumberArray 需要动画的号码
 @return 返回需要动画的按钮
 */
- (NSArray *)randomSelectNumberWithArray:(NSArray *)selectNumberArray;

/**
 改变需要互斥的按钮选中状态
 
 @param tag 需要改变的tag
 */
- (void)changeMutualExclusionBetButton:(NSInteger)tag;


/**
 选中对应tag值的按钮
 
 @param tag tag值
 */
- (void)selectBetButtonWithTag:(NSInteger)tag;

- (void)clearAllBet;

#pragma mark - 配置默认遗漏信息
- (void)setDefaultOmission;
#pragma mark - 配置遗漏信息
- (void)assignOmissionData:(NSArray *)dataArray;
#pragma mark - 展示或隐藏遗漏
- (void)hiddenOmissionView:(BOOL)hidden;
@end
