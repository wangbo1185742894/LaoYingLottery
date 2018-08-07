//
//  CLDElevenConfigMessage.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#ifndef CLDElevenConfigMessage_h
#define CLDElevenConfigMessage_h

#pragma mark - D11玩法枚举
typedef NS_ENUM(NSInteger, CLDElevenPlayMothedType){
    
    CLDElevenPlayMothedTypeTwo = 0, //任 二
    CLDElevenPlayMothedTypeThree, //任 三
    CLDElevenPlayMothedTypeFour, //任 四
    CLDElevenPlayMothedTypeFive, //任 五
    CLDElevenPlayMothedTypeSix, //任 六
    CLDElevenPlayMothedTypeSeven, //任 七
    CLDElevenPlayMothedTypeEight, //任 八
    CLDElevenPlayMothedTypePreOne, //前一
    CLDElevenPlayMothedTypePreTwoDirect, //前二 直选
    CLDElevenPlayMothedTypePreTwoGroup, //前二 组选
    CLDElevenPlayMothedTypePreThreeDirect, //前三 直选
    CLDElevenPlayMothedTypePreThreeGroup, //前三 组选
    //胆拖
    CLDElevenPlayMothedTypeDTTwo = 12, //任 二
    CLDElevenPlayMothedTypeDTThree, //任 三
    CLDElevenPlayMothedTypeDTFour, //任 四
    CLDElevenPlayMothedTypeDTFive, //任 五
    CLDElevenPlayMothedTypeDTSix, //任 六
    CLDElevenPlayMothedTypeDTSeven, //任 七
    CLDElevenPlayMothedTypeDTEight, //任 八
    CLDElevenPlayMothedTypeDTPreTwoGroup, //前二 组选
    CLDElevenPlayMothedTypeDTPreThreeGroup //前三 组选
};

#pragma mark - D11 摇一摇通知名称
static NSString *dElevenShakeNotification = @"dElevenShakeNotification";




#endif /* CLDElevenConfigMessage_h */
