//
//  CLDEBetButton.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/29.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLDEBetButton : UIButton

@property (nonatomic, copy) void(^selectBetButtonBlock)(CLDEBetButton *);
@property (nonatomic, copy) void(^animationStopBlock)();
@property (nonatomic, strong) NSString *contentString;

@property (nonatomic, assign) BOOL scaleAnimation;//缩放动画
@property (nonatomic, assign) BOOL randomAnimation;//选中动画（随机选中时使用的动画）

@end
