//
//  SLOrderDetailsRequest.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/24.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLOrderDetailsRequest.h"
#import "SLBODAllModel.h"
#import "CQDefinition.h"
#import "SLExternalService.h"

#import "SLConfigMessage.h"

#define SL_MessageHeight (__SCALE(25.f)) //下方信息cell的高度
#define SL_OrderStatusHeight (__SCALE(25.f)) //订单状态 的高度
#define SL_Max(a,b) a > b ? a : b //获取两数之间的大数

@interface SLOrderDetailsRequest ()

@property (nonatomic, strong) SLBODAllModel *mainModel;

@property (nonatomic, strong) SLBODHeaderViewModel *headerModel;

@end

@implementation SLOrderDetailsRequest

- (NSString *)requestBaseUrlSuffix{
    
    return @"/order/detail/jc";
}

- (NSDictionary *)requestBaseParams
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([SLExternalService getToken] && [SLExternalService getToken].length > 0) {
    
        [dic setObject:[SLExternalService getToken] forKey:@"token"];
    }
    if (self.order_id && self.order_id.length > 0) {
        [dic setObject:self.order_id forKey:@"orderId"];
    }
    return dic;
}

- (void)disposeDataDictionary:(NSDictionary *)data
{
 
    [self.mainModel mj_setKeyValues:data];
    
    
    
    [self configHeaderViewProcessData];
    
    [self configHeaderMoneyViewData];
    
    //[self configOrderStatusData];
    
    [self configBottomDetailInfo];
    
    self.headerModel.gameName = self.mainModel.gameName;
    self.headerModel.gameTypeCn = self.mainModel.gameTypeCn;
    self.headerModel.orderStatusCn = self.mainModel.orderStatusCn;
    self.headerModel.ifShowRefundDesc = self.mainModel.ifShowRefundDesc;
    self.headerModel.isBasketBall = [self.mainModel.gameEn isEqualToString:@"jclq_mix_p"];
    self.mainModel.ifShowBetButton = (self.mainModel.ifShowPay == 1)? NO : YES;
}

#pragma mark - 处理头部视图中流程图部分的数据

- (void)configHeaderViewProcessData
{
    SLBODHeaderProcessModel *processModel = [[SLBODHeaderProcessModel alloc] init];
    
    NSMutableArray *processMutableArr = [[NSMutableArray alloc] init];
    
    if (self.mainModel.statusProcess && self.mainModel.statusProcess.count > 0) {
        
        for (NSString *str in self.mainModel.statusProcess) {
            
            NSArray *arr = [str componentsSeparatedByString:@"_"];
            
            if (arr.count != 3) return;
            
            SLBODHeaderSubProcessModel *subProcessModel = [[SLBODHeaderSubProcessModel alloc] init];
            subProcessModel.title = arr[0];
            subProcessModel.number = arr[1];
            subProcessModel.status = arr[2];
            
            [processMutableArr addObject:subProcessModel];
        }
    }
    processModel.subProcessArr = processMutableArr;
    processModel.lineStatusArr = [self.mainModel.lineStatus componentsSeparatedByString:@","];
    self.headerModel.processModel = processModel;
}

#pragma mark - 处理头部视图中金额部分的数据
- (void)configHeaderMoneyViewData
{
    NSMutableArray *moneyArr = [NSMutableArray array];
    
    SLBODHeaderMoneyModel *moneyModel1 = [[SLBODHeaderMoneyModel alloc] init];
    moneyModel1.title = @"订单金额";
    moneyModel1.content = self.mainModel.orderAmount;
    moneyModel1.status = 0;
    moneyModel1.is_ChangeColor = 0;
    
    SLBODHeaderMoneyModel *moneyModel2 = [[SLBODHeaderMoneyModel alloc] init];
    moneyModel2.title = NSStringFromValidData(self.mainModel.bonusTitle);
    moneyModel2.content = self.mainModel.bonusStr;
    moneyModel2.status = 0;
    
    if (self.mainModel.prizeStatus > 1) {
        
        moneyModel2.is_ChangeColor = 1;
    }else{
        moneyModel2.is_ChangeColor = 0;
    }
    
    [moneyArr addObject:moneyModel1];
    [moneyArr addObject:moneyModel2];
    
    if (self.mainModel.ifShowPay == 1) {
        
            SLBODHeaderMoneyModel *moneyModel3 = [[SLBODHeaderMoneyModel alloc] init];
            
            moneyModel3.title = [NSString stringWithFormat:@"%ld",self.mainModel.endPayTime];
            moneyModel3.status = 2;
            moneyModel3.is_Rebuy = 0;
            moneyModel3.ifCountdown = self.mainModel.ifCountdown;
            [moneyArr addObject:moneyModel3];
        
    }
    
        
        if ((self.mainModel.orderStatus == SLOrderStatusBetSuccess || self.mainModel.orderStatus == SLOrderStatusRefund) && self.mainModel.prizeStatus == 1) {
            
            
            SLBODHeaderMoneyModel *moneyModel3 = [[SLBODHeaderMoneyModel alloc] init];
            
            moneyModel3.title = @"order_keep_on";
            moneyModel3.status = 1;
            [moneyArr addObject:moneyModel3];
            
        }else if ( (self.mainModel.orderStatus == SLOrderStatusBetSuccess || self.mainModel.orderStatus == SLOrderStatusRefund) && self.mainModel.prizeStatus > 1){
        
            SLBODHeaderMoneyModel *moneyModel3 = [[SLBODHeaderMoneyModel alloc] init];
            
            moneyModel3.title = @"order_win";
            moneyModel3.status = 1;
            [moneyArr addObject:moneyModel3];
        
        }
        
    
    
    self.headerModel.moneyViewArr = moneyArr;
}


