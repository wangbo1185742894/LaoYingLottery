//
//  SLMatchBetHelperView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//  帮助 查看更多view

#import <UIKit/UIKit.h>

@interface SLMatchBetHelperView : UIView

@property (nonatomic, copy) void(^helperButtonBlock)(UIButton *);
@property (nonatomic, strong) NSArray *titleArray;//titleView

@end
