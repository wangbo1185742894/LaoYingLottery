//
//  CQBODAllModel.h
//  caiqr
//
//  Created by huangyuchen on 16/7/27.
//  Copyright © 2016年 Paul. All rights reserved.
//
//投注订单详情页面的所有数据模型
//wiki 网址 ： https://gitlab.caiqr.com/caiqr/lottery/wikis/%E7%AB%9E%E5%BD%A9%E8%B6%B3%E7%90%83%E8%AE%A2%E5%8D%95%E8%AF%A6%E6%83%85真票订单详情接口


#import "SLBaseModel.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CQBetOrderStatusType) {
    
    CQBetOrderStatusTypeNoPay = 10,  //未支付
    CQBetOrderStatusTypeWaitOrder = 11, //等待发单
    CQBetOrderStatusTypeBilling,     //出票中
    CQBetOrderStatusTypeAllDeal,    //全部成交
    CQBetOrderStatusTypePartDeal,  //部分成交
    CQBetOrderStatusTypeOrderFail  //订单失败
    
};

#pragma mark - 全部数据
@class CQBODProgrammeInfoModel,CQBODAwardStatusModel,SLBODOrderMessageModel,SLBODHeaderViewModel,CQBODNotWinModel;
@interface SLBODAllModel : SLBaseModel
@property (nonatomic, strong) NSString *lottery_code;

/**
 用户ID
 */
@property (nonatomic, strong) NSString *userCode;

/**
 订单ID
 */
@property (nonatomic, strong) NSString *orderId;

/**
 彩种中文名
 */
@property (nonatomic, strong) NSString *gameTypeCn;

/**
 彩种英文名
 */
@property (nonatomic, strong) NSString *gameEn;

/**
 玩法描述
 */
@property (nonatomic, strong) NSString *gameName;

/**
 订单金额
 */
@property (nonatomic, strong) NSString *orderAmount;

/**
 订单截止支付时间
 */
@property (nonatomic, assign) NSInteger endPayTime;

/**
 投注方式
 */
@property (nonatomic, strong) NSString *betInfo;

/**
 待确定？
 */
@property (nonatomic, strong) NSString *create_time;

/**
 温馨提示文字
 */
@property (nonatomic, strong) NSString *prompt;

/**
 退款说明文字
 */
@property (nonatomic, strong) NSString *orderStatusCn;


@property (nonatomic, strong) CQBODNotWinModel *activity_status;

/**
 投注内容数组
 */
@property (nonatomic, strong) NSArray<CQBODProgrammeInfoModel *> *betMatchVos;



/**
 出票店信息
 */
@property (nonatomic, strong) NSString *postStationName;


/**
 截止时间
 */
@property (nonatomic, strong) NSString *timeName;

/**
 日期字符串
 */
@property (nonatomic, strong) NSString *timeValue;

/**
 订单状态
 */
@property (nonatomic, strong) NSArray *statusProcess;

/**
 订单状态里的线的状态
 */
@property (nonatomic, strong) NSString *lineStatus;

/**
 中奖奖金
 */
@property (nonatomic, strong) NSString *bonusTitle;

/**
 中奖金额
 */
@property (nonatomic, strong) NSString *bonusStr;

/**
 中奖状态 0:未开奖 1:未中奖 >1 中奖
 */
@property (nonatomic, assign) NSInteger prizeStatus;

/**
 是否显示支付按钮
 */
@property (nonatomic, assign) NSInteger ifShowPay;

/**
 是否显示底部立即投注按钮
 */
@property (nonatomic, assign) BOOL ifShowBetButton;

/**
 是否显示分享按钮
 */
@property (nonatomic, assign) NSInteger ifShowShareButton;

/**
 是否显示出票详情
 */
@property (nonatomic, assign) NSInteger ifShowTicket;

/**
 是否显示退款说明
 */
@property (nonatomic, assign) NSInteger ifShowRefundDesc;

/**
 继续支付时间是否倒计时(0:不倒计时  1:倒计时)
 */
@property(nonatomic, assign ) NSInteger ifCountdown;


@property (nonatomic, strong) NSString *bonus_amount_value;

@property (nonatomic, assign) long orderStatus;

@property (nonatomic, strong) CQBODAwardStatusModel *status_txt;

@property (nonatomic, strong) NSArray<SLBODOrderMessageModel *> *awardStatusArr;//订单状态 和开奖状态


@property (nonatomic, assign) long is_bonus;//是否有图片


@property (nonatomic, strong) NSArray<SLBODOrderMessageModel *> *orderMessageModel;//订单信息

@property (nonatomic, assign) CGFloat *oneProgrammeInfoHeight;//用于记录cell的高度

@property (nonatomic, strong) SLBODHeaderViewModel *headerModel;//头部视图的数据

/** 订单渠道 */
@property (nonatomic, assign) NSInteger type;
    
@end


/**
*                  "match_id":"20160723001",
                    "weeksn":"周六001",
                    "home":"墨尔本胜利",
                    "away":"尤文图斯",
                    "socre":"", #比分
                    "betting_info":[
                        {
                            "play_msg":"胜平负", #玩法
                            "play_result":"", #赛果
                            "betting_list":[ #投注项
                                "主胜(5.15)",
                                "平(4.25)",
                                "主负(1.43)"
                            ]
                        }
                    ]
                },

 */


