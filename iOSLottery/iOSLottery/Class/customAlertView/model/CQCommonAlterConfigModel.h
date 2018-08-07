//
//  CQCommonAlterConfig.h
//  caiqr
//
//  Created by 洪利 on 2017/3/29.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 弹窗加入control后选择加入的队列
 注：展示在window上的弹窗因不属于任何VC，可以再任何时刻展示，此类可以归属于Global队列中
    如活动、更新、引导等 需要在特定的某一VC上展示，并且有VC发起注册到Control的 则需要选择common，归属到VC名下的队列中
 
    Global队列会在 活跃的common执行过程中向common中添加全局弹窗，执行后同步清除
 - CQAlertQueueStyleCommon: 默认common类型，单独属于某一vc的
 */
typedef NS_ENUM(NSInteger, CQAlertQueueStyle) {
    CQAlertQueueStyleCommon = 0,//单一某一vc的
    CQAlertQueueStyleGlobal = 1 //全局
};


/**
 弹窗加载方式

 - CQAlertViewShowStyleDefault: 默认交由control实现 addsubview操作
 如果想自己实现addsubView操作 则需要选择BySelf模式,并提供弹窗类名，然后实现Control的canShowAlert 方法
 */
typedef NS_ENUM(NSInteger, CQAlertViewShowStyle) {
    CQAlertViewShowStyleDefault = 0,// 指定窗和父视图 由control 实现加载
    CQAlertViewShowStyleBySelf = 1  //在接收到control的消息后自主实现加载
};


/**
 优先级

 - CQAlertViewDisPlayedOptionDefault: 默认default
 */
typedef NS_ENUM(NSInteger, CQAlertViewDisPlayedOption) {
    CQAlertViewDisPlayedOptionDefault = 0, //活动、更新、中奖、掉线
    CQAlertViewDisPlayedOptionNormal = 100,//新手引导
    CQAlertViewDisPlayedOptionHight = 200, //三帧
    CQAlertViewDisPlayedOptionHigher = 300,//广告
    CQAlertViewDisPlayedOptionHightHighest = 400  //闪屏
};

@interface CQCommonAlterConfigModel : NSObject

@property (nonatomic, assign) CQAlertViewDisPlayedOption option;//优先级
@property (nonatomic, strong) NSString *style;//展示形式
@property (nonatomic, weak) id superView;//父视图
@property (nonatomic, weak) id alertView;//弹窗
@property (nonatomic, assign) CQAlertQueueStyle queeStyel;//队列类型
//自主实现加载需要的属性
@property (nonatomic, strong) NSString *alertViewClassName;
@property (nonatomic, assign) CQAlertViewShowStyle showStyle;


//
//
//
//
//
//- (void)getAlter:(NSString *)alterName
//   withSuperView:(id)superview
//        complete:(void (^)(CQCommonAlterConfigModel *model, NSError *))complete;
//
//



@end

