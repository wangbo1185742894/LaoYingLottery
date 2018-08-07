//
//  SLBetDetailsTopView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/17.
//  Copyright © 2017年 caiqr. All rights reserved.
//  投注详情顶部View

#import <UIKit/UIKit.h>

typedef void(^SLBetDetailsTopBlock)();

@interface SLBetDetailsTopView : UIView

@property (nonatomic, strong) SLBetDetailsTopBlock editBlock;

@property (nonatomic, strong) SLBetDetailsTopBlock emptyBlock;


/**
 设置已选几场标题
 */
- (void)setisSelectNumber:(NSInteger)number;

- (void)setIsShowSelectNumber:(BOOL)show;


/**
 添加/编辑按钮点击事件
 */
- (void)returnEditClick:(SLBetDetailsTopBlock)block;

/**
 清空按钮点击事件
 */
- (void)returnEmptyClick:(SLBetDetailsTopBlock)block;

@end