#pragma mark - 处理订单状态 和 开奖状态数据
- (void)configOrderStatusData{
    //开奖状态  订单状态
    NSMutableArray *awardMArr = [[NSMutableArray alloc] init];
    if (NSStringFromValidData(self.mainModel.status_txt.order_status) && NSStringFromValidData(self.mainModel.status_txt.order_status).length > 0) {
        SLBODOrderMessageModel *awardMessageModel = [[SLBODOrderMessageModel alloc] init];
        awardMessageModel.title = @"订单状态:";
        awardMessageModel.content = NSStringFromValidData(self.mainModel.status_txt.order_status);
        if ([NSStringFromValidData(self.mainModel.status_txt.refund_link) isEqualToString:@"1"]) {
            awardMessageModel.is_Click = 10;//表示有退款说明按钮
        }
        awardMessageModel.messageHeight = SL_OrderStatusHeight;
        [awardMArr addObject:awardMessageModel];
    }
    if (NSStringFromValidData(self.mainModel.status_txt.bonus_status) && NSStringFromValidData(self.mainModel.status_txt.bonus_status).length > 0) {
        SLBODOrderMessageModel *awardMessageModel = [[SLBODOrderMessageModel alloc] init];
        awardMessageModel.title = @"开奖状态:";
        awardMessageModel.content = NSStringFromValidData(self.mainModel.status_txt.bonus_status);
        awardMessageModel.messageHeight = SL_OrderStatusHeight;
        [awardMArr addObject:awardMessageModel];
    }
    self.mainModel.awardStatusArr = awardMArr;
}


#pragma mark - 处理页面下方的订单信息数据
- (void)configBottomDetailInfo{
    //得到了网络数据后 解析成为需要的数据
    //1.解析下方信息类数据
    SLBODOrderMessageModel *model1 = [[SLBODOrderMessageModel alloc] init];
    model1.title = @"投注方式:";
    model1.content = self.mainModel.betInfo;
    
    if (NSStringFromValidData(self.mainModel.betInfo) && NSStringFromValidData(self.mainModel.betInfo).length > 0) {

        model1.messageHeight = [self LabelHeightWithText:NSStringFromValidData(self.mainModel.betInfo)];
    }else{
        model1.messageHeight = 0;
    }
    
    SLBODOrderMessageModel *model2 = [[SLBODOrderMessageModel alloc] init];
    
    model2.title = [NSString stringWithFormat:@"%@:",self.mainModel.timeName];
    model2.content = self.mainModel.timeValue;
    
    if (NSStringFromValidData(self.mainModel.timeValue) && NSStringFromValidData(self.mainModel.timeValue).length > 0) {
        
        model2.messageHeight = [self LabelHeightWithText:model2.content];
        
        //model2.is_Click = 11;
        
    }else{
        
        model2.messageHeight = 0;
    }
    
    SLBODOrderMessageModel *model3 = [[SLBODOrderMessageModel alloc] init];
    
    model3.title = @"出票方:";
    
    model3.content = [NSString stringWithFormat:@"%@",self.mainModel.postStationName];
    model3.is_Click = 22;

    if (self.mainModel.ifShowTicket == 1) {
        
        model3.messageHeight = [self LabelHeightWithText:model3.content];
        
    }else{
    
        model3.messageHeight = 0;
    }
    
    
    SLBODOrderMessageModel *model4 = [[SLBODOrderMessageModel alloc] init];
    
    model4.title = @"订单编号:";
    model4.content = self.mainModel.orderId;
    
    if (NSStringFromValidData(self.mainModel.orderId) && NSStringFromValidData(self.mainModel.orderId).length > 0) {
        
        model4.messageHeight = [self LabelHeightWithText:@"订单编号:"];
        
    }else{
        
        model4.messageHeight = 0;
    }
    
    
    SLBODOrderMessageModel *model5 = [[SLBODOrderMessageModel alloc] init];
    model5.title = @"温馨提示:";
    model5.content = [NSString stringWithFormat:@"%@", self.mainModel.prompt];
    
    if (NSStringFromValidData(self.mainModel.prompt) && NSStringFromValidData(self.mainModel.prompt).length > 0) {

        model5.messageHeight = [self LabelHeightWithText:NSStringFromValidData(model5.content)];
        
    }else{
        
        model5.messageHeight = 0;
    }
    
    self.mainModel.orderMessageModel = @[model1,model2,model3,model4,model5];
    
}

#pragma mark - 动态计算label的高度
- (CGFloat)LabelHeightWithText:(NSString *)string{
    
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = SL_FONT_SCALE(12.f);//设置文字大小
    
    //创建NSMutableParagraphStyle实例
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    //设置行距
    [style setLineSpacing:__SCALE(2.f)];
    attrs[NSParagraphStyleAttributeName] = style;
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - __SCALE(100), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return ceilf(size.height) + __SCALE(3.f);
}


- (id)getHeaderViewModel
{

    return self.headerModel;
}

- (id)getAllModel
{

    return self.mainModel;
}


- (SLBODAllModel *)mainModel
{

    if (_mainModel == nil) {
        
        _mainModel = [[SLBODAllModel alloc] init];
        
    }
    return _mainModel;
}

- (SLBODHeaderViewModel *)headerModel
{

    if (_headerModel == nil) {
        
        _headerModel = [[SLBODHeaderViewModel alloc] init];
    }
    return _headerModel;
}

@end
