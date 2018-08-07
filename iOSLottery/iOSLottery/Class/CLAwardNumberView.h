//
//  CLAwardNumberView.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLAwardNumberView : UIView

//红色小球的宽高默认 27
@property (nonatomic, assign) CGFloat ballWidthHeight;

@property (nonatomic, strong) UIColor *ballColor;

@property (nonatomic, strong) NSArray* numbers;

/**
 红色小球的间距 必须声明在numbers之前 否则不生效
 */
@property (nonatomic, assign) CGFloat space;

/**
 是否只显示文字
 */
@property (nonatomic, assign) BOOL onlyShowText;

/**
 是否显示两位数
 */
@property (nonatomic, assign) BOOL showTwoPlaces;

@end
