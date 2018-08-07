//
//  CLDElevenChoosePlayMothedView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLDElevenConfigMessage.h"
@interface CLDElevenChoosePlayMothedView : UIView

@property (nonatomic, strong) NSString *gameEn;

@property (nonatomic, copy) void(^dElevenChoosePlayMothedBlock)(CLDElevenPlayMothedType);

/**
 当前玩法
 */
@property (nonatomic, assign) CLDElevenPlayMothedType currentPlayMothedType;
/**
 刷新加奖标志
 */
- (void)reloadDataForAddBonus;
@end
