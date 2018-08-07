//
//  CQUpDownAligmentLabel.h
//  caiqr
//
//  Created by huangyuchen on 16/7/23.
//  Copyright © 2016年 Paul. All rights reserved.
//可以设置文字  上 中 下位置

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CQVerticalAlignmentType) {
    CQVerticalAlignmentTypeTop = 0,
    CQVerticalAlignmentTypeMiddle = 1,
    CQVerticalAlignmentTypeBottom
};

@interface CQUpDownAligmentLabel : UILabel

@property (nonatomic, assign) CQVerticalAlignmentType verticalAlignmentType;
@property (nonatomic, assign) NSTextAlignment horizontalAlignmentType;

@property (nonatomic, assign) CGFloat labelLineSpacing;


@end
