//
//  SLScreenCaptureView.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/6/2.
//  Copyright © 2017年 caiqr. All rights reserved.
//  分享截屏View

#import <UIKit/UIKit.h>

@interface CLScreenCaptureView : UIView

@property (nonatomic, strong) UIImage *captureImage;
/**
 分享顶部标题文字
 */
@property (nonatomic, strong) NSString *topTitle;

@end
