//
//  CQSportsBetPaymentHandler.m
//  caiqr
//
//  Created by 彩球 on 16/4/28.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQSportsBetPaymentHandler.h"
#import "CQDefinition.h"
#import <UIKit/UIKit.h>
#import "CLAppContext.h"
#import "CLUserBaseInfo.h"
#import "NSString+Coding.h"
#import "CLConfigAPIMessage.h"
//#import "NSObject+CQBoardManage.h"
//#import "CQNetsAPIList.h"

static NSString* ticketPayment = @"paymentAccount";
static NSString* redPacketPayment = @"paymentRedPacket";
static NSString* rechargePayment = @"paymentRecharge";

static NSString* paymentOnlyRedPacket = @"paymentRed";
static NSString* paymentAccountOrRedPacket = @"paymentAccount";
static NSString* paymentUPPayOrRedPacket = @"paymentUnionPay";
static NSString* paymentLianLianPayOrRedPacket = @"paymentLianLian";
static NSString* paymentYiBaoPayOrRedPacket = @"paymentYeePay";

//#if APP_NETAPI_RELEASE
//
//#define CQ_Payment_PrefixUrl @"https://cashier.caiqr.cn/"
//
//#else
//
//#define CQ_Payment_PrefixUrl @"https://cashier.caiqr.cn/"
//
//#endif


#define CL_URL_SCHEME [[CLAppContext context] url_Scheme]

@implementation CQSportsBetPaymentHandler


sportPaymentChannelType channelFromAccountType(NSInteger accountType)
{
    switch (accountType) {
        case paymentChannelTypeOnlyRedParkets: return sportPaymentTypeOnlyRedPacket; break;
        case paymentChannelTypeAccountBalance:  return sportPaymentTypeAccountOrRedPacket; break;
        case paymentChannelTypeUPPay:  return sportPaymentTypeUPPayOrRedPacket; break;
        case paymentChannelTypeLianLian:  return sportPaymentTypeLianLianPayOrRedPacket; break;
        default: return sportPaymentTypeNone; break;
    }
}

+ (CQSportsBetPaymentHandler *)sharedManager
{
    static CQSportsBetPaymentHandler *sharedSportsBetPaymentHandlerManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedSportsBetPaymentHandlerManagerInstance = [[self alloc] init];
    });
    return sharedSportsBetPaymentHandlerManagerInstance;
}



#pragma mark - 跳出客户端支付

+ (NSDictionary*)parameterTotalAccount:(NSString*)totalAccount
                            payAccount:(NSString*)payaccount
                            redAccount:(NSString*)redAccount
                          hasRedPacket:(BOOL)hasRedPacket
                         redProgramsId:(NSString*)redProgramsId
                                flowId:(NSString*)flowid
                           payForToken:(NSString*)payfortoken
                            redOrderId:(NSString*)redorderid
{
    
    NSMutableDictionary* parameter = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameter setObject:totalAccount forKey:@"totalamount"];
    [parameter setObject:payaccount forKey:@"payamount"];
    [parameter setObject:((hasRedPacket)?@"1":@"0") forKey:@"hasred"];
    if (hasRedPacket) {
        [parameter setObject:redAccount forKey:@"redaccount"];
        [parameter setObject:redProgramsId forKey:@"redprogramsid"];
    }
    //flowid  需要传 pre_handle_token
    if (flowid) { [parameter setObject:flowid forKey:@"flowid"]; }
    if (payfortoken) { [parameter setObject:payfortoken forKey:@"payfortoken"]; }
    if (redorderid) { [parameter setObject:redorderid forKey:@"redorderid"]; }
    
    return parameter;
}

/** totalamount=总额 
    payamount=需支付金额 
    hasred=是否有红包 
    redaccount=红包金额 
    redprogramsid=红包方案id 
    flowid=流水号 
    token=用户token
    paytype=支付方式
    haspaypwd=是否设置支付密码
    caiqrhost=彩球跳出支付回调标识
    scheme=客户端唤起标识
 */

