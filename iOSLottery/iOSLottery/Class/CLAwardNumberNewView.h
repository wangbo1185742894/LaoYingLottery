//
//  CLAwardNumberNewView.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/4/24.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLAwardNumberNewView : UIView

//红色小球的宽高默认 27
@property (nonatomic, assign) CGFloat ballWidthHeight;

@property (nonatomic, strong) UIColor *ballColor;

@property (nonatomic, strong) NSArray* numbers;

/**
 红色小球的间距 必须声明在numbers之前 否则不生效
 */
@property (nonatomic, assign) CGFloat space;

@end
