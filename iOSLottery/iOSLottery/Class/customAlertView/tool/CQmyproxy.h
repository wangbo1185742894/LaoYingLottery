//
//  CQmyproxy.h
//  caiqr
//
//  Created by 洪利 on 2017/3/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQCommonAlterControl.h"
@interface CQmyproxy : NSProxy<CQAlterControlDelegate>

+ (instancetype)dealerProxy;

@end
