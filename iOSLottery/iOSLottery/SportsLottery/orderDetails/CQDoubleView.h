//
//  CQDoubleView.h
//  caiqr
//
//  Created by huangyuchen on 16/7/23.
//  Copyright © 2016年 Paul. All rights reserved.
//自带左右两个label  可设置左右间距 文字属性 或者自定义左右视图

#import <UIKit/UIKit.h>
#import "CQUpDownAligmentLabel.h"

@interface CQDoubleView : UIView
//左右View之间的间距
@property (nonatomic, assign) CGFloat leftRightDistance;

/**
 *  左侧label相关属性
 */
@property (nonatomic, strong) CQUpDownAligmentLabel *leftLabel;
@property (nonatomic, strong) NSString *leftLabelTitle;
@property (nonatomic, strong) UIFont *leftFont;
@property (nonatomic, assign) NSTextAlignment leftTextAlignment;
@property (nonatomic, strong) UIColor *leftTextColor;
@property (nonatomic, assign) CGFloat leftLineSpacing;

/**
 *  右侧label相关属性
 */
@property (nonatomic, strong) CQUpDownAligmentLabel *rightLabel;
@property (nonatomic, strong) NSString *rightLabelTitle;
@property (nonatomic, strong) UIFont *rightFont;
@property (nonatomic, assign) NSTextAlignment rightTextAlignment;
@property (nonatomic, strong) UIColor *rightTextColor;
@property (nonatomic, assign) CGFloat rightLineSpacing;

//左右View的子视图
@property (nonatomic, strong) UIView *leftSubView;
@property (nonatomic, strong) UIView *rightSubView;

@end
