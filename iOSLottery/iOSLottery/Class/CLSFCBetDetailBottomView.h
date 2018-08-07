//
//  CLSFCBetDetailBottomView.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/27.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLSFCBetDetailBottomView : UIView

@property (nonatomic, copy) void(^payBlock)();

- (void)hiddenKeyBoard;

- (void)reloadBetDetailBottonViewUI;

@end
