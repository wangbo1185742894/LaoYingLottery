//
//  CTUnit.h
//  ModuleTest
//
//  Created by 彩球 on 16/7/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CTUnitType)
{
    CTUnitTxtType,
    CTUnitImgType,
};

@interface CTUnit : NSObject

@property (nonatomic, assign) CTUnitType type;

@property (nonatomic, strong) id content;

//洪利添加 传入imageName
@property (nonatomic, strong) NSString *imageName;
//传入 imageFrame image 塞入的位置
@property (nonatomic, assign) CGRect imageRect;
//洪利修改传入关键字数组
@property (nonatomic, strong) NSArray *keyWordsArray;
//传入关键字颜色
@property (nonatomic, strong) UIColor *keyWordsColor;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) CGFloat fontSize;

@property (nonatomic, assign) BOOL link;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat width;

@end
