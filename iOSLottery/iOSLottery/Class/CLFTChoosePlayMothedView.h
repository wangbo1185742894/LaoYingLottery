//
//  CLFTChoosePlayMothedView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/11.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLFTChoosePlayMothedProtocol.h"

@interface CLFTChoosePlayMothedView : UIView

@property (nonatomic, weak) id<CLFTChoosePlayMothedProtocol> weakViewController;
@property (nonatomic, strong) NSString *gameEn;

- (void)selectedViewWithPlayMothed:(CLFastThreePlayMothedType)playMothedType;

/**
 刷新加奖标志
 */
- (void)reloadDataForAddBonus;
@end
 
