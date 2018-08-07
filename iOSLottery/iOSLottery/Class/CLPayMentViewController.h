//
//  CLPayMentViewController.h
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseViewController.h"
typedef NS_ENUM(NSInteger , CLPayMentType) {
    
    CLPayMentTypeNormal = 0, //正常支付
    CLPayMentTypeQuick //快速支付
};

typedef NS_ENUM(NSInteger, CLOrderType) {
    
    CLOrderTypeNormal = 0,
    CLOrderTypeFollow
};

typedef NS_ENUM(NSInteger, CLPayPushType) {
    
    CLPayPushTypeBet, // 从投注页面跳转
    CLPayPushTypeOrderAndFollow //从订单页面跳转
};

@interface CLPayMentViewController : CLBaseViewController

@property (nonatomic, strong) NSString *lotteryGameEn;
@property (nonatomic, strong) NSString *period;
@property (nonatomic, assign) NSInteger periodTime;
@property (nonatomic, assign) CLPayPushType pushType;//倒计时结束后跳转页面类型
@property (nonatomic, assign) CLPayMentType payMentType;//支付类型
@property (nonatomic, assign) NSInteger payAccount;//支付金额
@property (nonatomic, assign) CLOrderType orderType;
@property (nonatomic, strong) id payConfigure;
@property (nonatomic, copy) void(^cancelQuickPayBlock)();

@end
