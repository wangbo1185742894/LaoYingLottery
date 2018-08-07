//
//  CLLottBetOrdDetaHandler.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLottBetOrdDetaHandler.h"
#import "CLOrderDetailModel.h"
#import "CLOrderStatusViewModel.h"
#import "CLOrderBasicCashViewModel.h"
#import "CLOrderDetailHeaderViewModel.h"
#import "CLOrderDetailLineViewModel.h"
#import "CLOrderStatus.h"
#import "CLOrderDetailBetNumModel.h"
#import "CLConfigMessage.h"

@interface CLLottBetOrdDetaHandler ()

@property (nonatomic, strong) CLOrderDetailBasicModel* result;

@end

@implementation CLLottBetOrdDetaHandler

- (NSString*)orderId {
    
    if (self.result == nil) {
        return @"";
    }
    return self.result.orderId;
}

- (id)dealingWithOrderDetaViewData:(NSDictionary*)dict lotteryCodeAdapter:(id)lottAdapter {
    
    CLOrderDetailBasicModel* apiResult = [CLOrderDetailBasicModel yy_modelWithDictionary:dict];
    self.result = apiResult;
    
    CLOrderDetailModel* viewModel = [[CLOrderDetailModel alloc] init];
    viewModel.isShowFooterView = YES;
    viewModel.gameEn = apiResult.gameEn;
    CLOrderDetailHeaderViewModel* headerViewModel = [[CLOrderDetailHeaderViewModel alloc] init];
    headerViewModel.gameEn = apiResult.gameEn;
    headerViewModel.lotteryName = apiResult.gameName;
    headerViewModel.lotteryPeriod = [NSString stringWithFormat:@"第%@期",apiResult.periodId];

    //进度线条
    if (apiResult.lineStatus.length > 0) {
        NSArray* lines = [apiResult.lineStatus componentsSeparatedByString:@","];
        for (NSString* flag in lines) {
            CLOrderStatusViewModel* lineStatus = [CLOrderStatusViewModel new];
            lineStatus.statusType = CLOrderStatusTypeLine;
            lineStatus.lineLight = NO;
            if ([flag isKindOfClass:NSString.class]) {
                lineStatus.lineLight = ([flag integerValue] == 1);
            }
            [headerViewModel.lineArrays addObject:lineStatus];
        }
    }
    //进度点
    if (apiResult.statusProcess.count > 0) {
        BOOL __statusProcessValid = YES;
        for (NSString* dot in apiResult.statusProcess) {
            NSArray* dots = [dot componentsSeparatedByString:@"_"];
            if (dots.count != 3) {
                __statusProcessValid = NO;
                break;
            }
            CLOrderStatusViewModel* dotStatus = [CLOrderStatusViewModel new];
            dotStatus.statusType = CLOrderStatusTypeDot;
            
            if (![dots[0] isKindOfClass:NSString.class] || ([dots[0] length] == 0)) {
                __statusProcessValid = NO;break;
            }
            dotStatus.dotTitle = dots[0];
            
            if (![dots[1] isKindOfClass:NSString.class] || ([dots[1] length] == 0)) {
                __statusProcessValid = NO;break;
            }
            dotStatus.dotText = dots[1];
            [dotStatus setDotTypeWithFlagString:dots[1]];
            
            if (!(dotStatus.dotType == CLOrderStatusDotTypeSuccess ||
                dotStatus.dotType == CLOrderStatusDotTypeFail)) {
                if (![dots[2] isKindOfClass:NSString.class] || ([dots[2] length] == 0)) {
                    __statusProcessValid = NO;break;
                }
                [dotStatus setDotTypeWithFlagString:dots[2]];
            }
            
            
            [headerViewModel.dotArrays addObject:dotStatus];
        }
        
        if (!__statusProcessValid) {
            [headerViewModel.dotArrays removeAllObjects];
        }
    }
    
    //判断订单状态
    /* 1.待支付 - 3 按钮
       2.过期未支付/等待出票/出票中/等待开奖/期次取消/订单失败 - 2
       3.开奖  - 3 图片
     */
    CLOrderBasicCashViewModel* orderBetVM = [[CLOrderBasicCashViewModel alloc] init];
    orderBetVM.type = CLOrderBasicCashTypeText;
    orderBetVM.title = @"订单金额";
    
    if (![dict[@"orderAmount"] isKindOfClass:[NSNull class]]) {
        orderBetVM.content = [NSString stringWithFormat:@"%@元",@(apiResult.orderAmount)];
    }else{
        orderBetVM.content = @"--";
    }
    
    [headerViewModel.basicArrays addObject:orderBetVM];
    
    CLOrderBasicCashViewModel* orderBonusVM = [[CLOrderBasicCashViewModel alloc] init];
    orderBonusVM.type = CLOrderBasicCashTypeText;
    orderBonusVM.title = apiResult.bonusTitle;
    if (apiResult.bonusColor && apiResult.bonusColor.length > 0) {
        orderBonusVM.contentColor = UIColorFromStr(apiResult.bonusColor);
    }
    orderBonusVM.content = apiResult.bonusStr;
    
    [headerViewModel.basicArrays addObject:orderBonusVM];
    
    if ((apiResult.ifShowPay == 1) && apiResult.saleEndTime > 0) {
        //展示继续支付按钮
        CLOrderBasicCashViewModel* orderStateVM = [[CLOrderBasicCashViewModel alloc] init];
        orderStateVM.type = CLOrderBasicCashTypeBtn;
        orderStateVM.payEndTime = apiResult.saleEndTime;
        orderStateVM.payBtnTitle = @"继续支付";
        orderStateVM.ifCountdown = apiResult.ifCountdown;
        [headerViewModel.basicArrays addObject:orderStateVM];
        viewModel.isShowFooterView = NO;
    }else{
        if ((apiResult.orderStatus == lotteryOrderStatusBetSuccess || apiResult.orderStatus == lotteryOrderStatusRefund) && (apiResult.prizeStatus) > orderPrizeStatusNoLottery) {
            //投注成功  并且开奖
            CLOrderBasicCashViewModel* orderBonusVM = [[CLOrderBasicCashViewModel alloc] init];
            orderBonusVM.type = CLOrderBasicCashTypeImg;
                
            if (apiResult.prizeStatus == orderPrizeStatusNoBonus) {
                orderBonusVM.image = [UIImage imageNamed:@"cl_order_keep_on"];
            } else {
                orderBonusVM.image = [UIImage imageNamed:@"cl_order_win"];
                orderBonusVM.contentColor = [UIColor redColor];
            }
            [headerViewModel.basicArrays addObject:orderBonusVM];
        }
    }
    
    //彩票店
    if (apiResult.orderStatus > lotteryOrderStatusOverduePay) {
        headerViewModel.lotteryStoreName = apiResult.postStationName;
    } else {
        headerViewModel.lotteryStoreName = @"";
    }
    
    
    viewModel.orderHeaderData = headerViewModel;
    headerViewModel = nil;
    
    
    //订单状态Section
    CLOrderDetailListViewModel* orderStateSectionVM = [[CLOrderDetailListViewModel alloc] init];
    orderStateSectionVM.dataType = CLOrderDetaDataTypeOrderState;

    if ([apiResult.orderStatusCn isKindOfClass:[NSString class]] && apiResult.orderStatusCn.length > 0) {
        CLOrderDetailLineViewModel* orderStatusCn = [[CLOrderDetailLineViewModel alloc] init];
        orderStatusCn.title = @"订单状态";
        orderStatusCn.content = apiResult.orderStatusCn;
        if (apiResult.ifShowRefundDesc == 1) {
            orderStatusCn.linkRange = NSMakeRange(apiResult.orderStatusCn.length + 1, 4);
            orderStatusCn.content = [NSString stringWithFormat:@"%@ 退款说明",apiResult.orderStatusCn];
            orderStatusCn.linkColor = LINK_COLOR;
        }
        [orderStateSectionVM.dataArrays addObject:orderStatusCn];
    }
    
    if ([apiResult.prizeStatusCn isKindOfClass:[NSString class]] && apiResult.prizeStatusCn.length > 0) {
        CLOrderDetailLineViewModel* prizeStatusCn = [[CLOrderDetailLineViewModel alloc] init];
        prizeStatusCn.title = @"开奖状态:";
        prizeStatusCn.content = apiResult.prizeStatusCn;
        [orderStateSectionVM.dataArrays addObject:prizeStatusCn];
    }
    
    //注意这里添加空数据，为了UI 增加上下间距  这里没有订单状态 和 开奖状态 添加一条 如果有则上下都加
    if (orderStateSectionVM.dataArrays.count == 0) {
        CLOrderDetailLineViewModel* nullStatusCn = [[CLOrderDetailLineViewModel alloc] init];
        nullStatusCn.title = nullStatusCn.content = @"";
        [orderStateSectionVM.dataArrays addObject:nullStatusCn];
    }else{
        CLOrderDetailLineViewModel* nullStatusCn = [[CLOrderDetailLineViewModel alloc] init];
        nullStatusCn.title = nullStatusCn.content = @"";
        [orderStateSectionVM.dataArrays insertObject:nullStatusCn atIndex:0];
        [orderStateSectionVM.dataArrays addObject:nullStatusCn];
    }
    
    [viewModel.orderDetailData addObject:orderStateSectionVM];
    orderStateSectionVM = nil;
    //是不是乐善码
        BOOL isLeshan = [apiResult.gameEn isEqualToString:@"dlt"] && apiResult.dltLsActivity;
//    BOOL isLeshan = YES;
    viewModel.isLeshan = isLeshan;
    
    //投注开奖号码与投注项标题 Section
    
    if ([apiResult.gameEn isEqualToString:@"sfc"] || [apiResult.gameEn isEqualToString:@"rx9"]) {
        
        CLOrderDetailListViewModel* bonusNumVM = [[CLOrderDetailListViewModel alloc] init];
        bonusNumVM.dataType = CLOrderDetaDataTypeMatchList;
        
        CLOrderDetailBetNumModel* numModel = [CLOrderDetailBetNumModel new];
        numModel.serialNumber = 0;
        numModel.hostName = @"";
        numModel.score = @"主队VS客队";
        numModel.awayName = @"";
        numModel.betOption = @"投注";
        numModel.result = @"赛果";
        
        [bonusNumVM.dataArrays addObject:numModel];
        [viewModel.orderDetailData addObject:bonusNumVM];
        
    }else{
    
    
        CLOrderDetailListViewModel* bonusNumVM = [[CLOrderDetailListViewModel alloc] init];
        bonusNumVM.dataType = CLOrderDetaDataTypeBonusNum;
        CLOrderDetailBetNumModel* winNum = [CLOrderDetailBetNumModel new];
        winNum.titleType = TitleTypeBonusNumber;
        winNum.title = @"开奖号码";
        winNum.betNumber = apiResult.winningNumbers;
        if (apiResult.winningNumberColor && apiResult.winningNumberColor.length > 0) {
            
            winNum.betNumberColor = UIColorFromStr(apiResult.winningNumberColor);
        }
        [bonusNumVM.dataArrays addObject:winNum];
        if (!isLeshan) {
        CLOrderDetailBetNumModel* titleModel = [CLOrderDetailBetNumModel new];
        titleModel.titleType = TitleNormal;
        titleModel.title = @"投注项";
        titleModel.betNumber = @"";
        [bonusNumVM.dataArrays addObject:titleModel];
        }
        [viewModel.orderDetailData addObject:bonusNumVM];
    }
    

    //投注号码类型 Section
    CLOrderDetailListViewModel* orderLottNumVM = [[CLOrderDetailListViewModel alloc] init];

    if ([apiResult.gameEn isEqualToString:@"sfc"] || [apiResult.gameEn isEqualToString:@"rx9"]) {
        
        /********胜负彩*********/
        
        orderLottNumVM.dataType = CLOrderDetaDataTypeMatchList;
        
        [apiResult.sfcMatchVoList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CLOrderDetailBetNumModel* numModel = [CLOrderDetailBetNumModel new];
            
            numModel.hostName = obj[@"hostName"];
            numModel.awayName = obj[@"awayName"];
            numModel.serialNumber = [obj[@"serialNumber"] integerValue];
            numModel.score = obj[@"score"];
            numModel.result = obj[@"result"];
            numModel.betOption = obj[@"betOption"];
            
            [orderLottNumVM.dataArrays addObject:numModel];
            numModel = nil;
        }];
        
    } else if ([apiResult.gameEn isEqualToString:@"dlt"]) {
        orderLottNumVM.dataType = CLOrderDetaDataTypeLottNum;
        if (apiResult.dltLsActivity) {
            //乐善码
            [apiResult.lotteryNumLSVoList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //票号
                CLOrderDetailBetNumModel* numModel = [CLOrderDetailBetNumModel new];
                NSString* cn = obj[@"ticketId"];
                NSString* num = obj[@"times"];
                numModel.title = ([cn isKindOfClass:[NSString class]])?[NSString stringWithFormat:@"票%zi 票号：%@",++idx,cn]:@"";
                numModel.betNumber = [NSString stringWithFormat:@"%@",num];
                numModel.titleType = TitleTypeLeShanNumber;
                [orderLottNumVM.dataArrays addObject:numModel];
                numModel = nil;
                //乐善码
                if (obj[@"leshanNum"]) {
                    CLOrderDetailBetNumModel* numModel = [CLOrderDetailBetNumModel new];
                    NSString* num = obj[@"leshanNum"];
                    numModel.title = @"乐善码";
                    numModel.betNumber = ([num isKindOfClass:NSString.class])?num:@"";
                    numModel.titleType = TitleTypeBetNumber;
                    numModel.betNumberColor = UIColorFromStr(apiResult.winningNumberColor);
                    [orderLottNumVM.dataArrays addObject:numModel];
                    numModel = nil;
                }
                //投注内容
                NSArray * lotteryNumsArr = obj[@"lotteryNums"]?:@[];
                [lotteryNumsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CLOrderDetailBetNumModel* numModel = [CLOrderDetailBetNumModel new];
                    NSString* cn = obj[@"extraCn"];
                    NSString* num = obj[@"lotteryNumber"];
                    numModel.title = ([cn isKindOfClass:[NSString class]])?cn:@"";
                    numModel.betNumber = ([num isKindOfClass:NSString.class])?num:@"";
                    numModel.titleType = TitleTypeBetNumber;
                    [orderLottNumVM.dataArrays addObject:numModel];
                    numModel = nil;
                }];
            }];
        } else {
            [apiResult.lotteryNumVoList enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CLOrderDetailBetNumModel* numModel = [CLOrderDetailBetNumModel new];
                NSString* cn = obj[@"extraCn"];
                NSString* num = obj[@"lotteryNumber"];
                numModel.title = ([cn isKindOfClass:[NSString class]])?cn:@"";
                numModel.betNumber = ([num isKindOfClass:NSString.class])?num:@"";
                numModel.titleType = TitleTypeBetNumber;
                [orderLottNumVM.dataArrays addObject:numModel];
                numModel = nil;
            }];
        }
    } else {
    
        orderLottNumVM.dataType = CLOrderDetaDataTypeLottNum;
        
        [apiResult.lotteryNumVoList enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CLOrderDetailBetNumModel* numModel = [CLOrderDetailBetNumModel new];
            NSString* cn = obj[@"extraCn"];
            NSString* num = obj[@"lotteryNumber"];
            numModel.title = ([cn isKindOfClass:[NSString class]])?cn:@"";
            numModel.betNumber = ([num isKindOfClass:NSString.class])?num:@"";
            numModel.titleType = TitleTypeBetNumber;
            [orderLottNumVM.dataArrays addObject:numModel];
            numModel = nil;
        }];
        
    }

    [viewModel.orderDetailData addObject:orderLottNumVM];
    orderLottNumVM = nil;

    //订单列表投注号码底部展开与隐藏类型 Section
    if (apiResult.lotteryNumVoList.count > 3) {
        if (!isLeshan) {
        CLOrderDetailListViewModel* orderLottNumBottomVM = [[CLOrderDetailListViewModel alloc] init];
        orderLottNumBottomVM.dataType = CLORderDetaDataTypeLottNumBottom;
        [orderLottNumBottomVM.dataArrays addObject:@"展开"];
        [viewModel.orderDetailData addObject:orderLottNumBottomVM];
        }
    }
    
    
    //其他信息 Section
    CLOrderDetailListViewModel* orderMsgSectionVM = [[CLOrderDetailListViewModel alloc] init];
    orderMsgSectionVM.dataType = CLOrderDetaDataTypeOrderMsg;
    //添加两条cell 增加间距
    CLOrderDetailLineViewModel* nullStatusCn = [[CLOrderDetailLineViewModel alloc] init];
    nullStatusCn.title = nullStatusCn.content = @"";
    [orderMsgSectionVM.dataArrays addObject:nullStatusCn];
    
    CLOrderDetailLineViewModel* line1 = [[CLOrderDetailLineViewModel alloc] init];
    line1.title = @"投注信息:";
    line1.content = apiResult.betInfo;
    [orderMsgSectionVM.dataArrays addObject:line1];

    if ([apiResult.timeName isKindOfClass:NSString.class] && apiResult.timeName.length > 0) {
        CLOrderDetailLineViewModel* line2 = [[CLOrderDetailLineViewModel alloc] init];
        line2.title = [NSString stringWithFormat:@"%@:",apiResult.timeName];
        line2.content = apiResult.timeValue;
        
        
        if (apiResult.orderStatus == lotteryOrderStatusOverduePay){
            
        }else if (apiResult.orderStatus < lotteryOrderStatusPay) {
            [orderMsgSectionVM.dataArrays insertObject:line2 atIndex:orderMsgSectionVM.dataArrays.count - 1];
        }else{
            [orderMsgSectionVM.dataArrays addObject:line2];
        }
    }
    
    if (apiResult.ifShowTicket == 1) {
        CLOrderDetailLineViewModel* ticket = [[CLOrderDetailLineViewModel alloc] init];
        ticket.title = @"出票详情:";
        ticket.content = @"点击查看>";
        ticket.linkRange = NSMakeRange(0, ticket.content.length);
        [orderMsgSectionVM.dataArrays addObject:ticket];
    }
    
    CLOrderDetailLineViewModel* line3 = [[CLOrderDetailLineViewModel alloc] init];
    line3.title = @"订单编号:";
    line3.content = apiResult.orderId;
    [orderMsgSectionVM.dataArrays addObject:line3];
    
    CLOrderDetailLineViewModel* line4 = [[CLOrderDetailLineViewModel alloc] init];
    line4.title = @"温馨提示:";
    line4.content = apiResult.prompt;
    [orderMsgSectionVM.dataArrays addObject:line4];
    
    [viewModel.orderDetailData addObject:orderMsgSectionVM];
    
    return viewModel;
}

@end
