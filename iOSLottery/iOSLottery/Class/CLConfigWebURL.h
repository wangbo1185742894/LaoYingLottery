//
//  CLConfigWebURL.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/19.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#ifndef CLConfigWebURL_h
#define CLConfigWebURL_h

//委托投注协议
#define url_EntrustProtocol @"https://m.caiqr.com/help/c2cAgreementYing.html"
//红包说明
#define url_redExplain @"https://m.caiqr.com/help/introdution_of_yingred.html"
//D11玩法说明
#define url_DE_Lu_PlayExplain @"https://m.caiqr.com/daily/lu11xuan5/index.htm"
//赣D11玩法说明
#define url_DE_Gan_PlayExplain @"https://m.caiqr.com/daily/gan11xuan5/index.htm"
//鄂D11玩法说明
#define url_DE_E_PlayExplain @"https://m.caiqr.com/daily/e11xuan5/index.htm"
//快三玩法说明
#define url_FT_PlayExplain @"https://m.caiqr.com/daily/kuai3/index.htm"

#define url_PlayExplain(lotteryGameEn) [NSString stringWithFormat:@"https://m.caiqr.cn/help/lotteryPlayInstruction.html?gameEn=%@", lotteryGameEn]
//D11购彩技巧
#define url_DE_BuyLotterySkill @"https://m.caiqr.com/help/lotterySkill.html?from=d11"
//快三购彩技巧
#define url_FT_BuyLotterySkill @"https://m.caiqr.com/help/lotterySkill.html?from=kuai3"
//帮助与反馈
#define url_HelpFeedback @"https://m.caiqr.com/help/helpYing.html"
//提现银行卡列表
#define url_WithdrawBankCard @"https://cashier.caiqr.com/bankCards.html?type=1"
//银行卡信息可支持银行卡列表
#define url_BankCard @"https://cashier.caiqr.com/bankCards.html?type=2"
//什么是胆拖
#define url_DanTuo @"https://m.caiqr.com/help/courageStatment.html"
//中奖后如何领奖
#define url_HowToBonus @"https://m.caiqr.com/help/introdution_receiveWin.html"
#endif /* CLConfigWebURL_h */
