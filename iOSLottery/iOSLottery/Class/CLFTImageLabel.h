//
//  CLFTImageLabel.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//
// 封装 带背景的图的标签
#import <UIKit/UIKit.h>

@interface CLFTImageLabel : UIView

@property (nonatomic, strong) NSString *contentString;
@property (nonatomic, strong) UIImage *backImage;//背景图
@property (nonatomic, strong) UIFont *contentFont;//文字 字体 大小
@property (nonatomic, strong) UIColor *contentColor;//文字 颜色
@property (nonatomic, copy) void(^onClickBlock)();

@end
