//
//  SLMatchBetBottomView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//  投注列表 底部投注view

#import <UIKit/UIKit.h>

typedef void(^SLBetBottomBtnBlock)(UIButton *btn);

@interface SLMatchBetBottomView : UIView

@property (nonatomic, copy) SLBetBottomBtnBlock emptyBlock;

@property (nonatomic, copy) SLBetBottomBtnBlock sureBlock;


/**
 刷新底部UI
 */
- (void)reloadUI;

/**
 清空按钮点击事件
 */
- (void)returnEmpayClick:(SLBetBottomBtnBlock)block;

/**
 确定按钮点击事件
 */
- (void)returnSureClick:(SLBetBottomBtnBlock)block;

@end
