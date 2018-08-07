//
//  CLSFCHistoryView.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/27.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLSFCBetModel;

@interface CLSFCHistoryView : UIView

@property (nonatomic, strong) CLSFCBetModel *historyModel;

@property (nonatomic, copy) void(^onClickBlock)();

@end