#pragma mark - 未中奖再接再厉
@interface CQBODNotWinModel : SLBaseModel
@property (nonatomic, strong) NSString *activity_bg_url;
@property (nonatomic, strong) NSString *activity_dy_url;
@property (nonatomic, assign) NSInteger click_status;
@end




#pragma mark - 赛事信息
@class CQBODBettingInfoModel;
@interface CQBODProgrammeInfoModel : SLBaseModel

/**
 比赛ID
 */
@property (nonatomic, strong) NSString *matchIssuse;

/**
 赛事场次信息
 */
@property (nonatomic, strong) NSString *matchIssueCn;

/**
 主队名
 */
@property (nonatomic, strong) NSString *hostTeam;

/**
 客队名
 */
@property (nonatomic, strong) NSString *awayTeam;

/**
 比分
 */
@property (nonatomic, strong) NSString *score;

/**
 比分颜色
 */
@property (nonatomic, strong) NSString *scoreColor;

/**
 让球颜色
 */
@property (nonatomic, strong) NSString *handicapColor;

/**
 预测底层页
 */
@property (nonatomic, strong) NSString *bottomPage;

/**
 赛事是否取消
 */
@property (nonatomic, assign) NSInteger ifMatchCancel;


@property (nonatomic, strong) NSArray<CQBODBettingInfoModel *> *betMaps;
@property (nonatomic, assign) CGFloat programmeInfoHeight;//用于记录整个二级tableView的高度

@end
/**
*                      {
                            "play_msg":"胜平负", #玩法
                            "play_result":"", #赛果
                            "betting_list":[ #投注项
                                "主胜(5.15)",
                                "平(4.25)",
                                "主负(1.43)"
                            ]
                        }
 */
#pragma mark - 投注内容
@interface CQBODBettingInfoModel : SLBaseModel

/**
 玩法中文名
 */
@property (nonatomic, strong) NSString *playTypeCn;

/**
 比赛赛果
 */
@property (nonatomic, strong) NSString *matchResult;
/**
 投注内容
 */
@property (nonatomic, strong) NSArray *betItem;
/**
 用于记录二级tableView的cell的高度（即 富文本的高度）
 */
@property (nonatomic, assign) CGFloat bettingInfoHeight;//用于记录二级tableView的cell的高度（即 富文本的高度）
/**
 让球颜色
 */
@property (nonatomic, strong) NSString *handicapColor;

@end

/*
 "status_txt":{
                 "order_status":"待支付", #订单状态
                 "bonus_status":"", #开奖状态
                 "refund_link":"0"  #退款说明连接是否有
             },
 */
#pragma mark - 开奖状态
@interface CQBODAwardStatusModel : SLBaseModel

@property (nonatomic, strong) NSString *order_status;
@property (nonatomic, strong) NSString *bonus_status;
@property (nonatomic, strong) NSString *refund_link;

@end

#pragma mark - 订单信息（投注时间  截止时间等等）
@interface SLBODOrderMessageModel : SLBaseModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger is_Click;
@property (nonatomic, assign) CGFloat messageHeight;
@end

#pragma mark - 头部视图的数据模型
@class SLBODHeaderMoneyModel;
@class SLBODHeaderProcessModel;
@interface SLBODHeaderViewModel : SLBaseModel

@property (nonatomic, strong) NSMutableArray<SLBODHeaderMoneyModel *> *moneyViewArr;
@property (nonatomic, strong) SLBODHeaderProcessModel *processModel;

/**
 订单玩法类型
 */
@property (nonatomic, strong) NSString *gameName;

/**
 玩法中文名
 */
@property (nonatomic, strong) NSString *gameTypeCn;

/**
 退款说明文字
 */
@property (nonatomic, strong) NSString *orderStatusCn;

/**
 是否显示退款说明
 */
@property (nonatomic, assign) NSInteger ifShowRefundDesc;
/** 是不是篮球 */
@property (nonatomic, readwrite) BOOL isBasketBall;

@property (nonatomic, strong) NSString *lottery_code;


@end
#pragma mark - 头部视图中 金额 是否中奖 等数据
@interface SLBODHeaderMoneyModel : SLBaseModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *backtitle;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger status;//显示图片还是倒计时 还是文字
@property (nonatomic, assign) NSInteger is_ChangeColor;
@property (nonatomic, assign) NSInteger is_Rebuy;

@property (nonatomic, assign) NSInteger ifCountdown;

@property (nonatomic, strong) CQBODNotWinModel *activity_status;


@end

#pragma mark - 头部视图中 流程图数据
@class SLBODHeaderSubProcessModel;
@interface SLBODHeaderProcessModel : SLBaseModel

@property (nonatomic, strong) NSArray<SLBODHeaderSubProcessModel *> *subProcessArr;
@property (nonatomic, strong) NSArray *lineStatusArr;

@end
#pragma mark - 单独一个视图的model
@interface SLBODHeaderSubProcessModel : SLBaseModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *status;

@end

