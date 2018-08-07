//
//  UIResponder+CLRouter.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/18.
//  Copyright © 2017年 caiqr. All rights reserved.
//  响应者链传值

#import <UIKit/UIKit.h>

@interface UIResponder (CLRouter)

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;

@end
