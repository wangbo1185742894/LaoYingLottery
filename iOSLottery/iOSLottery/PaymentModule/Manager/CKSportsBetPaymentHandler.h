//
//  CQSportsBetPaymentHandler.h
//  caiqr
//
//  Created by 彩球 on 16/4/28.
//  Copyright © 2016年 Paul. All rights reserved.
//

/** 真票支付、红包购买、余额充值 跳出客户端支付 */


#import "CKBaseModel.h"
#import "CKCommonPaymentConf.h"
//#import "CQCommonPaymentConf.h"
//#import "NSString+CQExpandNSString.h"

@class UIViewController;

typedef NS_ENUM(NSInteger, CKSportPaymentChannelType)
{
    CKSportPaymentTypeNone = 0,
    CKSportPaymentTypeOnlyRedPacket,          //仅红包支付
    CKSportPaymentTypeAccountOrRedPacket,     //账户+红包支付
    CKSportPaymentTypeUPPayOrRedPacket ,      //银联+红包支付
    CKSportPaymentTypeLianLianPayOrRedPacket, //连连+红包支付
};

typedef NS_ENUM(NSInteger, CKTransitionType)
{
    CKTransitionTypeTicketPayment = 0,    //真票支付模块
    CKTransitionTypeRedPacketPayment,     //红包支付模块
    CKTransitionTypeRecharge,             //充值支付模块
};

typedef NS_ENUM(NSInteger, CKSafariCallPaymentStatus)
{
    CKSafariCallPaymentSuccess = 0,
    CKSafariCallPaymentFail = 1,
    CKSafariCallPaymentCancel = 2,
};

typedef NS_ENUM(NSInteger, CKSafariOpenPayPwdStatus)
{
    CKSafariOpenPayPwdSettingStatus = 0,  //设置支付密码
    CKSafariOpenPayPwdNeedCheckValidStatus,   //需验证支付密码
    CKSafariOpenPayPwdNotCheckStatus,     //无需验证支付密码
};

@interface CKSportsBetPaymentHandler : NSObject

/** 匹配跳转safari时支付渠道
  * account_type 后端支付类型  1,账户余额 3,银联 6,连连 */
CKSportPaymentChannelType CKChannelFromAccountType(NSInteger accountType);

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
                                   transitionType:(CKTransitionType)transitionType
                               paymentChannelType:(CKPaymentChannelType)channelType
                     paymentChannelConfigH5String:(NSString *)paymentUrlPrefix
                                   viewController:(UIViewController*)payViewController;

+ (BOOL)isSportsBetPaymentHandleOpenURL:(NSURL*)url;


/** 第三方(银联，连连)支付后 与后端进行确认 */
+ (void)thirdPaymentFinishToMakeSureWithFlowId:(NSString*)flow_id
                                        amount:(NSString*)amount
                                    payChannel:(CKPaymentChannelType)pay_channel
                             payTransitionType:(CKTransitionType)pay_transitionType
                                       orderId:(NSString*)order_id;
/** 体现到红包根据channel匹配channelString */
+ (NSString*)paymentChannelType:(CKPaymentChannelType)type;

@end


@interface CKPaymentResponse : CKBaseModel

@property (nonatomic, strong) NSString* classname;
@property (nonatomic, assign) CKTransitionType paytype;
@property (nonatomic, assign) CKSafariCallPaymentStatus paystatus;
@property (nonatomic, strong) NSString* paymsg;
@property (nonatomic, strong) NSString* memo;
@property (nonatomic, strong) NSString* page;
@end


