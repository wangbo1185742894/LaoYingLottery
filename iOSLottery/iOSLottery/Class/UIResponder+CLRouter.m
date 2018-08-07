//
//  UIResponder+CLRouter.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/18.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "UIResponder+CLRouter.h"

@implementation UIResponder (CLRouter)

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    
    if (self.nextResponder) {
        
        [[self nextResponder] routerWithEventName:eventName userInfo:userInfo];
    }
}

@end
