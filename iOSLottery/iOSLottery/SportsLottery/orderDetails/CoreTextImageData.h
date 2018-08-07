//
//  CoreTextImageData.h
//  ModuleTest
//
//  Created by 彩球 on 16/7/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface CoreTextImageData : NSObject

@property (nonatomic, strong) NSString* imgName;

@property (nonatomic, assign) NSUInteger position;

@property (nonatomic, assign) CGRect imagePosition;

@end
