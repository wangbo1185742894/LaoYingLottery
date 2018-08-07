//
//  CBMatchSelectView.h
//  赛事筛选
//
//  Created by 任鹏杰 on 2017/5/9.
//  Copyright © 2017年 任鹏杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLMatchSelectView : UIView

@property (nonatomic, copy) void(^reloadLeagueMatchs)();

- (void)show;

@end
