//
//  CLPlayMothedOptionView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/11.
//  Copyright © 2016年 caiqr. All rights reserved.
//快三 选择玩法页封装的按钮

#import <UIKit/UIKit.h>
#import "CLFastThreeConfigMessage.h"
#import "CLFTChoosePlayMothedProtocol.h"

typedef NS_ENUM(NSInteger, CLFTPlayMothedBonusType) {
    
    CLFTPlayMothedBonusTypeNormal = 0,
    CLFTPlayMothedBonusTypeAddBonus,//加奖
    CLFTPlayMothedBonusTypeBonusToBonus//奖上奖
};

@interface CLPlayMothedOptionView : UIView

@property (nonatomic, weak) id<CLFTChoosePlayMothedProtocol> delegate;
@property (nonatomic, strong) NSString *playMothedName;//玩法名称
@property (nonatomic, strong) NSString *awardBonus;//奖金
@property (nonatomic, strong) NSArray *imagesArray;//骰子数组
@property (nonatomic, assign) BOOL isShowPlus;//是否显示加号
@property (nonatomic, assign) CLFTPlayMothedBonusType bonusType;
@property (nonatomic, assign) CLFastThreePlayMothedType playMothedType;//玩法类型
@property (nonatomic, assign) BOOL is_selected;//是否被选中
@end