+ (void)sportsBetPaymentGotoSafariWithPaymentInfo:(id)info
                                   transitionType:(transitionType)transitionType
                               paymentChannelType:(paymentChannelType)channelType
                     paymentChannelConfigH5String:(NSString *)paymentUrlPrefix
                                   viewController:(UIViewController *)payViewController
{
    if (channelType == sportPaymentTypeNone) return;
    [CQSportsBetPaymentHandler sharedManager].paymentViewController = payViewController;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:info];
    [params setObject:[NSString stringWithUTF8String:object_getClassName(payViewController)] forKey:@"classname"];
    [params setObject:[[CLAppContext context] token]  forKey:@"token"];
    [params setObject:CL_URL_SCHEME forKey:@"scheme"];
    [params setObject:[NSString stringWithFormat:@"%zi",transitionType] forKey:@"paytype"];
    /** 仅有红包全额支付 或 账户余额与红包组合支付时 需要传递支付密码验证标记 */
    if ((channelType == paymentChannelTypeOnlyRedParkets) ||
        (channelType == paymentChannelTypeAccountBalance)) {
        
        safariOpenPayPwdStatus payPwdStatus = safariOpenPayPwdNeedCheckValidStatus;
        if (![CLAppContext context].userMessage.user_info.has_pay_pwd) {
            payPwdStatus = safariOpenPayPwdSettingStatus;//设置
        } else {
            if ([CLAppContext context].userMessage.user_info.free_pay_pwd_status) {
                long long payMoney = [params[@"totalamount"] longLongValue];
                payPwdStatus = (payMoney > ([CLAppContext context].userMessage.user_info.free_pay_pwd_quota * 100))?safariOpenPayPwdNeedCheckValidStatus:safariOpenPayPwdNotCheckStatus;
            } else {
                payPwdStatus = safariOpenPayPwdNeedCheckValidStatus;
            }
        }
        [params setObject:[NSString stringWithFormat:@"%zi",payPwdStatus] forKey:@"paypwdstatus"];
    }

    [params setObject:@"caiqrPayment" forKey:@"caiqrhost"];
    if (channelType == paymentChannelTypeAccountBalance) {
        [params setObject:[NSString stringWithFormat:@"%.f",[CLAppContext context].userMessage.account_info.account_balance] forKey:@"accountbalance"];
    }
    
    /** 
     * 仅红包支付 支付url前缀客户端固定 
     * 彩球账户+红包,连连+红包,易宝+红包等 支付url从后端获取
     */
    NSString* urlPerfix = nil;
    if (channelType == paymentChannelTypeOnlyRedParkets){
        
        NSString *url = nil;
        if (API_Environment == 0 || API_Environment == 3) {
            url = @"https://cashier.caiqr.cn/";
        }else{
            url = @"https://cashier2.caiqr.com/";
        }
        
        urlPerfix = [NSString stringWithFormat:@"%@paymentRed.html",url];
    }
    else if (channelType != paymentChannelTypeOther)
        urlPerfix = paymentUrlPrefix;
    else
        return;
    
    NSAssert(urlPerfix, @"payment jump url is nil");
    /** 支付方式String */
    NSString *url = [NSString stringWithFormat:@"%@?%@",urlPerfix,[CQSportsBetPaymentHandler configOpenUrlParams:params]];
    NSLog(@"+++++++++%@",url);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)thirdPaymentFinishToMakeSureWithFlowId:(NSString*)flow_id
                                        amount:(NSString*)amount
                                    payChannel:(paymentChannelType)pay_channel
                             payTransitionType:(transitionType)pay_transitionType
                                       orderId:(NSString*)order_id
{
    /** 如果是红包支付方式返回 */
    if (pay_channel == -1) return;
    
    if (pay_transitionType == transitionTypeTicketPayment) {
        //[CQNetsAPIListService sportBet_PayOrderAfterMakeSureWithAmount:amount flowId:flow_id accountTypeId:[NSString stringWithFormat:@"%zi",pay_channel] response:nil];
    } else if (pay_transitionType == transitionTypeRedPacketPayment) {
//        NSArray* arr = @[@{@"flow_id":flow_id}];
       // [CQNetsAPIListService userRelate_UserRedPacketsMakeSureAmount:amount orderId:order_id trading_info:arr response:nil];
    } else if (pay_transitionType == transitionTypeRecharge) {
//        NSArray* arr = @[@{@"flow_id":flow_id}];
        //[CQNetsAPIListService userRelate_UserUpdateRechargeOrderAmount:amount order_id:order_id trading_infos:arr response:nil];
    }
}

#pragma mark - 客户端被唤起回调处理

