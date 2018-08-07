//
//  CLAllAlertInfo.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/6.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#ifndef CLAllAlertInfo_h
#define CLAllAlertInfo_h

#define appName @"老鹰彩票"

//充值右上角提示
#define allAlertInfo_Recharge [NSString stringWithFormat:@"Q:%@充值有限制吗？\nA:您好，%@单笔充值不低于50元，最高不能超过支付渠道的限额。\nQ:有充值手续费吗？\nA:您好，所有因充值而产生的手续费全部由%@承担，您不用支付任何费用。\nQ:充值的钱可以全部提现吗？\nA:您好，根据国家规定，每笔充值可提现总充值数的50%@，剩下的50%@只可用来消费使用。", appName, appName, appName, @"%", @"%"]
//银行卡列表右上角提示
#define allAlertInfo_BankCardList [NSString stringWithFormat:@"Q:怎样绑定银行卡？\nA:绑定银行卡支持%@用户在充值、提现的时候使用，绑定时需要填写真实姓名，身份证号以及在银行预留的手机号。\nQ:现在使用的手机号和当时银行卡预留的手机号不一致怎么办？\nA:如现在使用的手机号和当时银行预留的手机号不一致，出现手机号忘记或者已经停用的情况，烦请联系所在银行客服更新处理。", appName]
//提现右上角提示
#define allAlertInfo_withdraw [NSString stringWithFormat:@"Q:提现有手续费吗？\nA:%@承担您的提现手续费。\nQ:账户余额可以全部提现吗？\nA:您好，根据国家规定，每笔充值可提现总充值数的50%@，剩下的50%@只可用来消费使用。", appName, @"%", @"%"]
//余额
#define allAlertInfo_Balance [NSString stringWithFormat:@"Q:什么是账户余额？\nA:您好，账户余额主要来源于充值和中奖后返奖两种形式，账户余额可以用来消费使用或者提现。\nQ:哪里可以查看账户余额？\nA:您可以在%@的流水记录中查看您的充值、提现、兑换红包、消费以及返奖的全部记录。确保您账户的余额无误。", appName]
//实名认证
#define allAlertInfo_UserCertify [NSString stringWithFormat:@"Q:为什么要实名认证？\nA:您好，为了给您一个安全可靠地资金保障，需要您在领取的奖金超过3000元以上和在需要提现的情况下进行实名信息认证。\nQ:实名认证的作用？\nA:不仅可以保障您的资金安全，还便于您在丢失登录密码和支付密码情况下立即找回。"]

//银行预留手机号提示
#define allAlertInfo_BankCardNeedMobile [NSString stringWithFormat:@"银行预留手机号码是指您在办理该张银行卡时所填写的手机号码，一旦忘记预留手机号码或者该手机号码已停用，请联系银行客服进行处理。"]
//退款说明
#define allAlertInfo_RefundInfo @"购彩金原路退还，优先退还红包，即时到账，有效期不变：账户余额直接退还，即时到账；第三方支付退还到支付银行卡，具体到账日以银行为准。"
//中奖后停止追号
#define allAlertInfo_BonusStopChase @"勾选后，当您的追号方案某一期中奖，则后续的追号订单将被撤销，资金返还到您的账户中。如不勾选，系统一直帮您购买所有的追号投注订单"


#endif /* CLAllAlertInfo_h */
