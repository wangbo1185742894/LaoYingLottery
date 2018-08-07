//
//  UILabel+SLCountDown.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/6/19.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SLCountDown)

@property (nonatomic, strong) NSTimer *timer;
/**
 倒计时的秒数
 */
@property (nonatomic, strong) NSNumber *seconds;

/**
 倒计时结束后显示的文字
 */
@property (nonatomic, strong) NSString *countDownEndText;

- (void)setCountDownText:(NSString *)text;

- (void)stopCountDown;

@end
