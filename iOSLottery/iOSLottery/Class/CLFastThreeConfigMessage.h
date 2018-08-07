//
//  CLFastThreeConfigMessage.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#ifndef CLFastThreeConfigMessage_h
#define CLFastThreeConfigMessage_h

#import "CLConfigMessage.h"

#pragma mark - 投注页面按钮之间的间距
#define MAINBETBUTTONDISTANCE 10.f //按钮之间的间距
#define MAINBETBUTTONEDGE 13.f //边距

#pragma mark ------ 快三 玩法 枚举 ------
typedef NS_ENUM(NSInteger, CLFastThreePlayMothedType){
    
    CLFastThreePlayMothedTypeHeZhi = 0, //和值
    CLFastThreePlayMothedTypeThreeSame, //三同号
    CLFastThreePlayMothedTypeTwoSame, //二同号
    CLFastThreePlayMothedTypeThreeDifferent, //三不同号
    CLFastThreePlayMothedTypeTwoDifferent, //二不同号
    CLFastThreePlayMothedTypeDanTuoThreeDifferent, //胆拖三不同号
    CLFastThreePlayMothedTypeDanTuoTwoDifferent //胆拖二不同号
    
};

#pragma mark ------ 投注页面请求的接口中 的 resultMap 的 key ------
static NSString const * awardStatus = @"awardStatus";
static NSString const * awardStatusCn = @"awardStatusCn";
static NSString const * awardTime = @"awardTime";
static NSString const * hezhi = @"hezhi";
static NSString const * awardShape = @"awardShape";
static NSString const * numberSize = @"awardStyle1";//大小
static NSString const * numberSingle = @"awardStyle2";//单双

#pragma mark ------ 摇一摇的通知名称 ------
static NSString  * shake_heZhi = @"shake_heZhi";//和值
static NSString  * shake_sameThree = @"shake_sameThree";//三同号
static NSString  * shake_sameTwo = @"shake_sameTwo";//二同号
static NSString  * shake_diffThree = @"shake_diffThree";//三不同号
static NSString  * shake_diffTwo = @"shake_diffTwo";//二不 同号

#endif /* CLFastThreeConfigMessage_h */
