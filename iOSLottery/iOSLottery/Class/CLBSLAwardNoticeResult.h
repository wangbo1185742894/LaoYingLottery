//
//  CLBSLAwardNoticeResult.h
//  iOSLottery
//
//  Created by 小铭 on 2017/8/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//  开奖公告列表 篮球Cell内ResultView

#import <UIKit/UIKit.h>

@interface CLBSLAwardNoticeResult : UIView

@property (nonatomic, assign) NSInteger isCancel;

- (void)setDateWithString:(NSString *)str;

@end
