//
//  CLRefreshHeaderCustomView.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/10.
//  Copyright © 2017年 caiqr. All rights reserved.
// 下拉刷新自定义View

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CLRefreshCustomViewStyle)
{
    CLRefreshCustomViewStyleGlay = 0,
    CLRefreshCustomViewStyleBlue,
};

@interface SLRefreshHeaderCustomView : UIImageView

@property (nonatomic, assign) CLRefreshCustomViewStyle customViewStyle;
@property (nonatomic, assign) CGAffineTransform contentTransFormValue;
- (void)startAnimating;
- (void)stopAnimating;

@end
