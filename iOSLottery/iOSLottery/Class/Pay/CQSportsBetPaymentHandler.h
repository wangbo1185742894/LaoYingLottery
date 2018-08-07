//
//  CQSportsBetPaymentHandler.h
//  caiqr
//
//  Created by 彩球 on 16/4/28.
//  Copyright © 2016年 Paul. All rights reserved.
//

/** 真票支付、红包购买、余额充值 跳出客户端支付 */


#import "CLBaseModel.h"
#import "CLPaymentConfig.h"
//#import "CQCommonPaymentConf.h"
//#import "NSString+CQExpandNSString.h"

@class UIViewController;

typedef NS_ENUM(NSInteger, sportPaymentChannelType)
{
    sportPaymentTypeNone = 0,
    sportPaymentTypeOnlyRedPacket,          //仅红包支付
    sportPaymentTypeAccountOrRedPacket,     //账户+红包支付
    sportPaymentTypeUPPayOrRedPacket ,      //银联+红包支付
    sportPaymentTypeLianLianPayOrRedPacket, //连连+红包支付
};

typedef NS_ENUM(NSInteger, transitionType)
{
    transitionTypeTicketPayment = 0,    //真票支付模块
    transitionTypeRedPacketPayment,     //红包支付模块
    transitionTypeRecharge,             //充值支付模块
};

typedef NS_ENUM(NSInteger, safariCallPaymentStatus)
{
    safariCallPaymentSuccess = 0,
    safariCallPaymentFail = 1,
    safariCallPaymentCancel = 2,
};

typedef NS_ENUM(NSInteger, safariOpenPayPwdStatus)
{
    safariOpenPayPwdSettingStatus = 0,  //设置支付密码
    safariOpenPayPwdNeedCheckValidStatus,   //需验证支付密码
    safariOpenPayPwdNotCheckStatus,     //无需验证支付密码
};

@interface CQSportsBetPaymentHandler : NSObject

/** 匹配跳转safari时支付渠道
  * account_type 后端支付类型  1,账户余额 3,银联 6,连连 */
sportPaymentChannelType channelFromAccountType(NSInteger accountType);

@property (nonatomic, strong) UIViewController* paymentViewController;

/** 拼接跳转基础数据 */
+ (NSDictionary*)parameterTotalAccount:(NSString*)totalAccount
                            payAccount:(NSString*)payaccount
                            redAccount:(NSString*)redAccount
                          hasRedPacket:(BOOL)hasRedPacket
                         redProgramsId:(NSString*)redProgramsId
                                flowId:(NSString*)flowid
                           payForToken:(NSString*)payfortoken
                            redOrderId:(NSString*)redorderid;
/** channelType 支付方式  */
+ (void)sportsBetPaymentGotoSafariWithPaymentInfo:(id)info
                                   transitionType:(transitionType)transitionType
                               paymentChannelType:(paymentChannelType)channelType
                     paymentChannelConfigH5String:(NSString *)paymentUrlPrefix
                                   viewController:(UIViewController*)payViewController;

+ (BOOL)isSportsBetPaymentHandleOpenURL:(NSURL*)url;


/** 第三方(银联，连连)支付后 与后端进行确认 */
+ (void)thirdPaymentFinishToMakeSureWithFlowId:(NSString*)flow_id
                                        amount:(NSString*)amount
                                    payChannel:(paymentChannelType)pay_channel
                             payTransitionType:(transitionType)pay_transitionType
                                       orderId:(NSString*)order_id;
/** 体现到红包根据channel匹配channelString */
+ (NSString*)paymentChannelType:(paymentChannelType)type;

@end


@interface CQPaymentResponse : CLBaseModel

@property (nonatomic, strong) NSString* classname;
@property (nonatomic, assign) transitionType paytype;
@property (nonatomic, assign) safariCallPaymentStatus paystatus;
@property (nonatomic, strong) NSString* paymsg;
@property (nonatomic, strong) NSString* memo;

@end


