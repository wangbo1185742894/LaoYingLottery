//
//  CLSFCMatchInfoView.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/26.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLSFCBetModel;

typedef void(^CLMatchInfoBlock)();

@interface CLSFCMatchInfoView : UIView

@property (nonatomic, strong) CLSFCBetModel *infoModel;

@property (nonatomic, copy) CLMatchInfoBlock isShowStory;

/**
 点击了历史战绩
 */
- (void)returnShowHistoryClick:(CLMatchInfoBlock)block;

@end
