//
//  CLAPIPersonalCenter.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* CMD_UserPersonalMessageAPI;
extern NSString* CMD_SystemHeadImgListAPI;
extern NSString* CMD_UpdateHeadImgAPI;
extern NSString* CMD_BindUserRealInfoAPI;
extern NSString* CMD_sendVerifyCodeAPI;
extern NSString* CMD_BindUserMobileAPI;
extern NSString* CMD_AccountCashJournalAPI;
extern NSString* CMD_RedEnvelopListAPI;
extern NSString* CMD_RedEnvelopDetailAPI;
extern NSString* CMD_RedEnvelopConsumeAPI;
extern NSString* CMD_RedEnvelopExchangeAPI;

extern NSString* CMD_ModifyLoginPwdAPI;
extern NSString* CMD_ModifyPayPwdAPI;
extern NSString* CMD_UserBindBankCardListAPI;
extern NSString* CMD_UserReliveBankCardAPI;
extern NSString* CMD_GetBankCardBinInfoAPI;
extern NSString* CMD_BindBankCardAPI;

extern NSString* CMD_LoginOrRegisterAPI;
extern NSString* CMD_LoginOfPasswordAPI;

extern NSString* CMD_BuyRedEnvelopListAPI;

extern NSString* CMD_ShowListWithdrawAPI;
extern NSString* CMD_CreateWithDrawOrderAPI;
extern NSString* CMD_WithdrawFollowAPI;

extern NSString* CMD_orderPayInfoAPI;

@interface CLAPIPersonalCenter : NSObject

@end
