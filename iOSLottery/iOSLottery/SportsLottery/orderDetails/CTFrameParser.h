//
//  CTFrameParser.h
//  ModuleTest
//
//  Created by 彩球 on 16/7/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"
#import "CTUnit.h"

/** 返回富文本高度 */
CGFloat CTContextHeight(NSArray<__kindof CTUnit*> * units, CTFrameParserConfig *config);

@interface CTFrameParser : NSObject

+ (CoreTextData*)parserCTUnits:(NSArray<__kindof CTUnit*> *)units config:(CTFrameParserConfig*)config;


@end
