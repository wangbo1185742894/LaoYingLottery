//
//  CKSocialAndThirdPayConfig.h
//  caiqr
//
//  Created by 洪利 on 2017/5/3.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>



static NSString *juheScheme = @"spaydemo";






@interface CKThirdPayConfig : NSObject

+ (void)resetUrlSchemesWithString:(NSString *)urlSchemes;

@end
