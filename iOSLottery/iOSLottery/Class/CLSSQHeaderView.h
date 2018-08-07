//
//  CLSSQHeaderView.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/1.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLSSQHeaderView : UIView

@property (nonatomic, copy) void(^ssq_headViewOnClickBlock)();
@property (nonatomic, strong) UIImage *ssq_headerArrowImage;
@property (nonatomic, assign) BOOL rotationAnimation;

- (void)ssq_assigBetHeaderCurrentPeriodWithData:(NSString *)period endTime:(NSString *)endTime;

@end
