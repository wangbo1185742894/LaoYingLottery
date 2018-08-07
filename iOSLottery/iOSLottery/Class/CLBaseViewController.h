//
//  CLBaseViewController.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLConfigMessage.h"
#import "CLBaseNavigationViewController.h"
#import "UIViewController+CLControlUnit.h"


@interface CLBaseViewController : UIViewController

@property (nonatomic) BOOL hideNavigationBar;

@property (nonatomic, strong) NSString *navTitleText;

@property (nonatomic, strong) NSString *pageStatisticsName;//页面统计name


- (id)initWithRouterParams:(NSDictionary *)params;

- (void)ViewContorlBecomeActive:(NSNotification *)notification;
@end
