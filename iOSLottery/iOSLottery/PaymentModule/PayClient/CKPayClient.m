//
//  CKPayClient.m
//  iOSLottery
//
//  Created by 彩球 on 17/4/18.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CKPayClient.h"
#import "CKPaymentBaseSource.h"

#import "CKSportsBetPaymentHandler.h"
#import "CKPayWebsite.h"


#import "CKtempClass.h"
#import "CKFOPpaymentService.h"

#import "CKPaymentVerifyCallBackInterface.h"
#import "SPayClient.h"
#define CKPayClientPayMentFlag @"caiqrPayment"



@interface CKPayClient ()


@property (nonatomic, strong) UIWebView* vv;
@end

@implementation CKPayClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isSDKPayment = NO;
        //添加后台切换至前台通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(ViewContorlBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

+ (CKPayClient *)sharedManager
{
    static CKPayClient *sharedPayClientHandlerManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedPayClientHandlerManagerInstance = [[self alloc] init];
    });
    return sharedPayClientHandlerManagerInstance;
}


+ (void)setPayIntermediary:(Class)class {
    
    [CKPayClient sharedManager].intermediary = [[class alloc] init];
}

+ (CKPayChannelVerifyType)checkPayTypeOfChannel:(id<CKPaychannelDataInterface>)channel {
    
    BOOL userPayPwd = [channel channel_need_pay_pwd];
    BOOL userVerify = [channel channel_need_real_name];
    BOOL cardFront = [channel channel_need_card_bin];
    
    
    return (((userPayPwd)?CKPayChannelVerifyTypePayPwd:0) | ((userVerify && (![[CKPayClient sharedManager].intermediary authRealNameStatus]))?CKPayChannelVerifyTypeRealName:0) | ((cardFront)?CKPayChannelVerifyTypeCardFront:0) | (([channel isVIP])?CKPayChannelVerifyTypeVIPService:0) ) ;
}

+ (void) startPay {
    
    BOOL ret = [CKPayClient checkThirdApp];
    if (!ret) return; //检测到未安装第三方客户端
    
    
    CKPayChannelVerifyType type = [CKPayClient checkPayTypeOfChannel:[CKPayClient sharedManager].channel];
  
    if (type & CKPayChannelVerifyTypeVIPService) {
        //VIP 打电话
        NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4006892227"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        return;
    }
  
    if (type & CKPayChannelVerifyTypeCardFront) {
        //卡前置
        UIViewController<CKPaymentVerifyCallBackInterface>* viewContro = [[CKPayClient sharedManager].intermediary cardFrontViewController];
        [viewContro verifySuccessForMethod:^(id info) {
            [CKPayClient cardFrontFinish:info];
        }];
        [viewContro setPersonalPaymentSource:[CKPayClient sharedManager].source];
        [[CKPayClient sharedManager].launchViewController.navigationController pushViewController:viewContro animated:YES];
        [CKPayClient sharedManager].isSDKPayment = YES;
        return;
    }
    
    if (type & CKPayChannelVerifyTypeRealName) {
        //实名
        UIViewController<CKPaymentVerifyCallBackInterface>* viewContro = [[CKPayClient sharedManager].intermediary realNameViewController];
        [viewContro verifySuccessForMethod:^(id info) {
            [CKPayClient realFinish];
        }];
        [[CKPayClient sharedManager].launchViewController.navigationController pushViewController:viewContro animated:YES];
        [CKPayClient sharedManager].isSDKPayment = YES;
        return;
    }
    
    [CKPayClient launchPay];

}

+ (void)realFinish {
    NSLog(@"实名认证完成....");
    [CKPayClient startPay];
    
}

+ (void)cardFrontFinish:(id)info {
    //设置银行卡
    
    [CKPayClient launchPay];
}

+ (void) launchPay {
    
    __weak CKPayClient* _weakSelf = [CKPayClient sharedManager];
    [CKPayClient sharedManager].source.startNativeRequest = ^{
        [_weakSelf launchNativeRequest];
    };
    
    [CKPayClient sharedManager].source.endNativeRequest = ^(BOOL reqState,NSString* errorMsg) {
        
        [_weakSelf overNativeRequestState:reqState msg:errorMsg];
    };
    
    [CKPayClient sharedManager].source.callBackH5Pay = ^(NSDictionary* params) {
        [_weakSelf gotoH5PayWithParams:params];
    };
    
    [CKPayClient sharedManager].source.callBackSDKPay = ^(NSInteger pay_channel_key, NSString* payForToken,NSDictionary* params) {
        [_weakSelf gotoSDKPayWithChannelKey:pay_channel_key payForToken:payForToken params:params];
    };
    /** 重置SDK支付标志 */
    [CKPayClient sharedManager].isSDKPayment = NO;
    
    [[CKPayClient sharedManager].source runPayment];

}


