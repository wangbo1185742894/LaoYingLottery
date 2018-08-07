//
//  CLPushActionManager.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/6/2.
//  Copyright © 2017年 caiqr. All rights reserved.
// 推送消息 事件 管理  控制推送或外链跳转事件的时间点

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CLPushActionManager : NSObject

/**
 标记当前客户端是否是从杀死状态下启动
 */
@property (nonatomic, assign) BOOL isStart;

@property (nonatomic, strong) NSString *pushUrl;

+ (instancetype)sharePushActionManager;

- (void)pushUrlWithUrl:(NSString *)pushUrl;

@end
