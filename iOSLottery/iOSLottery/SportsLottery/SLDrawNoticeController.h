//
//  SLDrawNoticeController.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/18.
//  Copyright © 2017年 caiqr. All rights reserved.
//  开奖公告 控制器

#import <UIKit/UIKit.h>

@interface SLDrawNoticeController : UIViewController

@property (nonatomic, strong) NSString *gameEn;

/**
 是否返回首页
 */
@property (nonatomic, assign) BOOL isBackHomeController;

@end
