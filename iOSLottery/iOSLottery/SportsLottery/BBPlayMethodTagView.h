//
//  BBPlayMethodTagView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/7.
//  Copyright © 2017年 caiqr. All rights reserved.
//  篮球投注标签View

#import <UIKit/UIKit.h>

@interface BBPlayMethodTagView : UIView

/**
 设置标签文字
 */
- (void)setTagText:(NSString *)text;

/**
 设置标签文字颜色
 */
- (void)setTagTextColor:(UIColor *)textColor;

/**
 设置是否显示单关标签
 */
- (void)setShowTag:(BOOL)show;

@end
