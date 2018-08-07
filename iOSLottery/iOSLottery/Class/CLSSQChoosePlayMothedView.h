//
//  CLSSQChoosePlayMothedView.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/2/27.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLSSQConfigMessage.h"
@interface CLSSQChoosePlayMothedView : UIView

@property (nonatomic, assign) CLSSQPlayMothedType playMothedType;
@property (nonatomic, copy) void(^switchPlayMothed)(CLSSQPlayMothedType);

@end
