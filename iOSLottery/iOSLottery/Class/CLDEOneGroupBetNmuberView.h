//
//  CLDEOneGroupBetNmuberView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/29.
//  Copyright © 2016年 caiqr. All rights reserved.
//封装 一组 11 个号码

#import <UIKit/UIKit.h>
@class CLDEBetButton;
@interface CLDEOneGroupBetNmuberView : UIView

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
@property (nonatomic, copy) void(^selectStateChangeBlock)(CLDEBetButton *);
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

- (void)setOmissionData:(NSArray *)omissionArray;
- (void)setDefaultOmission;
@end
