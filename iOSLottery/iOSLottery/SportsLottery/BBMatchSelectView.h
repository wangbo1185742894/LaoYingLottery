//
//  BBMatchSelectView.h
//  SportsLottery
//
//  Created by 小铭 on 2017/8/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//  篮球筛选页面

#import <UIKit/UIKit.h>

@interface BBMatchSelectView : UIView

@property (nonatomic, copy) void(^reloadLeagueMatchs)();

- (void)show;

@end
