//
//  CLUserCenterPageConfigure.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLUserCenterPageConfigure.h"

#import "CLAllJumpManager.h"

NSString *allJump_ChangePersonalHeadImgViewController = @"CLHeadReviseListViewController_push";
NSString *allJump_ChangeSystemHeadImgViewController = @"CLHeadOfSysChooseViewController_push";
NSString *allJump_ModifyNickNameViewController = @"CLModifyNickNameViewController_push";
NSString *allJump_IdAuthenViewController = @"CLUserCertifyViewController_push/";
NSString *allJump_UserCertifySuccessViewController = @"CLUserCertifySuccessViewController_push";
NSString *allJump_ModifyMobileViewController = @"CLModifyMobileViewController_push";
NSString *allJump_BankCardListViewController = @"CLBankCardListViewController_push";
NSString *allJump_AddBankCardViewController = @"CLAddBankCardViewController_push/2//";
NSString *allJump_LoginController = @"CLLoginViewController_present/";
NSString *allJump_RechargeController = @"CKNewRechargeViewController_push";
NSString *allJump_DFViewController = @"CLWithdrawViewController_push";
NSString *allJump_BuyRedEnveSelectViewController = @"CQBuyRedPacketsViewController_push";
NSString *allJump_RedEnveExchangeViewController = @"CLRedEnveExchangeViewController_push";
NSString *allJump_PersonalMsgViewController = @"CLPersonalMsgViewController_push";
NSString *allJump_PersonalJournalViewController = @"CLPersonalJournalViewController_push";
NSString *allJump_RedEnvoloperJournalViewController = @"CLRedEnvelopeViewController_push";
NSString *allJump_LotteryBetOrderListViewController = @"CLLotteryBetOrderListViewController_push";
NSString *allJump_LotteryFollowProgramsListController = @"CLFollowListViewController_push";
NSString *allJump_HelpFeedbackViewController = @"CLHelpFeedbackViewController_push";
NSString *allJump_SettingViewController = @"CLSettingViewController_push";
NSString *allJump_ModifyLoginPwdViewController = @"CLModifyLoginPwdViewController_push";
NSString *allJump_SetLoginPasswordController = @"CLSetLoginPwdViewController_push";
NSString *allJump_ModifyPayPasswordController = @"CLModifyPayPwdViewController_push";
NSString *allJump_SetPayPasswordViewController = @"CQSettingPaymentPwdViewController_present/";
NSString *allJump_MicroPaymentViewController = @"CLMicroPaymentViewController_push";

@implementation CLUserCenterPageConfigure

//修改个人头像
+ (void) pushChangePersonalHeadImgViewController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_ChangePersonalHeadImgViewController];
}

//系统头像修改
+ (void)pushChangeSystemHeadImgViewController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_ChangeSystemHeadImgViewController];
}
//修改昵称
+ (void)pushModifyNickNameViewController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_ModifyNickNameViewController];
}

//实名认证VC
+ (void)pushIdAuthenViewController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_IdAuthenViewController];
}

//实名认证成功VC
+ (void)pushUserCertifySuccessViewController{
    
    [[CLAllJumpManager shareAllJumpManager] openDestoryWithURL:allJump_UserCertifySuccessViewController];
}

//修改手机号
+ (void)pushModifyMobileViewController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_ModifyMobileViewController];
}
//银行卡列表
+ (void)pushBankCardListViewController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_BankCardListViewController];
}

//添加银行卡
+ (void)pushAddBankCardViewController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_AddBankCardViewController];
}

//登录
+ (void)presentLoginViewController{
    
    //跳转登录
    [[CLAllJumpManager shareAllJumpManager] open:allJump_LoginController];
}
//充值
+ (void)pushVoucherCenterViewController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_RechargeController];
}

//提现
+ (void)pushDFViewController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_DFViewController];
}

//红包购买
+ (void)pushBuyRedEnvolopeViewController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_BuyRedEnveSelectViewController];
}

//红包兑换
+ (void)pushRedEnvoExchangeViewController{

    [[CLAllJumpManager shareAllJumpManager] open:allJump_RedEnveExchangeViewController];
}

//个人信息
+ (void)pushPersonalMessageViewController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_PersonalMsgViewController];
}
//账户流水
+ (void)pushPersonalAccountJournalViewController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_PersonalJournalViewController];
}

//红包流水
+ (void)pushRedEnvoloperJournalViewController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_RedEnvoloperJournalViewController];
}

//投注订单列表
+ (void)pushLotteryBetOrderListController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_LotteryBetOrderListViewController];
}
//追号方案列表
+(void)pushLotteryFollowProgramsListController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_LotteryFollowProgramsListController];
}
//帮助与反馈
+ (void) pushHelpFeedbackViewController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_HelpFeedbackViewController];
}

//设置
+ (void)pushSettingViewController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_SettingViewController];
}

//修改登录密码
+(void)pushModifyLoginPasswordController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_ModifyLoginPwdViewController];
}

//设置登录密码
+ (void)pushSetLoginPasswordController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_SetLoginPasswordController];
}

/* 修改支付密码 */
+ (void)pushModifyPayPasswordController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_ModifyPayPasswordController];
}

//设置支付密码
+(void)pushSetPayPasswordViewController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_SetPayPasswordViewController];
}

//小额免密金额页面
+(void)pushMicroPaymentViewController{
    
    [[CLAllJumpManager shareAllJumpManager] open:allJump_MicroPaymentViewController];
}

@end
