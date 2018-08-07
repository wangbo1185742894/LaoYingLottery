//
//  UITableView+CLScreenCapture.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/6/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//  tableView 屏幕截取

#import <UIKit/UIKit.h>

@interface UITableView (CLScreenCapture)

/**
 截长图(contentSize)
 */
- (UIImage *)cl_captureImageOfContentSize;

/**
 截短图(frame)
 */
- (UIImage *)cl_captureImageOfFrame;

/**
 截取分享图片
 */
- (UIImage *)cl_captureShareImageOfContentAndAppIcon:(UIImage *)icon;

/** 滚动到可显示区域 */

- (void)scrollToAllShowArea:(NSIndexPath *)indexPath;
@end
