//
//  CoreTextData.h
//  ModuleTest
//
//  Created by 彩球 on 16/7/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "CoreTextImageData.h"

@interface CoreTextData : NSObject

@property (nonatomic, assign) CTFrameRef ctFrame;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CTTextAlignment textAlignment;

@property (nonatomic, strong) NSArray<__kindof CoreTextImageData*> *imageArray;

@end
