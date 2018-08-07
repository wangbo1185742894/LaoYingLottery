//
//  CLCheckTokenManager.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/27.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLCheckTokenManager : NSObject

@property (nonatomic, copy) void(^destroyCheckTokenManager)();

- (void)checkUserToken;

@end
