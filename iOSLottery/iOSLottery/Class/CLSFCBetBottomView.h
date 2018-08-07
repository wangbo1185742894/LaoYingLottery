//
//  CLSFCBetBottomView.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/26.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CLSFCBetBottomBlock)(UIButton *btn);

@interface CLSFCBetBottomView : UIView

@property (nonatomic, copy) CLSFCBetBottomBlock emptyBlock;

@property (nonatomic, copy) CLSFCBetBottomBlock sureBlock;


/**
 刷新底部UI
 */
- (void)reloadUI;

/**
 清空按钮点击事件
 */
- (void)returnEmpayClick:(CLSFCBetBottomBlock)block;

/**
 确定按钮点击事件
 */
- (void)returnSureClick:(CLSFCBetBottomBlock)block;

@end