+ (BOOL)isSportsBetPaymentHandleOpenURL:(NSURL*)url
{
    BOOL ret = [CQSportsBetPaymentHandler checkPageValidUrl:url];
    if (ret) {
        [[CQSportsBetPaymentHandler sharedManager] dealWithPaymentCallBackWith:url];
    }
    return ret;
}

+ (BOOL)checkPageValidUrl:(NSURL*)url
{
    
    NSString* payUrlScheme = [url scheme];
    NSString* payUrlHost = [url host];
    NSString* payUrlQuery = [url query];
    
    CQPaymentResponse *paymentResponse = [CQSportsBetPaymentHandler objectGetUrlQuery:payUrlQuery];
    
    if (payUrlScheme && [payUrlScheme isEqualToString:CL_URL_SCHEME] &&
        payUrlHost && [payUrlHost isEqualToString:@"caiqrPayment"] &&
        paymentResponse && paymentResponse.classname) {
        
        NSString* className = [NSString stringWithUTF8String:object_getClassName([CQSportsBetPaymentHandler sharedManager].paymentViewController)];
        return [paymentResponse.classname isEqualToString:className];
    }
    return NO;
}



//处理支付回调
- (void)dealWithPaymentCallBackWith:(NSURL*)url
{
    SEL sel = NSSelectorFromString(@"paymentSafariCallBack:");
    if (self.paymentViewController && [self.paymentViewController respondsToSelector:sel]) {
        CQSuppressPerformSelectorWarning([self.paymentViewController performSelector:sel withObject:[CQSportsBetPaymentHandler objectGetUrlQuery:[url query]]]);
        self.paymentViewController = nil;
    }
}


+ (CQPaymentResponse*)objectGetUrlQuery:(NSString*)query
{
    
    NSMutableDictionary __block *queryDic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (!query || query.length == 0) {
        return nil;
    }
    
    NSArray* tempArr = [query componentsSeparatedByString:@"&"];
    [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray* arr = [obj componentsSeparatedByString:@"="];
        if (arr.count == 2) {
            [queryDic setObject:[arr lastObject] forKey:[arr firstObject]];
        }
    }];
    return [CQPaymentResponse mj_objectWithKeyValues:queryDic];
}

#pragma mark -拼接url参数

+ (NSString*)configOpenUrlParams:(NSDictionary*)dictionary
{
    NSMutableString __block *resultString = [NSMutableString stringWithCapacity:0];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString* obj, BOOL * _Nonnull stop) {
        NSString* value = @"";
        if ([obj isKindOfClass:[NSString class]]) {
            value = obj;
        }
        [resultString appendFormat:@"%@=%@&",key,value.urlEncode.base64.urlEncode];
//        [resultString appendFormat:@"%@=%@&",key,value];
    }];
    
    [resultString deleteCharactersInRange:NSMakeRange(resultString.length - 1, 1)];
    return resultString;
}

#pragma mark -匹配跳出页面类型与枚举值

+ (NSString*)paymentChannelType:(paymentChannelType)type
{
    switch (type) {
        case paymentChannelTypeOnlyRedParkets: return paymentOnlyRedPacket; break;
        case paymentChannelTypeAccountBalance: return paymentAccountOrRedPacket; break;
        case paymentChannelTypeUPPay: return paymentUPPayOrRedPacket; break;
        case paymentChannelTypeLianLian: return paymentLianLianPayOrRedPacket; break;
        case paymentChannelTypeYiBao: return paymentYiBaoPayOrRedPacket;
        default:
            return @"";
            break;
    }
}

//+ (NSString*)paymentTransitionWithType:(transitionType)type
//{
//    switch (type) {
//        case transitionTypeTicketPayment: return ticketPayment; break;
//        case transitionTypeRedPacketPayment: return redPacketPayment; break;
//        case transitionTypeRecharge: return rechargePayment; break;
//        default:
//            break;
//    }
//}

//+ (transitionType)transitionWithPaymentString:(NSString*)paymentStr
//{
//    if ([paymentStr isEqualToString:ticketPayment]) {
//        return transitionTypeTicketPayment;
//    } else if ([paymentStr isEqualToString:redPacketPayment]) {
//        return transitionTypeRedPacketPayment;
//    } else if ([paymentStr isEqualToString:rechargePayment]) {
//        return transitionTypeRecharge;
//    }
//    
//    return NSNotFound;
//}


@end


#pragma mark - CQPaymentResponse Class

@implementation CQPaymentResponse


@end

