//
//  CLWebViewActivityViewController.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/4.
//  Copyright © 2017年 caiqr. All rights reserved.
//
/**
 *  活动webViewController
 *  焦点图、活动弹窗、订单详情 跳转
 *
 */
#import "CLBaseViewController.h"

@interface CLWebViewActivityViewController : CLBaseViewController

@property (nonatomic, copy) void(^callback)(void);

@property (nonatomic, strong) NSString* activityUrlString; //入参url

@end
