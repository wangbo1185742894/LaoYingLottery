//
//  CLLaunchActivityManager.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/4/6.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLaunchActivityModel;
@interface CLLaunchActivityManager : NSObject

+ (void)saveLaunchActivityData;

+ (CLLaunchActivityModel *)getLaunchActivityImageData;

@end
