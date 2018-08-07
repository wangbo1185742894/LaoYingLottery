//
//  CQMarqueeView.h
//  caiqr
//
//  Created by huangyuchen on 16/9/1.
//  Copyright © 2016年 Paul. All rights reserved.
//跑马灯 的动画的View

#import <UIKit/UIKit.h>

@interface CQMarqueeView : UIView

@property (nonatomic, assign) BOOL marqueeAutoLoop;
@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, assign) BOOL hiddenRightArrow;
@property (nonatomic, strong) UIImage *marqueeIMG;
@property (nonatomic, copy) void(^tapOnClickBlock)(NSInteger);

+ (instancetype)shareMarqueeViewWithFrame:(CGRect)frame;
@end
