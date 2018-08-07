//
//  SLBetDetailFooterView.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/19.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLBetDetailBottomView : UIView

@property (nonatomic, copy) void(^payBlock)();
@property (nonatomic, copy) void(^chuanGuanShowBlock)(BOOL);
/**
 2串1是什么意思
 */
@property (nonatomic, copy) void(^twoChuanOneBlock)();

- (void)hiddenKeyBoard;

- (void)hiddenChuanGuanSelectView;

- (void)reloadBetDetailBottonViewUI;


@end
