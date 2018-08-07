//
//  CLUpgradePromptView.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/4/22.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLUpgradePromptView : UIView

@property (nonatomic, strong) NSString *updatePromptText;
@property (nonatomic, copy) void(^updateBlock)();

@end
