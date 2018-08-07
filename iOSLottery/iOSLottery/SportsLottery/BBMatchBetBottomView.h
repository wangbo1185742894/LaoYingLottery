//
//  BBMatchBetBottomView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//  篮球投注 底部投注View

#import <UIKit/UIKit.h>

@interface BBMatchBetBottomView : UIView

typedef void(^BBBetBottomBlock)(UIButton *btn);

@property (nonatomic, copy) BBBetBottomBlock emptyBlock;

@property (nonatomic, copy) BBBetBottomBlock sureBlock;


/**
 刷新底部UI
 */
- (void)reloadUI;

/**
 清空按钮点击事件
 */
- (void)returnEmpayClick:(BBBetBottomBlock)block;

/**
 确定按钮点击事件
 */
- (void)returnSureClick:(BBBetBottomBlock)block;

@end
