//
//  CTFrameParserConfig.h
//  ModuleTest
//
//  Created by 彩球 on 16/7/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CTVerticalTextAlignment)
{
    CTTextVerticalAlignmentDefalut = 0,
    CTTextVerticalAlignmentTop,
    CTTextVerticalAlignmentCenter,
    CTTextVerticalAlignmentBottom,
};

@interface CTFrameParserConfig : NSObject

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, strong) UIColor* textColor;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) CTVerticalTextAlignment textVerAlignment;
@end
