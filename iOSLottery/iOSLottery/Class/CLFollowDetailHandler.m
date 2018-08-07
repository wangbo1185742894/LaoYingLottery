//
//  CLFollowDetailHandler.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/18.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFollowDetailHandler.h"
#import "CLFollowDetailModel.h"
#import "CLFollowDetailHeaderViewModel.h"
#import "CLOrderBasicCashViewModel.h"
#import "CLFollowDetailNumbetTopVM.h"
#import "CLFollowDetailNumberModel.h"
#import "CLOrderStatus.h"
#import "CLFollowPeroidAndRefundModel.h"
#import "CLAppContext.h"
#import "CLFirstStartModel.h"
#import "CLConfigMessage.h"
@implementation CLFollowDetailHandler

+ (id)dealingWithOrderDetaViewData:(NSDictionary*)dict lotteryCodeAdapter:(id)lottAdapter {
    
//    NSLog(@"%@",dict);
    CLFollowDetailBaseAPIModel* apiResult = [CLFollowDetailBaseAPIModel mj_objectWithKeyValues:dict];
    CLFollowDetailModel* followModel = [[CLFollowDetailModel alloc] init];
    followModel.gameEn = apiResult.gameEn;
    
    CLFollowDetailHeaderViewModel* headerVM = [[CLFollowDetailHeaderViewModel alloc] init];
    headerVM.saleEndTime = apiResult.saleEndTime;
    headerVM.lottIcon = [NSString stringWithFormat:@"%@%@.png",[CLAppContext context].firstStartInfo.picturePrefix, apiResult.gameEn];
    headerVM.lottName = apiResult.gameName;
    headerVM.followStatusCn = apiResult.followStatusCn;
    headerVM.isWaitPay = ((apiResult.ifShowPay == 1) && (apiResult.saleEndTime > 0));
    headerVM.isShowRefund = apiResult.ifShowFollowRefundDesc;
    followModel.isShowFooterView = !headerVM.isWaitPay;
    
    CLOrderBasicCashViewModel* cash1 = [[CLOrderBasicCashViewModel alloc] init];
    cash1.title = @"订单金额";
    cash1.content = [NSString stringWithFormat:@"%@元",@(apiResult.amount)];
    cash1.type = CLOrderBasicCashTypeText;
    [headerVM.cashMsgArray addObject:cash1];
    if (apiResult.ifShowTrueAmount) {
        CLOrderBasicCashViewModel* cash2 = [[CLOrderBasicCashViewModel alloc] init];
        cash2.title = @"实际支付";
        cash2.content = [NSString stringWithFormat:@"%@元",@(apiResult.trueAmount)];
        cash2.type = CLOrderBasicCashTypeText;
        [headerVM.cashMsgArray addObject:cash2];
    }
        
    CLOrderBasicCashViewModel* cash3 = [[CLOrderBasicCashViewModel alloc] init];
    cash3.title = @"中奖金额";
    NSString* bonus = nil;
    if ((apiResult.followStatus > followOrderStatusUnPayCancel) && !(apiResult.prizeStatus == followPrizeStatusWaitBonus)) {
        //订单状态为已支付 且 中奖状态为已开奖
        bonus = [NSString stringWithFormat:@"%@元",@(apiResult.bonus)];
        cash3.contentColor = THEME_COLOR;
    } else {
        bonus = @"--";
        cash3.contentColor = UIColorFromRGB(0x333333);
    }
    cash3.content = bonus;
    cash3.type = CLOrderBasicCashTypeText;
    [headerVM.cashMsgArray addObject:cash3];
    
    followModel.headerVM = headerVM;
    
    //停追条件
    CLFollowDetailSectionViewModel* betNumberTop = [[CLFollowDetailSectionViewModel alloc] init];
    betNumberTop.sectionType = CLFollowDetailSectionTypeLottNumTop;
    [betNumberTop.sectionArray addObject:apiResult.followModeCn];
    
    //投注号码
    CLFollowDetailSectionViewModel* betNumbers = [[CLFollowDetailSectionViewModel alloc] init];
    betNumbers.sectionType = CLFollowDetailSectionTypeLottNumBody;
    [betNumbers.sectionArray addObjectsFromArray:[CLFollowDetailNumberModel mj_objectArrayWithKeyValuesArray:apiResult.lotteryNumVoList]];

    //投注号码底部 查看全部与隐藏
    CLFollowDetailSectionViewModel* betNumberBottom = [[CLFollowDetailSectionViewModel alloc] init];
    betNumberBottom.sectionType = CLFollowDetailSectionTypeLottNumBottom;
    if (apiResult.lotteryNumVoList.count > 3) {
        [betNumberBottom.sectionArray addObject:@"展开"];
    }else{
        [betNumberBottom.sectionArray addObject:@""];
    }
    [followModel.followOrderArrays addObjectsFromArray:@[betNumberTop,betNumbers,betNumberBottom]];
    
    if (apiResult.followOrderVos && (apiResult.followOrderVos.count > 0)) {
        //追号列表表头
        CLFollowDetailSectionViewModel* FTopVM = [[CLFollowDetailSectionViewModel alloc] init];
        FTopVM.sectionType = CLFollowDetailSectionTypeFollowNumTop;
        CLFollowPeroidAndRefundModel* peroidModel = [CLFollowPeroidAndRefundModel new];
        peroidModel.peroidDone = apiResult.periodDone;
        peroidModel.totalPeriod = apiResult.totalPeriod;
        peroidModel.isShowRefund = (apiResult.ifShowOrderRefundDesc == 1);
        [FTopVM.sectionArray addObject:peroidModel];
        
        //追号列表内容
        CLFollowDetailSectionViewModel* FListVM = [[CLFollowDetailSectionViewModel alloc] init];
        FListVM.sectionType = CLFollowDetailSectionTypeFollowNumBody;
        [FListVM.sectionArray addObjectsFromArray:apiResult.followOrderVos];
        
        [followModel.followOrderArrays addObjectsFromArray:@[FTopVM,FListVM]];
    }
    
    
    
    return followModel;
}

@end
