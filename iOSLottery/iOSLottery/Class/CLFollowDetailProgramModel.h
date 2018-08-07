//
//  CLFollowDetailProgramModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/18.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLFollowDetailProgramModel : CLBaseModel

@property (nonatomic, strong) NSString* orderId;        //订单id
@property (nonatomic, strong) NSString* orderTime;  //订单创建时间
@property (nonatomic, strong) NSString* gameName;   //彩种中文名称
@property (nonatomic, strong) NSString* periodId;   //期次ID
@property (nonatomic) double bonus;     //中奖金额
@property (nonatomic) double orderAmount;       //订单金额
@property (nonatomic) NSInteger orderStatus;        //订单状态码
@property (nonatomic, strong) NSString* orderStatusCn;      //订单状态中文
@property (nonatomic) NSInteger prizeStatus;    //中奖状态码
@property (nonatomic, assign) long click;//是否可以被点击

@end
