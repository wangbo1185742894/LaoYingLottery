//
//  CKNewPayViewController.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/5/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLBaseViewController.h"

typedef NS_ENUM(NSInteger, CKOrderType) {
    
    CKOrderTypeNormal = 0, //普通订单
    CKOrderTypeFollow,//追号订单
    CKOrderTypeJC//竞彩
};

typedef NS_ENUM(NSInteger, CKPayPushType) {
    
    CKPayPushTypeBet, // 从投注页面跳转
    CKPayPushTypeOrderAndFollow //从订单页面跳转
};

@interface CKNewPayViewController : CLBaseViewController

@property (nonatomic, assign) BOOL hasNotPeriodTime;//是否不含有倒计时
@property (nonatomic, strong) NSString *lotteryGameEn;
@property (nonatomic, strong) NSString *period;
@property (nonatomic, assign) NSInteger periodTime;
@property (nonatomic, assign) CKPayPushType pushType;//倒计时结束后跳转页面类型
@property (nonatomic, assign) CKOrderType orderType;
@property (nonatomic, strong) id payConfigure;

@end
