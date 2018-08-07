//
//  CLSFCBetOption.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/26.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLSFCBetOption : UIButton

@property (nonatomic, assign) BOOL showLeftLine;
@property (nonatomic, assign) BOOL showRightLine;
@property (nonatomic, assign) BOOL showTopLine;
@property (nonatomic, assign) BOOL showBottomLine;

- (void)setPlayName:(NSString *)str;

/**
 设置正常状态下的颜色
 */
- (void)setNormalColor:(UIColor *)color;

@end
