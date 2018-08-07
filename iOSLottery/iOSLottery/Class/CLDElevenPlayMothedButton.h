//
//  CLDElevenPlayMothedButton.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//
//   D11的玩法选择按钮
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CLDEAddBonusType) {
    
    CLDEAddBonusTypeNormal = 0,
    CLDEAddBonusTypeAddBonus,
    CLDEAddBonusTypeBonusToBonus
};
@interface CLDElevenPlayMothedButton : UIButton

@property (nonatomic, assign) CLDEAddBonusType bonusType;

@end
