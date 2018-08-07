//
//  CLBetDetailsTopView.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/11/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//  投注详情 顶部按钮 View

#import <UIKit/UIKit.h>

typedef void(^CLBetDetailsTopViewBlock)();

@interface CLBetDetailsTopView : UIView

@property (nonatomic, copy) CLBetDetailsTopViewBlock optionalBlock;

@property (nonatomic, copy) CLBetDetailsTopViewBlock randomBlock;

@property (nonatomic, copy) CLBetDetailsTopViewBlock clearBlock;

/**
 自选按钮回调block
 */
- (void)returnOptionalButtonBlock:(CLBetDetailsTopViewBlock)block;

/**
 机选按钮回调block
 */
- (void)returnRandomButtonBlock:(CLBetDetailsTopViewBlock)block;

/**
 清空按钮回调block
 */
- (void)returnClearButtonBlock:(CLBetDetailsTopViewBlock)block;

@end
