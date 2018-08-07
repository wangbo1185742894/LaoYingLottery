//
//  CLUserCenterPageConfigure.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CLUserCenterPageConfigure : NSObject

/* -------------------------------------------------------------- */
/*                        个人信息设置                              */
/* -------------------------------------------------------------- */

/* 修改头像 */
+ (void) pushChangePersonalHeadImgViewController;

/* 修改系统头像 */
+ (void) pushChangeSystemHeadImgViewController;

/* 修改昵称 */
+ (void) pushModifyNickNameViewController;

/* 实名认证 */
+ (void) pushIdAuthenViewController;

/* 实名认证成功 */
+ (void) pushUserCertifySuccessViewController;

/* 修改手机号 */
+ (void) pushModifyMobileViewController;

/* 银行卡列表 */
+ (void) pushBankCardListViewController;

/* 添加银行卡 */
+ (void) pushAddBankCardViewController;

/* -------------------------------------------------------------- */
/*                        个人中心列表                              */
/* -------------------------------------------------------------- */
+ (void)presentLoginViewController;
/* 充值 */
+ (void)pushVoucherCenterViewController;

/* 提现 */
+ (void)pushDFViewController;

/* 红包购买 */
+ (void)pushBuyRedEnvolopeViewController;

/* 红包兑换 */
+ (void)pushRedEnvoExchangeViewController;

/* 个人信息 */
+ (void)pushPersonalMessageViewController;

/* 个人账户流水 */
+ (void)pushPersonalAccountJournalViewController;

/* 红包流水 */
+ (void)pushRedEnvoloperJournalViewController;

/* 投注订单列表 */
+ (void)pushLotteryBetOrderListController;

/* 追号方案列表 */
+ (void)pushLotteryFollowProgramsListController;

/* 帮助与反馈 */
+ (void) pushHelpFeedbackViewController;

/* -------------------------------------------------------------- */
/*                            设置                                */
/* -------------------------------------------------------------- */

/* 设置 */
+ (void)pushSettingViewController;

/* 修改登录密码 */
+ (void)pushModifyLoginPasswordController;

/* 设置登录密码 */
+ (void)pushSetLoginPasswordController;

/* 修改支付密码 */
+ (void)pushModifyPayPasswordController;

/* 设置支付密码 */
+ (void)pushSetPayPasswordViewController;

/* 小额免密金额页面 */
+ (void)pushMicroPaymentViewController;

@end
