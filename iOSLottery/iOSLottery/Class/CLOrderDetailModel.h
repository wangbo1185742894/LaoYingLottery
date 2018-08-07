//
//  CLOrderDetailModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"
#import <UIKit/UIKit.h>
#import "CLOrderDetailLineViewModel.h"

@class CLOrderDetailHeaderViewModel;

/* 列表 ViewModel */

typedef NS_ENUM(NSInteger, CLOrderDetaDataType) {
    
    CLOrderDetaDataTypeOrderState = 0,  //状态
    CLOrderDetaDataTypeBonusNum,        //开奖号码样式
    CLOrderDetaDataTypeLottNum,         //投注号码
    CLORderDetaDataTypeLottNumBottom,   //投注号码底部展开折叠
    CLOrderDetaDataTypeOrderMsg,        //基本信息
    CLOrderDetaDataTypeMatchList        //sfc彩种比赛列表样式
};

@interface CLOrderDetailListViewModel : CLBaseModel

@property (nonatomic) CLOrderDetaDataType dataType;
@property (nonatomic, strong) NSMutableArray* dataArrays;

@end


/* 订单详情ViewModel */

@interface CLOrderDetailModel : CLBaseModel

@property (nonatomic, assign) BOOL isShowFooterView;//是否展示底部视图
@property (nonatomic, strong) NSString *gameEn;
@property (nonatomic, strong) CLOrderDetailHeaderViewModel* orderHeaderData;   //头视图ViewModel
@property (nonatomic, strong) NSMutableArray<CLOrderDetailListViewModel*>* orderDetailData;  //列表ViewModel
@property (nonatomic, readwrite) BOOL isLeshan;
@end


/* 订单详情接口基础数据 */
@interface CLOrderDetailBasicModel : CLBaseModel

@property (nonatomic, strong) NSString* orderId;    //订单id唯一标识
@property (nonatomic, strong) NSString *gameEn;
@property (nonatomic, assign) long ifShowPay;
@property (nonatomic, readwrite) BOOL dltLsActivity; //是否是乐善码活动

@property (nonatomic, strong) NSString* userCode;   //用户唯一标识
@property (nonatomic, strong) NSString* gameName;   //彩种中文名称
@property (nonatomic, strong) NSString* periodId;   //彩种期次Id
@property (nonatomic, strong) NSString* winningNumbers; //彩种开奖号码  如果没有则null
@property (nonatomic, strong) NSString *winningNumberColor;//开奖号码的颜色
@property (nonatomic, strong) NSString *bonusTitle;//中奖奖金
@property (nonatomic, strong) NSString *bonusColor;//中奖奖金颜色
@property (nonatomic, strong) NSString *bonusStr;//中奖奖金的desp

@property (nonatomic) double bonus;     //订单奖金
@property (nonatomic) double orderAmount;   //订单金额
@property (nonatomic) NSInteger orderType;  //订单状态 1:普通投注 2:追号
@property (nonatomic) long long saleEndTime;    //期次售卖截止时间  秒数

@property (nonatomic, strong) NSArray* statusProcess;
@property (nonatomic, strong) NSString* lineStatus;     //小球之间的两条线   0：表示灰色  1：表示红色
@property (nonatomic)   NSInteger prizeStatus;  //订单中奖状态码
@property (nonatomic, strong) NSString* prizeStatusCn;//订单中奖信息
@property (nonatomic) NSInteger orderStatus;
@property (nonatomic, strong) NSString* orderStatusCn;  //订单状态中文，页面中间显示

@property (nonatomic) NSInteger ifShowRefundDesc;//是否显示退款说明
@property (nonatomic) NSInteger ifShowTicket;   //是否显示出票详情
@property (nonatomic, strong) NSString* bonusAmountTxt;
@property (nonatomic, strong) NSString* bonusAmountValue;
@property (nonatomic, strong) NSString* betInfo;    //投注信息
@property (nonatomic, strong) NSString* prompt;
@property (nonatomic, strong) NSString* postStationName;    //出票店信息
@property (nonatomic, strong) NSString* timeName;   //订单未支付
@property (nonatomic, strong) NSString* timeValue;
@property (nonatomic) NSInteger ifShow; //是否显示继续支付按钮   0:不显示  1:显示
@property (nonatomic, strong) NSArray* lotteryNumVoList;    //具体投注选项 (区分彩种)
@property (nonatomic, strong) NSArray *lotteryNumLSVoList; //乐善码
@property (nonatomic, strong) NSString *awardTimeValue;//开奖时间

/**
 胜负彩赛果信息
 */
@property (nonatomic, strong) NSArray *sfcMatchVoList;

/**
 继续支付时间是否倒计时(0:不倒计时  1:倒计时)
 */
@property(nonatomic, assign ) NSInteger ifCountdown;

@end



