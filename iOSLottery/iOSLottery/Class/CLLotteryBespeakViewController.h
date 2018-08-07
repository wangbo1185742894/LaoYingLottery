//
//  CLLotteryBespeakViewController.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/10.
//  Copyright © 2017年 caiqr. All rights reserved.
// 支付成功后 彩票店预约 即抢单动画

#import "CLBaseViewController.h"
#import "CLBaseModel.h"
@class DALabeledCircularProgressView;
@class CLBespeakLotteryModel;

typedef NS_ENUM(NSInteger , CLLotteryBespeakType) {
    
    CLLotteryBespeakTypeNone = 0,//不展示
    CLLotteryBespeakTypeAnimation, //展示动画
    CLLotteryBespeakTypeNoAnimation //不展示动画
};

@interface CLLotteryBespeakViewController : CLBaseViewController

/** 前一页面截图 */
@property (nonatomic, strong) UIImage* snapView;

@property (nonatomic, strong) CLBespeakLotteryModel* lotteryBespeak;

@property (nonatomic, copy) void(^bespeakCompletion)(void);

@end

#pragma mark - Source Class

@interface CLBespeakLotteryModel : CLBaseModel
@property (nonatomic, assign) long ifShowPostName;//是否显示彩票店信息
@property (nonatomic, strong) NSString *postStationName;//彩票店名字
@property (nonatomic, assign) long counter;
@property (nonatomic, strong) NSString *soldInfo;
@property (nonatomic, strong) NSString *saleInfo;

/*"postStationName":"",   //彩票店名称
"ifShowPostName":0,             //不展示动画和图片
"soldInfo":"家彩票点抢单中", //彩票店抢单信息
"saleInfo":"抢单成功",  //订单销售信息
"counter":3*/

@end

@interface CQBesPeakAnimateView : UIView

@property (nonatomic, strong) DALabeledCircularProgressView* labeledProgressView;
@property (nonatomic, strong) UILabel* msgLbl;
@property (nonatomic, strong) UILabel* flagLbl;
@property (nonatomic, strong) CALayer* successLayer;
@property (nonatomic, strong) UIImageView* bottomImgView;
@property (nonatomic, strong) CLBespeakLotteryModel* model;

@end

@interface CQBesPeakImgView : UIView

@property (nonatomic, strong) UILabel* msgLbl;
@property (nonatomic, strong) UILabel* flagLbl;
@property (nonatomic, strong) UIImageView* bottomImgView;
@property (nonatomic, strong) CLBespeakLotteryModel* model;

@end