- (void) launchNativeRequest {
    
    NSLog(@"客户端内部请求开始");
    if ([self.delegate respondsToSelector:@selector(ck_PayClinetStartPayment)]) {
        [self.delegate ck_PayClinetStartPayment];
    }
    
}

- (void) overNativeRequestState:(BOOL) state msg:(NSString*)msg {
    
    NSLog(@"客户端内部请求结束 state:%zi msg:%@",state,msg);
    if (!state) {
        //失败
        UINavigationController* navi = [CKPayClient sharedManager].launchViewController.navigationController;
        if (navi && [navi isKindOfClass:UINavigationController.class]) {
            [navi popToViewController:[CKPayClient sharedManager].launchViewController animated:NO];
        }
        
    }
    if ([self.delegate respondsToSelector:@selector(ck_payClientEndPaymentWithReqState:message:)]) {
        [self.delegate ck_payClientEndPaymentWithReqState:state message:msg];
    }
}

- (void) gotoH5PayWithParams:(NSDictionary *)params {
    
    self.didStartPayMent = YES;
    self.isNeedHandleException = YES;
    NSMutableDictionary* pa = [NSMutableDictionary dictionaryWithDictionary:params];
    
    if ([self.intermediary token].length > 0) {
        [pa setObject:[self.intermediary token] forKey:@"token"];
    }
    
    /* 验证方式包含支付密码验证*/
    
    if ([self.channel channel_need_pay_pwd]) {
        CKSafariOpenPayPwdStatus payPwdStatus = CKSafariOpenPayPwdNeedCheckValidStatus;
        if (![self.intermediary ownPayPwdStatus]) {
            payPwdStatus = CKSafariOpenPayPwdSettingStatus;//设置
        } else {
            if ([self.intermediary freePaypwdStatus]) {
                long long payMoney = [params[@"totalamount"] longLongValue];
                payPwdStatus = (payMoney > [self.intermediary freePaypwdQuota])?CKSafariOpenPayPwdNeedCheckValidStatus:CKSafariOpenPayPwdNotCheckStatus;
            } else {
                payPwdStatus = CKSafariOpenPayPwdNeedCheckValidStatus;
            }
        }
        [pa setObject:[NSString stringWithFormat:@"%zi",payPwdStatus] forKey:@"paypwdstatus"];
    }
    
    //设置账户余额
//    if (channelType == paymentChannelTypeAccountBalance) {
        [pa setObject:[NSString stringWithFormat:@"%.f",[self.intermediary accountBalance]] forKey:@"accountbalance"];
//    }
    
    //增加支付跳出时间点事件回调 ISSUE #4
    __weak CKPayClient* _weakSelf = self;
    [CKPayWebsite websitePaymentWithInfo:pa transitionType:self.source.transitionType h5Prefix:self.source.url_prefix intermediary:self.intermediary complete:^{
        
        if ([_weakSelf.delegate respondsToSelector:@selector(ck_didPayment)]) {
            [_weakSelf.delegate ck_didPayment];
        }
    }];
}

- (void) gotoSDKPayWithChannelKey:(NSInteger)key payForToken:(NSString*)payForToken params:(NSDictionary*)param{
    
    self.didStartPayMent = YES;
    
    if (key != 503 && key != 504 && key != 121) {
        self.isNeedHandleException = YES;
        [self gotoH5PayWithParams:param];
        return;
    }
    [CKPayClient sharedManager].isSDKPayment = YES;
    __weak CKPayClient *weakSelf = self;
    CKtempClass *temoClass =  [[CKtempClass alloc] init];
    
    [temoClass                         startPay:key
                                         anoumt:param[@"totalamount"]
                                   andOrderInfo:payForToken
                                 viewController:self.launchViewController
                          isNeedHandleException:^(BOOL isNeedHandleException) {
                              
                              weakSelf.isNeedHandleException = isNeedHandleException;
                              
                          } payFinish:^{
                              
                              [weakSelf openUrl:[NSURL URLWithString:@"thirdpay"]];
                              
                          } willStartPayMent:^{
                              
                              if ([weakSelf.delegate respondsToSelector:@selector(ck_didPayment)]) {
                                  [weakSelf.delegate ck_didPayment];
                              }
    }];
    
    NSLog(@"启用sdk支付  sdk_id :%zi token: %@",key,payForToken);
    
 
}


+ (BOOL)checkThirdApp {
    
    //    判断支付渠道是否支持
    if ([CKPayClient sharedManager].source.channel_type == 5) {
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
            //暂未安装微信客户端
            [[CKPayClient sharedManager].intermediary showError:@"该设备没有检测到微信"];
            [CKPayClient sharedManager].isSDKPayment = YES;
            return NO;
        }
    }
    
    if ([CKPayClient sharedManager].source.channel_type == 12) {
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
            //暂未安装支付宝客户端
            [[CKPayClient sharedManager].intermediary showError:@"该设备没有检测到支付宝"];
            [CKPayClient sharedManager].isSDKPayment = YES;
            return NO;
        }
    }
    
    if ([CKPayClient sharedManager].source.channel_type == 11) {
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            //暂未安装QQ客户端
            [[CKPayClient sharedManager].intermediary showError:@"该设备没有检测到QQ"];
            [CKPayClient sharedManager].isSDKPayment = YES;
            return NO;
        }
    }
    
    return YES;
}


