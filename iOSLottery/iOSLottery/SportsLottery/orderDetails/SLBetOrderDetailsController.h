//
//  CQBetOrderDetailViewController.h
//  caiqr
//
//  Created by huangyuchen on 16/7/22.
//  Copyright © 2016年 Paul. All rights reserved.
//  投注订单详情页
/**
 需要跳转该页面的类：
 "CQAppPopOrderAwardView.h"  中奖动画
 "CQCardFrontBindViewController.h" 卡前置 添加银行卡页面
 "CQUserOrderPayMentViewController.h" 真票支付页面
 "CQUserRecordDetailViewController.h" 用户账号记录详情，红包记录详情
 "CQUserRedPacketsConsumeViewController.h" 用户红包消费记录
 "CQSportBetRecordViewController.h" 真票投注记录

 */

#import <UIKit/UIKit.h>

@interface SLBetOrderDetailsController : UIViewController

@property (nonatomic, strong) NSString *order_ID;

@end
