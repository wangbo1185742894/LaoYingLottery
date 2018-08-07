//
//  CLFTBetButtonView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/13.
//  Copyright © 2016年 caiqr. All rights reserved.
//
// 封装 快三 单独的 投注按钮
#import <UIKit/UIKit.h>
#import "CLFastThreeConfigMessage.h"

@interface CLFTBetButtonView : UIView

//UI展示的
@property (nonatomic, strong) NSString *bonusInfo;
@property (nonatomic, assign) BOOL is_Selected;//是否被选中
@property (nonatomic, strong) NSString *betNumber;//投注号码(UI)
@property (nonatomic, strong) UIFont *numberFont;//号码 字体 大小
@property (nonatomic, strong) NSString *betAward;//投注奖金(UI)
@property (nonatomic, strong) UIFont *awardFont;//号码 字体 大小
@property (nonatomic, copy) void(^betButtonClickBlock)(CLFTBetButtonView *);//点击时调用的方法
@property (nonatomic, copy) void(^betButtonSelectedBlock)(CLFTBetButtonView *);//选中态改变是调用的方法
//用于投注的属性
@property (nonatomic, strong) NSString *betTerm;//投注项
@end
