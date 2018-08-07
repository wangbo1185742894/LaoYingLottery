//
//  CQPaymentBaseSource.h
//  caiqr
//
//  Created by 彩球 on 16/7/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

/** 此类为支付基类  不能直接创建使用 */

#import <Foundation/Foundation.h>
#import "CKCommonPaymentConf.h"
#import "CKSportsBetPaymentHandler.h"

@interface CKPaymentBaseSource : NSObject

@property (nonatomic, strong) NSString* total_amount;           //支付总金额

@property (nonatomic, strong) NSString* need_pay_amount;        //需支付金额

@property (nonatomic, assign) CKPaymentChannelType channel_type;  //支付渠道类型

@property (nonatomic, strong) NSString* url_prefix;             //支付链接前缀

@property (nonatomic, strong) NSString* card_no;  //@optional   //支付银行卡号

@property (nonatomic, weak) UIViewController* launch_class;     //发起支付类

@property (nonatomic, strong) NSString* flow_id;                //流水id

@property (nonatomic, assign) CKTransitionType transitionType;    //消费类型

/** 将要打开浏览器进行支付 */
@property (nonatomic, copy) void(^willOpenSafari)(void);

/** 已经打开浏览器进行支付 微信SDK也调用 */
@property (nonatomic, copy) void(^didOpenSafari)(void);
/* 支付完成回调  */
@property (nonatomic, copy) void(^didFinishenPay)(id obj);

/**
 支付结束回调，paySuccess 标识是否从正常操作返回，page 为跳转页面,在非正常返回时可能为空
 */
@property (nonatomic, copy) void (^didFinishedPayWithResult)(BOOL paySuccess, id page);

/** 创建支付token 回调 */
@property (nonatomic, copy) void(^createPayForToken)(BOOL createState , id responData);



/** 进行支付  需子类重载后使用 */
- (void)runPayment;

/** 支付完成后校验  需子类重载后使用*/
- (void)paymentFinishCheck;

//new


@property (nonatomic, copy) void(^startNativeRequest)(void);
@property (nonatomic, copy) void(^endNativeRequest)(BOOL reqState,id errorMsg);
@property (nonatomic, copy) void(^callBackH5Pay)(NSDictionary* params);
@property (nonatomic, copy) void(^callBackSDKPay)(NSInteger pay_channel_key, NSString* payForToken, NSDictionary* params);


@end
