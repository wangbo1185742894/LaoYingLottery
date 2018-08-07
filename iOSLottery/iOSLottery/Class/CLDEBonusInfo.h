//
//  CLDEBonusInfo.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/13.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLDEBonusInfo : NSObject

@property (nonatomic, assign) long bonus_de_preOne;
@property (nonatomic, assign) long bonus_de_preTwoGroup;
@property (nonatomic, assign) long bonus_de_preTwoDirect;
@property (nonatomic, assign) long bonus_de_preThreeGroup;
@property (nonatomic, assign) long bonus_de_preThreeDirect;
@property (nonatomic, assign) long bonus_de_anyTwo;
@property (nonatomic, assign) long bonus_de_anyThree;
@property (nonatomic, assign) long bonus_de_anyFour;
@property (nonatomic, assign) long bonus_de_anyFive;
@property (nonatomic, assign) long bonus_de_anySix;
@property (nonatomic, assign) long bonus_de_anySeven;
@property (nonatomic, assign) long bonus_de_anyEight;
/*"1":13,//前一
"2":65,//前二组选
"3":130,//前二直选
"4":195,//前三组选
"5":1170,//前三直选
"6":6,//任选二
"7":19,//任选三
"8":78,//任选四
"9":540,//任选五
"10":90,//任选六
"11":26,//任选七
"12":9//任选八*/

- (void)setBonusInfoData:(NSDictionary *)bonusInfo;
@end