#pragma mark - becomactive
- (void)ViewContorlBecomeActive:(NSNotificationCenter*)notification {
    //如果从支付跳出并且需要手动处理异常
    if (self.didStartPayMent && self.isNeedHandleException) {
        self.isExceptionCallback = YES;
        [CKPayClient sharedManager].didStartPayMent = NO;
        [self openUrl:nil];
    }
}

#pragma mark - open url


+ (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options
{
    [CKPayClient sharedManager].isExceptionCallback = NO;
    [CKPayClient sharedManager].didStartPayMent = NO;
    /* 通过url  判断是否是 */
    /* 如果支付使用的channel_id不是聚合支付 那么正常使用openUrl方式，如果是则不能处理openUrl */
    NSInteger s = [[[CKPayClient sharedManager] channel] channel_id];
    BOOL ret = (s != 504)?YES:NO;
    return ret?[[CKPayClient sharedManager] openUrl:url]:YES;
}


+ (BOOL)application:(UIApplication *)application openURL:(NSURLAuthenticationChallenge *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [CKPayClient sharedManager].isExceptionCallback = NO;
    [CKPayClient sharedManager].didStartPayMent = NO;
    /* 如果支付使用的channel_id不是聚合支付 那么正常使用openUrl方式，如果是则不能处理openUrl */
    NSInteger s = [[[CKPayClient sharedManager] channel] channel_id];
    BOOL ret = (s != 504)?YES:NO;
    return ret?[[CKPayClient sharedManager] openUrl:url]:YES;
}

+ (void)applicationWillEnterForeground:(UIApplication *)app{
    [CKPayClient sharedManager].isExceptionCallback = YES;
    [[SPayClient sharedInstance] applicationWillEnterForeground:app];
}

- (BOOL) openUrl:(NSURL*)url {

    UINavigationController* navi = [CKPayClient sharedManager].launchViewController.navigationController;
    if (navi && [navi isKindOfClass:UINavigationController.class]) {
        [navi popToViewController:[CKPayClient sharedManager].launchViewController animated:NO];
    }

    NSString* scheme = [url scheme];
    if ([scheme isEqualToString:[self.intermediary urlScheme]]) {
        BOOL ret = [CKPayWebsite checkPageValidUrl:url];
        if (ret) {
        }
        [self payFinished:url];
        
        return ret;
    } else {
        //第三方回调
        [self payFinished:nil];
        return YES;
    }
}


//支付结束 执行小额免密流程
- (void)payFinished:(id)obj{
    
    /** 如果未设置支付密码 回调设置支付密码 */
    if (![self.intermediary ownPayPwdStatus]) {
        void(^setPWDBlock)(void) = [self.intermediary pamentNoSetPwdBack];
        setPWDBlock?setPWDBlock():nil;
    }
    //使用支付密码的渠道，需要执行小额免密流程,不需要的直接返回
    [CKFOPpaymentService isAlreadyFreeOfPayServiceIfNeedPassword:[self.channel channel_need_pay_pwd] weakViewController:self.launchViewController block:^(id contentobj){
        
        /** 更新用户小额状态 */
        if (contentobj) {
            if (contentobj && [contentobj isKindOfClass:NSArray.class] && [contentobj count]) {
                id tempObj = [contentobj firstObject];
                void(^tmpblock)(BOOL,long long) = [self.intermediary paymentBackAndSetFree];
                BOOL freePayStatus = [tempObj[@"free_pay_pwd_status"] integerValue] == 1;
                long long pwd_amout = [tempObj[@"free_pay_pwd_quota"] longLongValue];
                tmpblock?tmpblock(freePayStatus,pwd_amout):nil;
            }
        }
        NSMutableDictionary __block *queryDic = [NSMutableDictionary dictionaryWithCapacity:0];
        NSString *query = [NSString stringWithFormat:@"%@",obj?:@""];
        NSArray* tempArr = [query componentsSeparatedByString:@"&"];
        [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray* arr = [obj componentsSeparatedByString:@"="];
            if (arr.count == 2) {
                [queryDic setObject:[arr lastObject] forKey:[arr firstObject]];
            }
        }];
        CKPaymentResponse *paySource = [CKPaymentResponse objectWithKeyValues:queryDic];
        //继续支付完成流程
        !self.source.didFinishedPayWithResult?:self.source.didFinishedPayWithResult(self.isExceptionCallback, paySource.page);
    }];
   
}




@end
